clear;
clc;

lambda = 0.01;  % wave length
radius = 10;
sigma = 0.1;   % variance of white noise
C0 = 0.8;
B = 2e6;    % bandwidth  

r0 = [radius radius] / sqrt(2); % position of the UE, theta = 45, r = radius

p = zeros(96, 2);  % position of antennas on BS, three circle with r = 0.05, 0.15 and 0.25
for i = 1 : 32
    alpha_i = i / 32 * 2 * pi; % angle of each antenna
    p(i,:) = 0.05 * [cos(alpha_i) sin(alpha_i)]; 
end
for i = 33 : 64
    alpha_i = (i-32) / 32 * 2 * pi; % angle of each antenna
    p(i,:) = 0.07 * [cos(alpha_i) sin(alpha_i)]; 
end
for i = 65 : 96
    alpha_i = (i-64) / 32 * 2 * pi; % angle of each antenna
    p(i,:) = 0.09 * [cos(alpha_i) sin(alpha_i)]; 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% matched beamforming weights %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
w = zeros(96, 1);
for i = 1 : 96
    w(i) = exp(-1i * 2*pi * norm(p(i,:) - r0) / lambda) / 10;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% beam shape for matched beamforming %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N = 100000;  % sample on the circle: r = 5
r = zeros(N, 2);
var = 10; % Guassian distribution's variance
interval = 50; % uniform distribution's interval
for i = 1 : N
    %theta_i = (45 + randn * sqrt(var)) / 360 * 2 * pi;
    theta_i = (45 + (rand-0.5) * interval) / 360 * 2 * pi;
    r(i,:) = radius * [cos(theta_i) sin(theta_i)];
end

b = zeros(N, 1); % beam shape
b_gain = zeros(N, 1);  % gain of each antenna
for j = 1 : N
    for i = 1 : 96
        b(j) = b(j) + w(i) * exp(1i * 2*pi * norm(p(i,:) - r(j,:)) / lambda);
    end
    b_gain(j) = abs(b(j));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% calculate data rate by AWGN channel %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
R_sample = zeros(N, 1);  % SNR of each sample
for i = 1 : N
    R_sample(i) = B * log2(1 + (b_gain(i) / sigma) * C0);
end
R_aver = mean(R_sample,'all'); % calculate the average


%plot([1:1:N], b_gain)
scatter(r(:,1),r(:,2))
%db_b_gain = 10 * log(b_gain);
%rmin = min(db_b_gain);
%rmax = max(db_b_gain);
%polarplot([1:1:N] / N * 2*pi,b_gain)
%rlim([rmin rmax])