
function [burst uniqueWord] = burstBuilderf(infoBits, nUniquewordBits, nGuardBits)

    uniqueWord = kron([ones(1,12)], [0 1 0 1 0 1 1 0]);%randi(0:1, 1, nUniquewordBits);
    guardBits = randi(0:1, nGuardBits);


    %Burst builder
    burst=[guardBits uniqueWord infoBits guardBits];
    %burst = uniqueWord;
end