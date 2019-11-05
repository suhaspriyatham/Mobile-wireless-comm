function BER = BERcalf(infoBits_hat,infoBits)


corrects = infoBits_hat==infoBits(1:length(infoBits_hat));
c = sum(corrects);
w = length(corrects)-c
BER = w/length(corrects);

end