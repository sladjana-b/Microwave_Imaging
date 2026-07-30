clear; clc;
close all;

f = 1e9;      
M = 36;
R = 0.6;
c = 3e8;
jot = sqrt(-1);
n = 50;
w = 2*pi*f;

[Y0, Z0, S0] = ReadAD1('nizM36_1GHz.ad1', f, M);
[Y, Z, S] = ReadAD1('cilindarM36_1GHz.ad1', f, M);

DS = S - S0;

x = linspace(-0.2, 0.2, n);
y = linspace(-0.2, 0.2, n);

xi = zeros(1, M);
yi = zeros(1, M);

for i = 1:M
    xi(i) = R*cos(2*pi*(i-1)/M);
    yi(i) = R*sin(2*pi*(i-1)/M);
end

I = zeros(n,n);

for k = 1:n
    for l = 1:n
        for i = 1:M
            for j = 1:M

                T = (sqrt((x(k)-xi(i))^2 + (y(l)-yi(i))^2) + ...
                    sqrt((x(k)-xi(j))^2 + (y(l)-yi(j))^2))/c;

                I(k,l) = I(k,l) + DS(i,j)*exp(jot*w*T);

            end
        end
    end
end

I = abs(I);
I = I/max(max(I));

image(x,y,I','CDataMapping','scaled');
set(gca,'YDir','normal');
colormap('jet');
colorbar('location','EastOutside');
set(gca,'fontsize',30,'TickDir','in');
daspect([1,1,1]);
title(['f = ', num2str(f/1e9), ' GHz']);