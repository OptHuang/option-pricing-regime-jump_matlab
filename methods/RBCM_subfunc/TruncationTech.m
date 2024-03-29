function L = TruncationTech(K,class,sig1,sig2,r1,r2,d1,d2,lam1,lam2,A)
    % This function calculate the L by using truncation technique.
    
    switch class
        case 0  % Merton
            [mu,delt,kappaM,~,~,~,~,~,~,~,~] = Mertonpara(sig1,sig2,r1,r2,d1,d2,lam1,lam2,A);
            max_iter = 100;
            eps = 1e-6;
            % Find the root by Newton's method.
            beta1 = Newton_perMerton(max_iter,eps,sig1,r1,d1,lam1,kappaM,mu,delt);
            beta2 = Newton_perMerton(max_iter,eps,sig2,r2,d2,lam2,kappaM,mu,delt);
            % B_bar is the optimal exercise boundary for permanent American option.
            B_bar1 = K*beta1/(beta1-1);
            B_bar2 = K*beta2/(beta2-1);
            L_left = -log(min(B_bar1,B_bar2));
            L = max(L_left,log(3*K));
        case 1  % Kou
            [p,q,a1,a2,kappaK,~,~,~,~] = Koupara(sig1,sig2,r1,r2,d1,d2,lam1,lam2,A);
            % Find the root of the unary quartic characteristic function.
            omg1 = r1-d1-lam1*kappaK-0.5*sig1^2;
            para1 = [-0.5*sig1^2,(0.5*sig1^2*(a1-a2)-omg1),(0.5*sig1*a1*a2+omg1*(a1-a2)+(r1+lam1)),...
                (omg1*a1*a2-(r1+lam1)*(a1-a2)+lam1*(p*a1-q*a2)),-r1*a1*a2];
            omg2 = r2-d2-lam2*kappaK-0.5*sig2^2;
            para2 = [-0.5*sig2^2,(0.5*sig2^2*(a1-a2)-omg2),(0.5*sig2*a1*a2+omg2*(a1-a2)+(r2+lam2)),...
                (omg2*a1*a2-(r2+lam2)*(a1-a2)+lam2*(p*a1-q*a2)),-r2*a1*a2];
            x1 = roots(para1);
            x1 = sort(x1);
            beta41 = -x1(1);
            beta31 = -x1(2);
            x2 = roots(para2);
            x2 = sort(x2);
            beta42 = -x2(1);
            beta32 = -x2(2);
            B_bar1 = K*(a2+1)/a2*beta31/(1+beta31)*beta41/(1+beta41);
            B_bar2 = K*(a2+1)/a2*beta32/(1+beta32)*beta42/(1+beta42);
            L_left = -log(min(B_bar1,B_bar2));
            L = max(L_left,log(3*K));
    end

    

end