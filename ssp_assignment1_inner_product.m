clear;
clc;

lambda = 0.01;  % wave length
radius = 10;
r0 = [radius radius] / sqrt(2); % position of the UE, theta = 45, r = radius

p = zeros(96, 2);  % position of antennas on BS, three circle with r = 0.05, 0.15 and 0.25
for i = 1 : 32
    alpha_i = i / 32 * 2 * pi; % angle of each antenna
    p(i,:) = 0.05 * [cos(alpha_i) sin(alpha_i)]; 
end
for i = 33 : 64
    alpha_i = (i-32) / 32 * 2 * pi; % angle of each antenna
    p(i,:) = 0.055 * [cos(alpha_i) sin(alpha_i)]; 
end
for i = 65 : 96
    alpha_i = (i-64) / 32 * 2 * pi; % angle of each antenna
    p(i,:) = 0.06 * [cos(alpha_i) sin(alpha_i)]; 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% matched beamforming weights %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
w = zeros(96, 1);
for i = 1 : 96
    w(i) = exp(-1i * 2*pi * dot(p(i,:), r0) / (radius * lambda));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% beam shape for matched beamforming %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N = 10000;  % sample on the circle: r = 5
r = zeros(N, 2);
for i = 1 : N
    theta_i = i / N * 2 * pi;
    r(i,:) = radius * [cos(theta_i) sin(theta_i)];
end

b = zeros(N, 1); % beam shape
b_gain = zeros(N, 1);  % gain of each antenna
for j = 1 : N
    for i = 1 : 96
        b(j) = b(j) + w(i) * exp(1i * 2*pi * dot(p(i,:), r(j,:)) / (radius * lambda));
    end
    b_gain(j) = abs(b(j));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% calculate SNR by AWGN channel %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%plot([1:1:N], b)
%db_b_gain = 10 * log(b_gain);
%rmin = min(db_b_gain);
%rmax = max(db_b_gain);
polarplot([1:1:N] / N * 2*pi,b_gain)
%rlim([rmin rmax])