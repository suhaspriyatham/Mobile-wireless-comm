

N=70;
M=1/2*(N/2-1);
l=544;  %number of symbols

n = 1:M;
Ts = (0.5*10^-3)/l;
t0 = 0;
t=(t0+n(1)*Ts):Ts:(t0+n(length(n))*Ts);


fd=20;
omega_d = 2*pi*fd;
omega_n = omega_d*cos(2*pi*n/N);
alpha = 0;
beta_n = n*pi/M;

%Jakes's Model
for i=1:length(t)
    gI_t(i) = sum(2*cos(beta_n).*cos(omega_n)*t(i))+sqrt(2)*cos(omega_d*t(i))*cos(alpha);
    gQ_t(i) = sum(2*sin(beta_n).*cos(omega_n)*t(i))+sqrt(2)*cos(omega_d*t(i))*sin(alpha);
end


%Rayleigh distribution
gI_t = gI_t/sqrt(2*(M+1));
gQ_t = gQ_t/sqrt(2*(M));

g_t_Rayleigh = gI_t+1i*gQ_t;



% Rician fading
K = 200;        %fading factor in dB
A = 10^(-K/20);
gain = 1/(sqrt(1+10^(K/10)));

g_t_Rician = (1+g_t_Rayleigh*10^(-K/20))/sqrt(1+10^(-K/10));






