function [Y Z S] = ReadAD1(name,f,N)
%Function reads WIPL ad1 file
%N number of ports
%f frequency vector
fid = fopen(name,'rt');

%read the first line of the file
tline=fgetl(fid);

for l=1:length(f)
    for i=1:N
        for k=1:N
            
            %read frequency
            dummy1=fscanf(fid,'%e',[1,1]);
            
            %read the indeces of the ports
            dummy2=fscanf(fid,'%d%d',[1,2]);
            
            Y(i,k,l)=fscanf(fid,'%e',[1,1])+j*fscanf(fid,'%e',[1,1]);
            Z(i,k,l)=fscanf(fid,'%e',[1,1])+j*fscanf(fid,'%e',[1,1]);
            S(i,k,l)=fscanf(fid,'%e',[1,1])+j*fscanf(fid,'%e',[1,1]);
        end
    end
end


fclose(fid) ;


end
