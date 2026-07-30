clear
clc;
close all;

M=44;
f=1e9;
nx=50;
ny=50;
nz=1;

[Y0,Z0,S0] = ReadAD1('background.ad1',f,M);
[Y1,Z1,S1] = ReadAD1('target.ad1',f,M);

[x1,y1,z1,Ex1,Ey1,Ez1,Hx1,Hy1,Hz1] = ReadNF1('background.nf1',nx,ny,nz,M);

dS = S1-S0;
dS = reshape(dS,M^2,1); %mora biti dimenzija 1936x1 zbog deltaS=L*deltaEps

red = 0;      % brojac TX-RX parova
L = zeros(M^2,nx*ny); %1936x2500

for tx = 1:M %biram predajnu antenu, tx=1, antena 1 emituje

    for rx = 1:M %za taj predajnik biramo prijemnik, tx1-rx1

        red = red + 1; %prvi primopredajni par imamo upisan u prvi red matrice L

        kolona = 0; %tacke prostora 50x50=2500, hocemo za 1.par txrx pregledamo prostor ispocetka
        %dakle prvi txrx par proveri tacku 1, tacku 2..

        for ix = 1:nx %biramo x poziciju, ix=1

            for iy = 1:ny %biramo y poziciju, iy=1

                kolona = kolona + 1;

                L(red,kolona) = ...
                    Ex1(ix,iy,1,tx)*Ex1(ix,iy,1,rx) + ...
                    Ey1(ix,iy,1,tx)*Ey1(ix,iy,1,rx) + ...
                    Ez1(ix,iy,1,tx)*Ez1(ix,iy,1,rx);
                %L()=Etx*Erx, skalarni proizvod
            end

        end

    end

end

[U,GAMMA,V] = svd(L);

sigma = diag(GAMMA);

sigma_max = max(sigma);

K = find(sigma >= 0.01*sigma_max,1,'last');

dEps = zeros(nx*ny,1);

for n = 1:K

    dEps = dEps + ...
        (1/sigma(n))*(U(:,n)'*dS)*V(:,n);

end

dEps = reshape(dEps,nx,ny); %vraca vektor od 2500 vrednosti u 50x50 sliku

x = linspace(min(x1(:)), max(x1(:)), nx);
y = linspace(min(y1(:)), max(y1(:)), ny);

dEps = abs(dEps);
dEps = dEps/max(max(dEps));

figure
image(x,y,dEps,'CDataMapping','scaled');
set(gca,'YDir','normal')

ctb = colormap('jet');
colormap(ctb);

colorbar('location','EastOutside');

set(gca,'fontsize',30,'TickDir','in');

daspect([1 1 1]);

figure
plot(sigma/sigma_max);

