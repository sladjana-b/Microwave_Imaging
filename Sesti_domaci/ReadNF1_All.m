function [x, y, z, Ex, Ey, Ez, Hx, Hy, Hz] = ReadNF1_All(name, nx, ny, nz, nw, Nf)


    jot = sqrt(-1);
    fid = fopen(name, 'rt');
    if fid < 0
        error('ne otvara se fajl %s', name);
    end

    Ex = zeros(nx, ny, nz, nw, Nf);
    Ey = zeros(nx, ny, nz, nw, Nf);
    Ez = zeros(nx, ny, nz, nw, Nf);
    Hx = zeros(nx, ny, nz, nw, Nf);
    Hy = zeros(nx, ny, nz, nw, Nf);
    Hz = zeros(nx, ny, nz, nw, Nf);

    for p = 1:Nf                
        for l = 1:nw            
            fgetl(fid);          
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
            fgetl(fid);         
        end
    end

    fclose(fid);
end
