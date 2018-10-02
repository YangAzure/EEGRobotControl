%% Author: Zhiwei Luo, Yang Shi
 
%% Reading data, interpolation
function V = precondition(address,fs)
f = fopen(address,'r');
C = textscan(f,'%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f:%f:%f','HeaderLines',6);
fclose(f);
M = cell2mat(C);
M = [M(:,2:17), M(:,21)*3600 + M(:,22)*60 + M(:,23)];
S = int32((M(size(M,1),17) - M(1,17))*1000);
[T,IA,IC] = unique(M(:,17));
T = T*1000;
V = linspace(T(1), T(size(T,1)), S);
V = [zeros(size(V,2), 16), V'];
V(linspace(1,size(T,1),size(T,1)),1:16) = M(IA,1:16);
for i=1:16
    V(:,i) = interp1(T, V(1:size(T,1),i), V(:,17));
end
d = fdesign.lowpass('Fp,Fst,Ap,Ast',0.2,0.25,1,60);
Hd = design(d,'equiripple');
V = filter(Hd,V);
I = round(linspace(1,floor(size(V,1)/4)*4,floor(size(V,1)/4)+1));
V = V(I,1:16);

t = linspace(0,length(V)/fs,length(V));

figure;
for i=1:16
    subplot(4,4,i);
    plot(t,V(:,i));
end
end

