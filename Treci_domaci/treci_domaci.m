clear;
clc;
close all;

M = 25;          
f = 1;           
Nx = 40;
Ny = 40;
Nz = 1;

x = linspace(-0.3, 0.3, Nx);
y = linspace(-0.3, 0.3, Ny);

[Z0, Y0, S0] = ReadAD1('array_DIPOLES.ad1', f, M);     
[Z1, Y1, S1] = ReadAD1('ground_OBJECT.ad1', f, M);     

[x0, y0, z0, Ex0, Ey0, Ez0, Hx0, Hy0, Hz0] = ReadNF1('array_DIPOLES.nf1', Nx, Ny, Nz, M);

dS = S1 - S0;

I = zeros(Nx, Ny);

for tx = 1:M
    for rx = 1:M
        for ix = 1:Nx
            for iy = 1:Ny

                polje = Ex0(ix,iy,1,tx) * Ex0(ix,iy,1,rx) + Ey0(ix,iy,1,tx) * Ey0(ix,iy,1,rx) + ...
                    Ez0(ix,iy,1,tx) * Ez0(ix,iy,1,rx);

                I(ix,iy) = I(ix,iy) + dS(tx,rx) * conj(polje);

            end
        end
    end
end

I = abs(I);
I = I / max(I(:));

figure;
imagesc(x, y, I.');
set(gca, 'YDir', 'normal');
axis equal tight;
colormap jet;
colorbar;
xlabel('x [m]');
ylabel('y [m]');
set(gca, 'FontSize', 18, 'TickDir', 'in');