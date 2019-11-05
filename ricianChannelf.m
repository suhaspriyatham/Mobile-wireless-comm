% Parameters
% fd = 
% K = 



%channelLength=8753
function g_t = ricianChannelf(channelLength) 

    N=70;
    M=1/2*(N/2-1);
    l=channelLength  %number of symbols

    n = 1:M;
    Ts = (0.5*10^-3)/l;
    t0 = rand;
    l=1:l;
    t=(t0+l(1)*Ts):Ts:(t0+l(length(l))*Ts);


    fd=200;      %doppler frequency
    omega_d = 2*pi*fd;
    omega_n = omega_d*cos(2*pi*n/N);
    alpha = 0;
    beta_n = n*pi/M;

    %Jakes's Model
    for i=1:length(t)
        gI_t(i) = sum(2*cos(beta_n).*cos((omega_n)*t(i))) + sqrt(2)*cos(omega_d*t(i))*cos(alpha);
        gQ_t(i) = sum(2*sin(beta_n).*cos((omega_n)*t(i))) + sqrt(2)*cos(omega_d*t(i))*sin(alpha);
    end
Pi=sum(abs(gI_t).^2)/length(l)
Pq=sum(abs(gQ_t).^2)/length(l)

%Jakes' Model from other source
    for i=1:length(t)
        gI_t2(i) = sqrt(2)*cos(2*pi*fd*t(i))*2*sum(cos(2*pi*n/M).*cos(omega_d*cos(2*pi*n/(4*M+2))*t(i)));
        gQ_t2(i) = 2*sum(sin(2*pi*n/M).*cos(2*pi*fd*cos(2*pi*n/(4*M+2))*t(i)));
    end   
    
Pi2=sum(abs(gI_t2).^2)/length(l)
Pq2=sum(abs(gQ_t2).^2)/length(l)
    %Rayleigh distribution
     gI_t = gI_t/sqrt(2*(M+1));
     gQ_t = gQ_t/sqrt(2*(M));
%     gI_t = gI_t/sqrt(2*sum(gI_t.^2));
%     gQ_t = gQ_t/sqrt(2*sum(gQ_t.^2));
    figure;
    histogram(gI_t);
    figure;
    histogram(gQ_t);
    
    g_t_Rayleigh = (gI_t+1i*gQ_t)*sqrt(length(l)); %%sqrt?

    

    % Rician fading
    K = 200;        %fading factor in dB
    A = 10^(-K/20);
    gain = 1/(sqrt(1+10^(-K/10)));

    g_t_Rician = (1+g_t_Rayleigh*A)*gain;

    g_t = g_t_Rician/sqrt(sum(abs(g_t_Rician).^2))*sqrt(length(l)); %%% trash
    
    figure;
    plot(l,abs(g_t));
    title("amplitude");
    figure;
    plot(l,phase(g_t));
    title("phase");

end






