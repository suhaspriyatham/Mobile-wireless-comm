function [infoBits_hat] = demodulatorf(downSampledSignal, uniqueWord)


    % Demodulation consits of three parts
    % Only for QPSK

    % 1. Channel Estimation
    Lw = 43;
    Ls = 11;
    y=downSampledSignal;
    receivedSymbols_hat=uniqueWord;

    for h=1:(length(y)-Lw)/Ls

        k=0:7;
        phs=0;  %theta_uw=0;
        y4sum=0;
        for l=1:Lw
            phs = phs+phase(y((h-1)*Ls+l)/receivedSymbols_hat((h-1)*Ls+l));
            y4sum = y4sum+y((h-1)*Ls+l)^4;
        end
        phs=phs/Lw;
        theta_k = 1/4*atan2(imag(y4sum),real(y4sum))+k*pi/4;

        % arg min of phase
        theta_hat(h) = arg_minf(phs,theta_k);


        % 2. Channel Compensation
        for j= ((Lw+1)/2+(h-1)*Ls-(Ls-1)/2):(Lw+h*Ls)
            %if j>length(uw)
                receivedSymbols_hat(((Lw+1)/2+(h-1)*Ls-(Ls-1)/2):(Lw+h*Ls)) = y(((Lw+1)/2+(h-1)*Ls-(Ls-1)/2):(Lw+h*Ls))*(cos(theta_hat(h))-1i*sin(theta_hat(h)));
            %end
        end
    end
    %receivedSymbols_hat((h*Ls+Lw)+1:length(y)) = y((h*Ls+Lw)+1:length(y))*(cos(theta_hat(h))-1i*sin(theta_hat(h)));
    
    
    %3. Hard Slicer for symbol detection
    for j=1:length(receivedSymbols_hat)         %length(y)
        symbolPhase=phase(receivedSymbols_hat(j));
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
        infoBits_hat((2*(j-1)+1):2*(j-1)+2) = b;
    end
    len=length(infoBits_hat)
    
end


