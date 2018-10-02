fs = 250;
windowSize = 128;
iter = 15;

V = precondition('/home/sensorweb/EEg/Data/1102ser2.txt',fs);
lableload = load('label1102_ser2.mat', 'lable');
lable = lableload.lable;


%PSD method%
MLTable = getPower(V, fs, windowSize, iter, lable);

[coeff,score,latent]=pca(MLTable(:,1:end-1));
scorepsd = score(:,1:15);
scorepsd = scorepsd/(max(max(score)));
te0 = [scorepsd,MLTable(:,end)];
confu = zeros(3,3);
for t=1:10
indices = crossvalind('Kfold',te0(:,end),5);
for i = 1:5
    test = (indices == i); train = ~test;
    [class,err] = classify(te0(test,1:end-1),te0(train,1:end-1),te0(train,end),'quadratic');
    confu = confu + confusionmat(te0(test,end),class);
end
end
sum(diag(confu/10))/sum(sum(confu/10))
confu./sum(confu,2)

%WPD method%
[DWTTable,trainlab] = getPowerDWT(V, 30, 80, iter, lable, 2);

te = zeros(length(DWTTable),80*16);
for i = 1:length(DWTTable)
    te(i,:) = reshape(DWTTable(:,:,i),1,80*16);
end
te = [te,trainlab];

[coeff,score,latent]=pca(te(:,1:end-1));
scorewpd = score(:,1:171);
scorewpd = scorewpd/(max(max(score)));
te1 = [scorewpd,trainlab];
confu = zeros(3,3);
for t=1:10
indices = crossvalind('Kfold',te1(:,end),5);
for i = 1:5
    test = (indices == i); train = ~test;
    [class,err] = classify(te1(test,1:end-1),te1(train,1:end-1),te1(train,end),'quadratic');
    confu = confu + confusionmat(te1(test,end),class);
end
end
sum(diag(confu/10))/sum(sum(confu/10))
confu./sum(confu,2)

%Adding dtw to original qda%
meandwt = mean(te(:,1:end-1),1);
N = size(te,1);
dtwF = zeros(N,16*4);

for i=1:N
    for j=1:4
        for c=1:16
            dtwF(i,(c-1)*4+j)=dtw(te(i,(c-1)*80+(j-1)*20+1:(c-1)*80+j*20),meandwt((c-1)*80+(j-1)*20+1:(c-1)*80+j*20));
        end
    end
    fprintf("finished %d\n",i);
end

dtwF = [dtwF,trainlab];

dtwF(:,57:60)=[]

[coeff,score,latent]=pca(te(:,1:end-1));

score1 = score(:,1:268);
score1 = score1/(max(max(score)));
dtwF(:,1:end-1) = dtwF(:,1:end-1)/(max(max(dtwF(:,1:end-1))));

[n,m] = size(dtwF(:,1:end-1));
te2=score1;
for i=1:1
raodong = 0.001*mean(mean(dtwF(:,1:end-1)))*rand(n,m);
te2 = [te2 dtwF(:,1:end-1)+raodong];
end
te2 = [te2 dtwF];

confu = zeros(3,3);
for t=1:10
indices = crossvalind('Kfold',te2(:,end),5);
for i = 1:5
test = (indices == i); train = ~test;
[class,err] = classify(te2(test,1:end-1),te2(train,1:end-1),te2(train,end),'quadratic');
confu = confu + confusionmat(te2(test,end),class);
end
end
sum(diag(confu/10))/sum(sum(confu/10))
confu./sum(confu,2)
