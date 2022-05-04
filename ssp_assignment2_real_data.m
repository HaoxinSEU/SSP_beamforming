clear;
clc;

load('.\real data\data.mat');
for i = 1 : size(src_model,1)
    if src_model(i,3) < 0
        src_model(i,3) = src_model(i,3) + 2*pi;
    end
end

lambda = 0.336845458426966;  % wave length

Theta = 20 / 360 * 2 * pi;
sigma = sqrt(2 - 2 * cos(Theta));

C0 = 0.8;
B = 2e6;    % bandwidth  


R_user = zeros(10,3,121);

for Theta_i = 1: 15
Theta = (Theta_i-1)*10 / 360 * 2 * pi;
sigma = sqrt(2 - 2 * cos(Theta));
%for theta_update = 1 : 10
for theta_update = 1 : 1    
    %for theta_i_one_update = 1 : 3
    for theta_i_one_update = 1 : 1
        r0_angle = directions(theta_update,theta_i_one_update) / 360 * 2 * pi;  % the target direction in current beamforming
        r0 = [cos(r0_angle) sin(r0_angle)];
        
        p(1:19,:) = xyz;  % location of 19 antennas on the BS
        p(20:38,:) = xyz * 0.5;
        p(39:57,:) = xyz * 2;
        p(58:76,:) = xyz * 2.5;
        p(77:95,:) = xyz * 3;
        p(96:114,:) = xyz * 3.5;
        p(115:133,:) = xyz * 4;
        p(134:152,:) = xyz * 4.5;

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%% matched beamforming weights %%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        w = zeros(size(p,1), 1);
        w_ampl = zeros(size(p,1), 1);
        for i = 1 : size(p,1)
            w_ampl(i) = exp(-2 * (pi^2) * (sigma^2) * (norm(p(i,:))^2) / (lambda^2));
            w(i) = w_ampl(i) * exp(-1i * 2*pi * dot(p(i,:), r0) / lambda);
        end
        
        sum_w_norm = 0;
        for i = 1 : size(p,1)
            sum_w_norm = sum_w_norm + abs(w(i))^2;
        end

        for i = 1 : size(p,1)
            w(i) = w(i) / sqrt(sum_w_norm);
        end

        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%% beam shape for matched beamforming %%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        N = 10000;  % sample on the circle
        r = zeros(N, 2);
        for i = 1 : N
            theta_i = i / N * 2 * pi;
            r(i,:) = [cos(theta_i) sin(theta_i)];
        end

        b = zeros(N, 1); % beam shape
        b_gain = zeros(N, 1);  % gain of each antenna
        b_gain_max = 0;
        for j = 1 : N
            for i = 1 : size(p,1)
                b(j) = b(j) + w(i) * exp(1i * 2*pi * dot(p(i,:), r(j,:)) / (lambda));
            end
            b_gain(j) = abs(b(j));
            if b_gain(j) > b_gain_max
                b_gain_max = b_gain(j);
            end
        end
        b_gain = b_gain / b_gain_max;
        legend_str{Theta_i} = num2str(Theta_i);
        polarplot([1:1:N] / N * 2*pi,b_gain);
        hold on;
        
    end
end
end
legend(legend_str);

R_aver = mean(R_user,'all') / size(src_model,1);
