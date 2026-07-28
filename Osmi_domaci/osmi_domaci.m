clear; close all; clc

M=144;
f=1e9;
ia=87e-3;
R=0.3;
c=3e8;
lambda=c/f;
h=lambda/20;
omega=2*pi*f;
eps=8.8542e-12;
nx=5;
ny=5;
nz=5;


deltaV=ia^3/(nx*ny*nz);
x=linspace(-0.5*ia, 0.5*ia, nx);
y=linspace(-0.5*ia, 0.5*ia, ny);
z=linspace(-0.5*ia, 0.5*ia, nz);

eps_tekuce=	3.003-1.0079i;

[Y1, Z1, S1]=ReadAD1('kocka.ad1', 1, M);
[x1, y1, z1, Ex1, Ey1, Ez1, Hx1, Hy1, Hz1]=ReadNF1('kocka.nf1', nx, ny, nz, M);

[Y2, Z2, S2]=ReadAD1('kocka5.ad1', 1, M);
[x2, y2, z2, Ex2, Ey2, Ez2, Hx2, Hy2, Hz2]=ReadNF1('kocka5.nf1', nx, ny, nz, M);

Gzz=zeros(M,nx,ny,nz);
for i=1:M
    for ia=1:nx
        for b=1:ny
            for d=1:nz
                Gzz(i,ia,b,d)=Ez2(ia,b,d,i)*Z2(i,i)/h;
            end
        end
    end
end

A=zeros(M^2,1);
for i=1:M
    for k=1:M
        for ia=1:nx
            for b=1:ny
                for d=1:nz
                    A((i-1)*M+k,1)=A((i-1)*M+k,1)+Gzz(k,ia,b,d)*Ez2(ia,b,d,i);
                end
            end
        end
    end
end

A=1j*omega*eps*deltaV*A;

Es=zeros(M^2,1);
for i=1:M
    for k=1:M
        Es((i-1)*M+k,1)=-( Z1(k,i)/(Z1(i,i)*h) - Z2(k,i)/(Z2(i,i)*h) );
    end
end

tau=A\Es;

eps_novo=eps_tekuce+tau;

disp(['tau      : ' num2str(tau)])
disp(['eps_novo : ' num2str(eps_novo)])