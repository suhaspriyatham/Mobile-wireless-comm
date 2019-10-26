clear all;
clc;
close all;

% inputs: 
% nInfoBits, nUniqueWordBits, nGaurdBits, upSampler 
% 
% Variables:
% nInfoBits = number of bits of information
% nUniqueWordBits = number of bits in unique word
% nGaurdBits = number of gaurd bits
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
uniqueWord = randi(0:1, 1, nUniquewordBits);
guardBits = randi(0:1, nGuardBits);


%Burst Builder
burst=[guardBits uniqueWord infoBits guardBits];


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
x=upSampledSignal;
figure
plot(1:length(x),real(x));
hold on;
plot(1:length(x),imag(x));
%

% raised cosine filter and interpolation
[NUM DEN] = rcosine(1, 16, 'normal', 0.35);
interpolatedSignal = conv(NUM, upSampledSignal);
% resizing the interpolatedSignal. remove extra bits 
interpolatedSignal = interpolatedSignal(.5*(length(NUM)-1)+1:length(interpolatedSignal)-.5*(length(NUM)-1));

%debug
length(interpolatedSignal)
x=interpolatedSignal;
figure
plot(1:length(x),real(x));
hold on;
plot(1:length(x),imag(x));
%
figure;
histogram(real(x));
figure;
histogram(imag(x));
figure;
histogram(abs(real(x)));
%


%Channel Design



%channel g_t


