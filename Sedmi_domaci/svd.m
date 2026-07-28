clear; clc; close all;

M = 18;
f = 2;

[Y0, Z0, S0] = ReadAD1('niz06.ad1',   f, M);% samo niz
[Y1, Z1, S1] = ReadAD1('cil_ba01.ad1', f, M);% beta*a = 0.1
[Y2, Z2, S2] = ReadAD1('cil_ba1.ad1',  f, M);% beta*a = 1
[Y3, Z3, S3] = ReadAD1('cil_ba2.ad1',  f, M);% beta*a = 2

L1 = S1 - S0;
L2 = S2 - S0;
L3 = S3 - S0;

[U1, Sigma1, V1] = svd(L1);
[U2, Sigma2, V2] = svd(L2);
[U3, Sigma3, V3] = svd(L3);

singVr1 = diag(Sigma1);
singVr2 = diag(Sigma2);
singVr3 = diag(Sigma3);

normSingVr1 = singVr1/max(singVr1);
normSingVr2 = singVr2/max(singVr2);
normSingVr3 = singVr3/max(singVr3);

figure

subplot(3,1,1)
stem(normSingVr1)
ylabel('sigma_n/sigma_1')
title('beta a = 0.1')
ylim([0 1.05]);

subplot(3,1,2)
stem(normSingVr2)
ylabel('sigma_n/sigma_1')
title('beta a = 1')
ylim([0 1.05]); 

subplot(3,1,3)
stem(normSingVr3)
xlabel('n')
ylabel('sigma_n/sigma_1')
title('beta a = 2')
ylim([0 1.05]);
