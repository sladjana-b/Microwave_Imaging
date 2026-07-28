function [x y z Ex Ey Ez Hx Hy Hz] = ReadNF1(name,nx,ny,nz,nw)

jot=sqrt(-1);
% Function reads near field electric and magnetic field data
% for multiple incident waves at ONE frequency
% nx, ny, nz - number of near field points
% nw - number of ports
fid = fopen(name,'rt');

for l=1:nw
    %read the first line of the file
    tline=fgetl(fid);
    
    for i=1:nx
        for j=1:ny
            for k=1:nz
                
                %read x,y,z
                x1=fscanf(fid,'%e',[1,1]);
                y1=fscanf(fid,'%e',[1,1]);
                z1=fscanf(fid,'%e',[1,1]);
                
                Ex(i,j,k,l)=fscanf(fid,'%e',[1,1])+jot*fscanf(fid,'%e',[1,1]);
                Ey(i,j,k,l)=fscanf(fid,'%e',[1,1])+jot*fscanf(fid,'%e',[1,1]);
                Ez(i,j,k,l)=fscanf(fid,'%e',[1,1])+jot*fscanf(fid,'%e',[1,1]);
                
                Hx(i,j,k,l)=fscanf(fid,'%e',[1,1])+jot*fscanf(fid,'%e',[1,1]);
                Hy(i,j,k,l)=fscanf(fid,'%e',[1,1])+jot*fscanf(fid,'%e',[1,1]);
                Hz(i,j,k,l)=fscanf(fid,'%e',[1,1])+jot*fscanf(fid,'%e',[1,1]);
                z(k)=z1;
                
                
                              
            end
            y(j)=y1;
        end
        x(i)=x1;
    end
    tline=fgetl(fid);    
end
fclose(fid) ;

end
