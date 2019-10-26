clear all;
clc;
close all;

% inputs: 
% nInfoBits, nUniqueWordBits, nGaurdBits, upSampler, Lw, Ls
% 
% Parameters:
% nInfoBits = number of bits of information
% nUniqueWordBits = number of bits in unique word
% nGaurdBits = number of gaurd bits
% 
%Lw = Length of the window
%Ls = Length of the step
%
%
%
% burst = 
% burstSymbols
% QPSK modulation
% n=4
% Icomp, Qcomp
% modulatedSignal
% upSampler
% upSampledSignal
% dec


nInfoBits  = 1000;
nUniquewordBits = 96;
nGuardBits = 0;

infoBits = randi(0:1, 1, nInfoBits);
uniqueWord = kron([ones(1,12)], [0 0 0 1 1 1 1 0]);%randi(0:1, 1, nUniquewordBits);
guardBits = randi(0:1, nGuardBits);


%Burst Builder
%burst=[guardBits uniqueWord infoBits guardBits];
burst= uniqueWord;

% Modulation
n = 4;      % n-PSK modulation
% PSK symbols in binary sequence
IcompSymbol = zeros(1,n);
QcompSymbol = zeros(1,n);
for j=1:n
    IcompSymbol(j) = cos((j-1)*2*pi/n);
    QcompSymbol(j) = 1i*sin((j-1)*2*pi/n);
    PSKsymbolsBinary(j) = cos((j-1)*2*pi/n)+1i*sin((j-1)*2*pi/n);
end

% symbols arranging according to gray mapping
binarySequence = 0:n-1;
[graySequence, x] =  bin2gray(binarySequence','psk',n);
gray2bin = containers.Map(graySequence, binarySequence);
for j=1:n
    PSKsymbolsGray(j) = PSKsymbolsBinary(graySequence(j)+1);
end

% PSKsymbolsGray =  pskmod(0:n-1,n);
% IcompSymbol = real(PSKsymbolsGray);
% QcompSymbol = 1i*imag(PSKsymbolsGray);

% Convert Burst bits into symbols
bitsPerSymbol = log(n)/log(2);
for j=1:length(burst)/bitsPerSymbol
    dec = 0;
    for k=0:bitsPerSymbol-1          %binary to decimal conversion
        dec = dec*2^(k)+burst((j-1)*bitsPerSymbol+k+1);
    end
    burstSymbols(j) = dec;
end

% perform nPSK modulation
for j = 1:length(burstSymbols)
    modulatedSignal(j) = PSKsymbolsGray(burstSymbols(j)+1);
end


% up sampling
upSampler = 16;
upSamplingMatrix = [1 zeros(1,upSampler-1)];
upSampledSignal = kron(modulatedSignal, upSamplingMatrix);
%debug
% x=upSampledSignal;
% figure
% plot(1:length(x),real(x));
% hold on;
% plot(1:length(x),imag(x));
%

% raised cosine filter and interpolation
[NUM DEN] = rcosine(1, 16, 'normal', 0.35);
interpolatedSignal = conv(NUM, upSampledSignal);
% resizing the interpolatedSignal. remove extra bits 
interpolatedSignal = interpolatedSignal(.5*(length(NUM)-1)+1:length(interpolatedSignal)-.5*(length(NUM)-1));

s = interpolatedSignal;
%debug
% length(interpolatedSignal)
% x=interpolatedSignal;
% figure
% plot(1:length(x),real(x));
% hold on;
% plot(1:length(x),imag(x));
%
% figure;
% histogram(real(x));
% figure;
% histogram(imag(x));
% figure;
% histogram(abs(real(x)));
%


%channel g_t 
g_t=rician_channel();
%noise
noise = 0;%randn(1,length(interpolatedSignal));

receivedSignal = conv(g_t,interpolatedSignal);
% resizing the receivedSignal. remove extra bits and adding noise
receivedSignal = receivedSignal(.5*(length(g_t)-1)+1:length(receivedSignal)-.5*(length(g_t)-1));
receivedSignal = receivedSignal+noise;

y=receivedSignal;
% Down sampling by 16;
 y=decimate(y,16);
% s=decimate(s,16);


uw=modulatedSignal(1,1:48);
%uw=s;


% Demodulation consits of three parts
% Only for QPSK

% 1. Channel Estimation
Lw = 22;
Ls = 10;
k=0:7;
for j=1:1
    theta_uw=0;
    phs=0;
    yyy=0;
    for l=1:Lw
        phs = phs+phase(y(l)/uw(l));
        yyy = yyy+y(l)^4;
    end
    phs=phs/Lw;
    theta_k = 1/4*atan2(imag(yyy),real(yyy))+k*pi/4;
end

diff=2*pi;
for j=0:7
    if theta_k(j+1)>pi
        theta_k(j+1)=theta_k(j+1)-2*pi;
    elseif theta_k(j+1)<-pi
        theta_k(j+1)=theta_k(j+1)+2*pi;
    end
    abs(theta_k(j+1)-phs)
    if diff > abs(theta_k(j+1)-phs);
        diff=abs(theta_k(j+1)-phs);
        theta_hat = theta_k(j+1)
   end
end
theta_k*180/pi
theta_hat*180/pi
phs*180/pi

compensated = y(1:Lw+1)*(cos(theta_hat)-1i*sin(theta_hat));

% Hard Slicer for symbol detection
for j=1:Lw+1
    symbolPhase=phase(compensated(j));
    if symbolPhase <= pi/4 && symbolPhase >= -pi/4
        b = [0 0];
    elseif symbolPhase <= 3*pi/4 && symbolPhase >= pi/4
        b = [0 1];
    elseif symbolPhase <= -3*pi/4 || symbolPhase >= 3*pi/4
        b = [1 1];
    elseif symbolPhase <= -pi/4 && symbolPhase >= -3*pi/4
        b = [1 0];
    else
        display("Error in Hard Slicer. check if statements correctly for angles appropriately");
    end
    bits((2*(j-1)+1):2*(j-1)+2) = b;
end


corrects = bits(1:2*(Lw+1))==burst(1:2*(Lw+1));
c=sum(corrects)