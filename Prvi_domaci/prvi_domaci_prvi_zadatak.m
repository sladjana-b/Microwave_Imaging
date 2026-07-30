f=3e9;
c0=3e8;
lambda=c0/f;
beta=2*pi/lambda;
N=360;
j=sqrt(-1);
d=0.05;
M=21;

for antena=1:(M-1) %1..20  antena 
    V(antena)=S(antena+1, 1) 
end

phi = 0:2*pi/N: 2*pi; %0..360 stepeni [rad]
for ugao=1:N+1 %po uglu
    phi_b = phi(ugao);
    suma(ugao) = 0;

    for element=1:(M-1)
        suma(ugao) = suma(ugao)+V(element)*exp(-j*beta*d*(element-1)*cos(phi_b));
    end
end 

suma_ukupna = abs(suma)/max(abs(suma));
phi_u = (phi/pi)*180; 
plot(phi_u, suma_ukupna);
xlabel('phi')
ylabel('normalizovan odziv')
xlim([0 350]);