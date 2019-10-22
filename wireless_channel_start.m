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
% Burst = 
% QPSK modulation
% n=4
% Icomp, Qcomp
% modulatedSignal
% upSampler
% upSampledSignal
% 


nInfoBits  = 1000;
nUniquewordBits = 96;
nGuardBits = 0;

infoBits = randi(0:1, 1, nInfoBits);
uniqueWord = randi(0:1, 1, nUniquewordBits);
guardBits = randi(0:1, nGuardBits);


%Burst Builder
Burst=[guardBits uniqueWord infoBits guardBits];


%Modulation
n = 4;      % QPSK modulation
Icomp = zeros(1,n);
Qcomp = zeros(1,n);
for j=1:n
    Icomp(j) = cos((j-1)*2*pi/n);
    Qcomp(j) = 1i*sin((j-1)*2*pi/n);
end

% arrange according to gray mapping




% perform QPSK modulation





% modulatedSignal = Icomp + Qcomp;  need to be modified



% up sampling
upSampler = 16;
upSamplingMatrix = [1 zeros(1,upSampler-1)];

upSampledSignal = kron(modulatedSignal, upSamplingMatrix)




