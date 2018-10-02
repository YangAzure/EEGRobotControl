%% Author: Yang Shi

function [MLTable,trainLab] = getPowerDWT(K, fs, windowSize, iter, lable, lv)
attr = zeros(windowSize,16,length(K)- windowSize - 10*250);
trainLab = zeros(length(K)- windowSize - 10*250,1);
[b,a] = butter(4, [3,fs]/(250/2), 'bandpass');

for i=1+windowSize/2:length(K)- windowSize/2-10*250
    lowbit = i-windowSize/2+10*250;
    highbit = i+windowSize/2-1+10*250;
    for j=1:16
        attr(:,j,i-windowSize/2) = reshape(getAttributeDWT(K(lowbit:highbit,j),fs,lv,b,a),windowSize,1);
    end
    fprintf('finished : %d rounds.\n',i-windowSize/2);
end

for i=1:length(K)- windowSize-10*250
    for j=1:iter
        if i >= 250*((j-1)*10+7)+ 10*250 && i <= 250*(j*10+1)+ 10*250
            trainLab(i-10*250) = lable(j);
        end
    end
end

MLTable = attr;

fprintf('finished :ML calc \n');
% figure
% plot(MLTable(:,1))
% for i=1:4
%     figure
%     plot(MLTable(:,i));
%     set(gca,'xtick',[])
%     set(gca,'xticklabel',[])
%     set(gca,'ytick',[])
%     set(gca,'yticklabel',[])
% end

for i=1:iter
    for j = length(MLTable):-1:1
        if j > 250*((i-1)*10+1) && j < 250*((i-1)*10+2)
            MLTable(:,:,j) = [];
        end
        if j > 250*((i-1)*10+7) && j < 250*((i-1)*10+8)
            MLTable(:,:,j) = [];
        end
    end
end

for i=1:iter
    for j = length(trainLab):-1:1
        if j > 250*((i-1)*10+1) && j < 250*((i-1)*10+2)
            trainLab(j,:) = [];
        end
        if j > 250*((i-1)*10+7) && j < 250*((i-1)*10+8)
            trainLab(j,:) = [];
        end
    end
end

end