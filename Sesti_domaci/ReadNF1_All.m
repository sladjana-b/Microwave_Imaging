function [x, y, z, Ex, Ey, Ez, Hx, Hy, Hz] = ReadNF1_All(name, nx, ny, nz, nw, Nf)
% Cita blisko polje (E i H) za SVE frekvencije odjednom.
% Izlaz je 5-D niz: (nx, ny, nz, nw, Nf).
%   nx, ny, nz - broj tacaka bliskog polja po osama
%   nw         - broj generatora (portova); ovde 2: (0,0,0) i (0,0,D)
%   Nf         - broj frekvencija u fajlu
%
% Napomena: ova verzija cita sekvencijalno (ne "preskace"), pa nema
% bag oko poravnanja linija koji je imala ReadNF1_MultiFreq.

    jot = sqrt(-1);
    fid = fopen(name, 'rt');
    if fid < 0
        error('Ne mogu da otvorim fajl: %s', name);
    end

    % Prealokacija (5-D: tacke x generatori x frekvencije)
    Ex = zeros(nx, ny, nz, nw, Nf);
    Ey = zeros(nx, ny, nz, nw, Nf);
    Ez = zeros(nx, ny, nz, nw, Nf);
    Hx = zeros(nx, ny, nz, nw, Nf);
    Hy = zeros(nx, ny, nz, nw, Nf);
    Hz = zeros(nx, ny, nz, nw, Nf);

    for p = 1:Nf                 % petlja po frekvencijama
        for l = 1:nw             % petlja po generatorima (portovima)
            fgetl(fid);          % zaglavlje bloka (kao u originalnom ReadNF1)
            for i = 1:nx
                for jj = 1:ny
                    for k = 1:nz
                        x1 = fscanf(fid, '%e', 1);
                        y1 = fscanf(fid, '%e', 1);
                        z1 = fscanf(fid, '%e', 1);

                        Ex(i,jj,k,l,p) = fscanf(fid,'%e',1) + jot*fscanf(fid,'%e',1);
                        Ey(i,jj,k,l,p) = fscanf(fid,'%e',1) + jot*fscanf(fid,'%e',1);
                        Ez(i,jj,k,l,p) = fscanf(fid,'%e',1) + jot*fscanf(fid,'%e',1);

                        Hx(i,jj,k,l,p) = fscanf(fid,'%e',1) + jot*fscanf(fid,'%e',1);
                        Hy(i,jj,k,l,p) = fscanf(fid,'%e',1) + jot*fscanf(fid,'%e',1);
                        Hz(i,jj,k,l,p) = fscanf(fid,'%e',1) + jot*fscanf(fid,'%e',1);

                        z(k) = z1;
                    end
                    y(jj) = y1;
                end
                x(i) = x1;
            end
            fgetl(fid);          % zavrsna linija bloka
        end
    end

    fclose(fid);
end
