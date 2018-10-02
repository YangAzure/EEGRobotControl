%% Author: Yang Shi

function out = getAttribute(xin,Fs,b,a)
out = zeros(1,4);
x = filter(b,a,xin);
N = length(x);
xdft = fft(x);
xdft = xdft(1:floor(N/2+1));
psdx = (1/(Fs*N)) * abs(xdft).^2;
psdx = psdx/max(psdx);
thetaLow = floor(4.5*N/Fs)+1;
thetaHigh = floor(8*N/Fs)+1;
alphaLow = floor(8*N/Fs)+1;
alphaHigh = floor(12*N/Fs)+1;
betaLow = floor(12*N/Fs)+1;
betaHigh = floor(20*N/Fs)+1;
gammaLow = floor(20*N/Fs)+1;
gammaHigh = floor(30*N/Fs)+1;
out(1) = sum(psdx(thetaLow:thetaHigh))/(thetaHigh-thetaLow);
out(2) = sum(psdx(alphaLow:alphaHigh))/(alphaHigh-alphaLow);
out(3) = sum(psdx(betaLow:betaHigh))/(betaHigh-betaLow);
out(4) = sum(psdx(gammaLow:gammaHigh))/(gammaHigh-gammaLow);
end