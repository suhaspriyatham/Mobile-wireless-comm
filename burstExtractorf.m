function infoBits_hat = burstExtractorf(bits_hat, nUniquewordBits, nGuardBits)


    infoBits_hat = [bits_hat((nGuardBits+nUniquewordBits+1):(length(bits_hat)-nGuardBits))];

end


