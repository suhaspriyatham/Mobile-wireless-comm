clear all;
clc;
close all;


nInfoBits  = 1000;
nUniquewordBits = 96;
nGuardBits = 0;

n = 4;      % n-PSK modulation
nSampleBy = 16;    % up sampling
pathfParm=0.35;
%Global uniqueWord;
infoBits = randi(0:1, 1, nInfoBits);

[burst, uniqueWord] = burstBuilderf(infoBits, nUniquewordBits, nGuardBits);

modulatedSignal = modulatedSignalf(n, burst);

%upSampledSignal= upSamplerf(nSampleBy, modulatedSignal);
upSampledSignal = interpn(modulatedSignal,4);
txSignal = pathshapingf(nSampleBy, pathfParm, upSampledSignal);

g_t=1;%ricianChannelf(length(txSignal));
%g_t=test2(length(txSignal));
noise = 0; %noisef(Eb/);

rxSignal = txSignal.*g_t + noise;

matchedFilterOutput = pathshapingf(nSampleBy, pathfParm, rxSignal);

downSampledSignal = downSamplerf(nSampleBy, matchedFilterOutput);
%downSampledSignal = downSamplerf(nSampleBy, rxSignal); %to remove matchedfilter

bits_hat = demodulatorf(downSampledSignal, uniqueWord);

[infoBits_hat] = burstExtractorf(bits_hat, nUniquewordBits, nGuardBits);

BER = BERcalf(infoBits_hat,infoBits);


close all;


