clear;
clc;

load('.\real data\data.mat');
for i = 1 : size(src_model,1)
    if src_model(i,3) < 0
        src_model(i,3) = src_model(i,3) + 2*pi;
    end
end

lambda = 0.336845458426966;  % wave length
sigma = 0.1;   % variance of white noise
C0 = 0.8;
B = 2e6;    % bandwidth  

R_user = zeros(10,3,121);

for theta_update = 1 : 10
    for theta_i_one_update = 1 : 3
        r0_angle = directions(theta_update,theta_i_one_update) / 360 * 2 * pi;  % the target direction in current beamforming
        r0 = [cos(r0_angle) sin(r0_angle)];
        
        p = xyz;  % location of 19 antennas on the BS

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%% matched beamforming weights %%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        w = zeros(size(p,1), 1);
        for i = 1 : size(p,1)
            w(i) =  exp(-1i * 2*pi * dot(p(i,:), r0) / lambda);
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%% beam shape for matched beamforming %%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        N = size(src_model,1);  % number of users
        r_user = src_model(:,1:2);  % position of the users

        b = zeros(N, 1); % beam shape
        b_gain = zeros(N, 1);  % gain of each antenna
        for j = 1 : N
            for i = 1 : size(p,1)
                b(j) = b(j) + w(i) * exp(1i * 2*pi * dot(p(i,:), r_user(j,:)) / lambda);
            end
            b_gain(j) = abs(b(j));
        end
        
        grid on;
        scatter(src_model(:,3),b_gain,'filled');
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%% calculate data rate by AWGN channel %%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for i = 1 : N
            R_user(theta_update, theta_i_one_update, i) = B * log2(1 + (b_gain(i) / sigma) * C0);
        end
        
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         %%%%%%%%% beam shape for matched beamforming %%%%%%%%
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         N = 10000;  % sample on the circle: r = 5
%         r = zeros(N, 2);
%         for i = 1 : N
%             theta_i = i / N * 2 * pi;
%             r(i,:) = [cos(theta_i) sin(theta_i)];
%         end
% 
%         b = zeros(N, 1); % beam shape
%         b_gain = zeros(N, 1);  % gain of each antenna
%         for j = 1 : N
%             for i = 1 : 19
%                 b(j) = b(j) + w(i) * exp(1i * 2*pi * dot(p(i,:), r(j,:)) / (lambda));
%             end
%             b_gain(j) = abs(b(j));
%         end
%         polarplot([1:1:N] / N * 2*pi,b_gain)
        
    end
end

R_aver = mean(R_user,'all') / size(src_model,1);
