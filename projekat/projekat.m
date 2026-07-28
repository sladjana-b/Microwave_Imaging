clear; clc; close all;

M  = 21;                     % 21 antena
f  = 1;                      % indeks/jedina ucestanost (1 GHz)
nx = 40; ny = 50; nz = 30;   % 3D mreza iz PDF-a
NP = nx*ny*nz;               % 60000 voksela

% --- merenje: SA ugruskom (target) - BEZ (background) ---
[Y0,Z0,S0] = ReadAD1('Head_5_domain.ad1',        f, M);   % BEZ
[Y1,Z1,S1] = ReadAD1('Head_5_domain_STROKE.ad1', f, M);   % SA ugruskom
[x1,y1,z1,Ex1,Ey1,Ez1] = ReadNF1('Head_5_domain.nf1', nx,ny,nz, M);  % polje iz BEZ modela

dS = S1 - S0;
dS = reshape(dS, M^2, 1);        % 441 x 1

% --- matrica sistema L (red = par tx-rx, kolona = voksel) ---
L = zeros(M^2, NP);
red = 0;
for tx = 1:M
    for rx = 1:M
        red = red + 1;
        kolona = 0;
        for iz = 1:nz            % <-- ix je NAJUNUTRASNJA petlja,
            for iy = 1:ny        %     da se voksel-redosled poklopi
                for ix = 1:nx    %     sa reshape([nx ny nz]) nize
                    kolona = kolona + 1;
                    L(red,kolona) = ...
                        Ex1(ix,iy,iz,tx)*Ex1(ix,iy,iz,rx) + ...
                        Ey1(ix,iy,iz,tx)*Ey1(ix,iy,iz,rx) + ...
                        Ez1(ix,iy,iz,tx)*Ez1(ix,iy,iz,rx);
                end
            end
        end
    end
end

% --- SVD + prag K ---
[U,GAMMA,V] = svd(L,'econ');     % 'econ' OBAVEZNO (L je 441 x 60000)
sigma = diag(GAMMA);
sigma_max = max(sigma);
K = find(sigma >= 0.01*sigma_max, 1, 'last');

% --- TSVD suma (isto kao tvoj zadatak) ---
dEps = zeros(NP,1);
for n = 1:K
    dEps = dEps + (1/sigma(n))*(U(:,n)'*dS)*V(:,n);
end

% --- slika ---
dEps = abs(dEps);
dEps = dEps/max(dEps);
Vimg = reshape(dEps, [nx, ny, nz]);   % isti redosled kao petlje gore

% pik = polozaj ugruska
[~, ind] = max(Vimg(:));
[ix, iy, iz] = ind2sub(size(Vimg), ind);
fprintf('Ugrusak: x=%.1f, y=%.1f, z=%.1f mm\n', x1(ix)*1000, y1(iy)*1000, z1(iz)*1000);

% presek kroz pik (y-z ravan) = Slika 2 iz PDF-a
figure
imagesc(y1, z1, squeeze(Vimg(ix,:,:)).'); axis xy image;
colormap('jet'); colorbar; caxis([0 1]);
xlabel('y [m]'); ylabel('z [m]');
title(sprintf('TSVD rekonstrukcija, presek x=%.0f mm', x1(ix)*1000));

figure; plot(sigma/sigma_max); xlabel('n'); ylabel('\sigma_n/\sigma_1'); grid on;