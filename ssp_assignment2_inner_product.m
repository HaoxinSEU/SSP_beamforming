clear;
clc;

lambda = 0.1;  % wave length
radius = 20;
r0 = [radius radius] / sqrt(2); % position of the UE, theta = 45, r = radius

p = zeros(96, 2);  % position of antennas on BS, three circle with r = 0.05, 0.07 and 0.09, ...
for i = 1 : 16
    alpha_i = i / 16 * 2 * pi; % angle of each antenna
    p(i,:) = 0.05 * [cos(alpha_i) sin(alpha_i)]; 
end
for i = 17 : 32
    alpha_i = (i-16) / 16 * 2 * pi; % angle of each antenna
    p(i,:) = 0.07 * [cos(alpha_i) sin(alpha_i)]; 
end
for i = 33 : 48
    alpha_i = (i-32) / 16 * 2 * pi; % angle of each antenna
    p(i,:) = 0.09 * [cos(alpha_i) sin(alpha_i)]; 
end
for i = 49 : 64
    alpha_i = (i-48) / 16 * 2 * pi; % angle of each antenna
    p(i,:) = 0.11 * [cos(alpha_i) sin(alpha_i)]; 
end
for i = 65 : 80
    alpha_i = (i-64) / 16 * 2 * pi; % angle of each antenna
    p(i,:) = 0.13 * [cos(alpha_i) sin(alpha_i)]; 
end
for i = 81 : 96
    alpha_i = (i-80) / 16 * 2 * pi; % angle of each antenna
    p(i,:) = 0.15 * [cos(alpha_i) sin(alpha_i)]; 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% flexibeam to gain beamforming weights %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
w = zeros(96, 1);
w_ampl = zeros(96, 1);
Theta = 100 / 360 * 2 * pi;
sigma = sqrt(2 - 2 * cos(Theta)) * radius;
for i = 1 : 96
    w_ampl(i) = exp(-2 * (pi^2) * (sigma^2) * (norm(p(i,:))^2));
    w(i) = w_ampl(i) * exp(-1i * 2*pi * dot(p(i,:), r0) / (radius * lambda));
    %w(i) = exp(-1i * 2*pi * dot(p(i,:), r0));
end

sum_w_norm = 0;
for i = 1 : 96
    sum_w_norm = sum_w_norm + abs(w(i))^2;
end
% 
% for i = 1 : 96
%     w(i) = w(i) / sqrt(sum_w_norm);
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% beam shape for flexibeam %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N = 10000;  % sample on the circle: r = 100
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

%plot([1:1:N], b_gain)
polarplot([1:1:N] / N * 2*pi,b_gain)
