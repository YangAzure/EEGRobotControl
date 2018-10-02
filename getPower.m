%% Author: Yang Shi

function MLTable = getPower(K, fs, windowSize, iter, lable)
% attr = zeros((length(K)- windowSize - 10*250),4*16+16*128);
attr = zeros((length(K)- windowSize - 10*250),4*16);
trainLab = zeros(length(K)- windowSize - 10*250,1);
[b,a] = butter(4, [3,40]/(fs/2), 'bandpass');

for i=1+windowSize/2:length(K)- windowSize/2-10*250
    for j=1:16
        lowbit = i-windowSize/2+10*250;
        highbit = i+windowSize/2+10*250;
        attr(i-windowSize/2,4*(j-1)+1:4*j) = getAttribute(K(lowbit:highbit,j),fs,b,a);
    end
%     attr(i,4*16+1:end) = getTimeSeq(K(i+10*250:i+10*250+windowSize-1,:),b,a,windowSize);
end

for i=1:length(K)- windowSize-10*250
    for j=1:iter
        if i >= 250*((j-1)*10+7) + 10*250 && i <= 250*(j*10+1) + 10*250
            trainLab(i-10*250) = lable(j);
        end
    end
end

MLTable = [attr trainLab];

% figure
% plot(MLTable(:,1))
for i=1:4
    figure
    plot(MLTable(:,i));
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])
end


for i=1:iter
    for j = length(MLTable):-1:1
        if j > 250*((i-1)*10+1) && j < 250*((i-1)*10+2)
            MLTable(j,:) = [];
        end
        if j > 250*((i-1)*10+7) && j < 250*((i-1)*10+8)
            MLTable(j,:) = [];
        end
    end
end
end