clear; close all; clc

f = 2;
M = 18;
nx = 50;
ny = 50;
nz = 1;

dodaj_sum = false;   
SNR = 10;

[Y0,Z0,S0] = ReadAD1('dva_cilindra_3v_01m.ad1',f,M);
[Y1,Z1,S1] = ReadAD1('niz.ad1',f,M);
[x1,y1,z1,Ex1,Ey1,Ez1,Hx1,Hy1,Hz1] = ReadNF1('niz.nf1',nx,ny,nz,M);

dS = S0 - S1;

if dodaj_sum
    for i=1:M
        sig=dS(:,i);
        sig=awgn(sig,SNR,'measured');
        dS(:,i)=sig;
    end
end

[U,Sigma,V] = svd(dS);

singVr = diag(Sigma);
maxSingVr = max(singVr);
normSingVr = singVr/maxSingVr;

figure
stem(normSingVr)

I = zeros(nx,ny);

alpha = 0.1*maxSingVr;
for i=1:nx
    for j=1:ny
        g = squeeze(Ez1(i,j,1,:));
        s = 0;
        for m=1:M
            w = singVr(m)/(singVr(m)^2 + alpha^2);
            s = s + abs(w*(U(:,m)'*g))^2;
        end
        I(i,j) = 1/s;
    end
end

x = linspace(min(x1(:)), max(x1(:)), nx);
y = linspace(min(y1(:)), max(y1(:)), ny);

I = I/max(max(I));

figure
image(x,y,I','CDataMapping','scaled');
set(gca,'YDir','normal')
ctb = colormap('jet');
colormap(ctb);
colorbar('location','EastOutside');
xlabel('x [m]')
ylabel('y [m]')
title('LSM dva cilindra, alfa=0.1, bez suma')
daspect([1,1,1]);