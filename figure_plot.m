data_rate_gau = [12563396.5001982 9492805.54283997 8394501.32098756 7729486.94555076 7222237.96349580 6900572.95445629];
data_rate_uni = [12563396.5001982 9289354.13213487 6651652.54414867 5731457.62844642 5068358.75117899 4929738.13103567];
variance = [0 10 20 30 40 50];

figure(1);
plot(variance, data_rate_gau, '-ro');
title('Average data rate with different variances');
xlabel('variance of the Gaussian distribution');
ylabel('average data rate');
grid on;

figure(2);
plot(variance, data_rate_uni, '-ro');
title('Average data rate with different intervals');
xlabel('interval of the uniform distribution');
ylabel('average data rate');
grid on;


