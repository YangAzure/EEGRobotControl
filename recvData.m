disp('Now receiving data...');
fs = 250;
lowB = 3;
highB = 40;
windowSize = 128;
M = [];
d = fdesign.lowpass('Fp,Fst,Ap,Ast',0.2,0.25,1,60);
Hd = design(d,'equiripple');
[b,a] = butter(4, [3,40]/(fs/2), 'bandpass');
right = imread('arrowR.jpeg');
left = fliplr(right);
stop = imread('stop.jpeg');
record = [];
% tport = tcpclient('192.200.1.101', 12346);
figure
while true
    % get data from the inlet
    [vec,ts] = inlet.pull_chunk();
    Min = [vec', ts'];
    if size(Min,1) > 0
        M = [M; Min];
        if size(M,1) > windowSize
            S = int32((M(size(M,1),17) - M(1,17))*1000);
            [T,IA,IC] = unique(M(:,17));
            T = T*1000;
            V = linspace(T(1), T(size(T,1)), S);
            V = [zeros(size(V,2), 16), V'];
            V(linspace(1,size(T,1),size(T,1)),1:16) = M(IA,1:16);
            for i=1:16
                V(:,i) = interp1(T, V(1:size(T,1),i), V(:,17));
            end
            V = filter(Hd,V);
            I = round(linspace(1,floor(size(V,1)/4)*4,floor(size(V,1)/4)+1));
            V = V(I,1:16);
            % plot(V)
            attrn = zeros(1,4*16);
            for j=1:16
                attrn(1,4*(j-1)+1:4*j) = getAttribute(V(end-windowSize+1:end,j), fs,b,a);
            end
            attrn
            yfit = knn.predictFcn(attrn)
            record = [record,yfit];
            plot(record)
            % write(tport,yfit)
        end
    end
    pause(1)
    % and display it
%     fprintf('%.2f\t',vec);
%     fprintf('\n');
%     pause(5);

end