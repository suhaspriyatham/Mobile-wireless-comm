function theta_hat = arg_min(phs, theta_k)

    diff=2*pi;
    for j=0:7
        if theta_k(j+1)>pi
            theta_k(j+1)=theta_k(j+1)-2*pi;
        elseif theta_k(j+1)<-pi
            theta_k(j+1)=theta_k(j+1)+2*pi;
        end
        if diff > abs(theta_k(j+1)-phs);
            diff=abs(theta_k(j+1)-phs);
            theta_hat = theta_k(j+1);
       end
    end
    
    
end