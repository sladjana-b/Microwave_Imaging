clear; clc;
close all;

f_central = 10e9;
P = 9;
f = linspace(0.95*f_central, 1.05*f_central, P);
M = 21;
M_ukupno = 2*M^2;      % 882 porta (dva niza po M^2 antena)

nx = 21; ny = 21; nz = 1;
M_E = 2;               % broj generatora u Einc modelu: (0,0,0) i (0,0,D)

[Y0, Z0, S0] = ReadAD1('objekat.ad1', f, M_ukupno);  
[Y1, Z1, S1] = ReadAD1('niz.ad1',    f, M_ukupno);    

[x1, y1, z1, Ex1, Ey1, Ez1, Hx1, Hy1, Hz1] = ...
    ReadNF1_All('Einc.nf1', nx, ny, nz, M_E, P);

% naspramni parovi 
DELTA = S0 - S1;                 
dS = zeros(M, M, P);
l = 0;
for ix = 1:nx
    for iy = 1:ny
        l = l + 2;
        dS(ix, iy, :) = DELTA(l-1, l, :);   % par naspramnih antena: portovi l-1 i l
    end
end


DS = zeros(M, M, P);
for p = 1:P
    DS(:,:,p) = fft2(dS(:,:,p));
end


% g = (polje od antene na (0,0,0)) * (polje od antene na (0,0,D))
G = zeros(M, M, P);
for p = 1:P
    for k = 1:M
        for ll = 1:M
            G(k, ll, p) = Ex1(M-k+1, M-ll+1, 1, 1, p) * ...
                          Ex1(M-k+1, M-ll+1, 1, 2, p);
        end
    end
end

G_fft = zeros(M, M, P);
for p = 1:P
    G_fft(:,:,p) = fft2(G(:,:,p));
end


% w = (g^H g)^-1 (g^H s) - pseudoinverz
w = zeros(M, M);
for i = 1:M
    for j = 1:M
        gij = squeeze(G_fft(i, j, :));   % P x 1
        Eij = squeeze(DS(i, j, :));      % P x 1  (merenje)
        w(i, j) = (gij' * gij) \ (gij' * Eij);
    end
end


W = ifft2(w);
W = fftshift(W);
W = abs(W);
W = W / max(W(:));               % normalizacija na [0,1]

x = linspace(-1.5, 1.5, M);
y = linspace(-1.5, 1.5, M);

figure;
imagesc(x, y, W);
set(gca, 'YDir', 'normal');
colormap('jet');
colorbar('location', 'EastOutside');
daspect([1 1 1]);
set(gca, 'fontsize', 14, 'TickDir', 'in');
xlabel('x [m]'); ylabel('y [m]');
