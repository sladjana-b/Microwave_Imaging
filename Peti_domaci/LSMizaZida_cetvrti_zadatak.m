f=1;
M=21;
nx=50;
ny=50;
nz=1;

[Y0, Z0, S0] = ReadAD1('objekat.ad1',f,M);
[Y1, Z1, S1] = ReadAD1('zid.ad1',f,M);
[x1, y1, z1, Ex1, Ey1, Ez1, Hx1, Hy1, Hz1] = ReadNF1('zid.nf1',nx,ny,nz,M);

dS=S1-S0;
[U, Sigma, V]=svd(dS);
singVr=diag(Sigma);
maxSingVr=max(singVr);
normSingVr=singVr/maxSingVr;

figure,
stem(normSingVr);

alpha = 0.01*maxSingVr;

I = zeros(nx,ny);
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


I(i,j) = 1/s;
x=linspace(0.25,2.25,50);
y=linspace(-1,1,50);

I=I/max(max(I));
figure,
image(x,y,I','CDataMapping','scaled');
set(gca,'YDir','normal')
ctb=colormap('jet');
colormap(ctb);
colorbar('location','EastOutside');
set(gca,'fontsize',30,'TickDir','in');
daspect([1,1,1]);