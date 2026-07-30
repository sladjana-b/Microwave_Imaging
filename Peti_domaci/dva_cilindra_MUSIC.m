clear; close all; clc

f = 2;
M = 18;
nx = 50;
ny = 50;
nz = 1;

N = 8;               % vrednost sa grafika singular.vredn


[Y0,Z0,S0] = ReadAD1('dva_cilindra.ad1',f,M);
[Y1,Z1,S1] = ReadAD1('niz.ad1',f,M);
[x1,y1,z1,Ex1,Ey1,Ez1,Hx1,Hy1,Hz1] = ReadNF1('niz.nf1',nx,ny,nz,M);

dS = S0 - S1;
[U,Sigma,V] = svd(dS);

singVr = diag(Sigma);
maxSingVr = max(singVr);
normSingVr = singVr/maxSingVr;

figure
stem(normSingVr)

I = zeros(nx,ny);

for ix = 1:nx
    for iy = 1:ny

        sum = 0;
        g = squeeze(Ez1(ix,iy,1,1:M));

        for m = N+1:M
            um = U(:,m);
            sum = sum+abs(dot(um, g))^2;
        end

        I(ix,iy) = 1/sum;
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
title(['MUSIC,  N = ' num2str(N)])
daspect([1,1,1]);