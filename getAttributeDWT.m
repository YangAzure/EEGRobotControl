%% Author: Yang Shi

function out = getAttributeDWT(xin,Fs,lv,b,a)
% xin = xin/max(xin);
xin = filter(b,a,xin);
wpt = wpdec(xin,lv,'sym8');
[Spec,Time,Freq] = wpspectrum(wpt,Fs);
Spec = downsample(Spec',2^lv)';
out = Spec';
for i = 1:size(out,2)
    out(:,i) = out(:,i)./max(out(:,i));
end
end