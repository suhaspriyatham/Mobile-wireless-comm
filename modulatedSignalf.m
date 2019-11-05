% Modulation
function modulatedSignal = modulatedSignalf(n, burst)

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

end
