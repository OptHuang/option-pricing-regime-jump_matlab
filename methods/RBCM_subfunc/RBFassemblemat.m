function [Coefmatrix,A1] = RBFassemblemat(type,class,dt,Nx,A,sig1,sig2,r1,r2,d1,d2,lam1,lam2,...
    kappaM,kappaK,mu,delt,p,q,a1,a2,L,epsilon)
    % This function is used to generate the linear equation coefficient matrix (stiffness matrix) that needs to be solved in the RBF method
    % type refers to the rbf type (0 linear, 1 cubic), class refers to the jump diffusion category (0 Merton, 1 Kou)
    
    x = linspace(-L,L,Nx+1);
    A1 = zeros(Nx+1,Nx+1);
    B1 = zeros(Nx+1,Nx+1);
    B2 = zeros(Nx+1,Nx+1);
    
    switch type
        case 0  % linear rbf
            % Assign values to the A1 matrix
            for i = 2:Nx+1
                for j = 1:i-1
                    A1(i,j) = abs(x(i)-x(j));
                    A1(j,i) = abs(x(i)-x(j));
                end
            end
            % Assign values to the B1, B2 matrix
            switch class
                case 0  % Merton
                    for i = 1:Nx+1
                        fii = @(z) 1/(sqrt(2*pi)*delt)*abs(z).*exp(-(z-mu).^2/2/(delt^2));  % Define the anonymous function inside the integral
                        zmax = sqrt(-2*(delt)^2*log(epsilon*delt*(sqrt(2*pi))/2))+mu;  % Define the upper bound of the numerical integration
                        B1(i,i) = (r1+lam1)*abs(x(i)-x(i))-(r1-d1-0.5*sig1^2-lam1*kappaM)*(0)...
                            -lam1*quadgk(fii,-zmax,zmax);
                        Integral = quadgk(fii,-zmax,zmax);
                        B2(i,i) = (r2+lam2)*abs(x(i)-x(i))-(r2-d2-0.5*sig2^2-lam2*kappaM)*(0)...
                            -lam2*quadgk(fii,-zmax,zmax);
                    end
                    for i = 2:Nx+1
                        for j = 1:i-1
                            fij = @(z) 1/(sqrt(2*pi)*delt)*abs(z+x(i)-x(j)).*exp(-(z-mu).^2/2/(delt^2));
                            Integral = quadgk(fij,-zmax,zmax);
                            B1(i,j) = (r1+lam1)*abs(x(i)-x(j))-(r1-d1-0.5*sig1^2-lam1*kappaM)*(1)...
                                -lam1*quadgk(fij,-zmax,zmax);
                            B2(i,j) = (r2+lam2)*abs(x(i)-x(j))-(r2-d2-0.5*sig2^2-lam2*kappaM)*(1)...
                                -lam2*quadgk(fij,-zmax,zmax);
                        end
                    end
                    for i = 1:Nx
                        for j = i+1:Nx+1
                            fji = @(z) 1/(sqrt(2*pi)*delt)*abs(z+x(i)-x(j)).*exp(-(z-mu).^2/2/(delt^2));
                            B1(i,j) = (r1+lam1)*abs(x(i)-x(j))-(r1-d1-0.5*sig1^2-lam1*kappaM)*(-1)...
                                -lam1*quadgk(fji,-zmax,zmax);
                            B2(i,j) = (r2+lam2)*abs(x(i)-x(j))-(r2-d2-0.5*sig2^2-lam2*kappaM)*(-1)...
                                -lam2*quadgk(fji,-zmax,zmax);
                        end
                    end
                case 1  % Kou
                    for i = 1:Nx+1
                        fii = @(z) abs(z).*(q*a2*exp(a2*z).*(z<0)+p*a1*exp(-a1*z).*(z>=0));  % Define the anonymous function inside the integral
                        zmax = log(epsilon/p)/(1-a1);  % Define the upper bound of the numerical integration
                        zmin = -log(epsilon/q)/(1-a2);  % Define the lower bound of the numerical integration
                        B1(i,i) = (r1+lam1)*abs(x(i)-x(i))-(r1-d1-0.5*sig1^2-lam1*kappaK)*(0)...
                            -lam1*quadgk(fii,-zmin,zmax);
                        B2(i,i) = (r2+lam2)*abs(x(i)-x(i))-(r2-d2-0.5*sig2^2-lam2*kappaK)*(0)...
                            -lam2*quadgk(fii,-zmin,zmax);
                    end
                    for i = 2:Nx+1
                        for j = 1:i-1
                            fij = @(z) abs(z+x(i)-x(j)).*(q*a2*exp(a2*z).*(z<0)+p*a1*exp(-a1*z).*(z>=0));
                            B1(i,j) = (r1+lam1)*abs(x(i)-x(j))-(r1-d1-0.5*sig1^2-lam1*kappaK)*(1)...
                                -lam1*quadgk(fij,-zmin,zmax);
                            B2(i,j) = (r2+lam2)*abs(x(i)-x(j))-(r2-d2-0.5*sig2^2-lam2*kappaK)*(1)...
                                -lam2*quadgk(fij,-zmin,zmax);
                        end
                    end
                    for i = 1:Nx
                        for j = i+1:Nx+1
                            fji = @(z) abs(z+x(i)-x(j)).*(q*a2*exp(a2*z).*(z<0)+p*a1*exp(-a1*z).*(z>=0));
                            B1(i,j) = (r1+lam1)*abs(x(i)-x(j))-(r1-d1-0.5*sig1^2-lam1*kappaK)*(-1)...
                                -lam1*quadgk(fji,-zmin,zmax);
                            B2(i,j) = (r2+lam2)*abs(x(i)-x(j))-(r2-d2-0.5*sig2^2-lam2*kappaK)*(-1)...
                                -lam2*quadgk(fji,-zmin,zmax);
                        end
                    end
            end
            
        case 1  % cubic rbf
            % Assign values to the A1 matrix
            for i = 2:Nx+1
                for j = 1:i-1
                    A1(i,j) = (abs(x(i)-x(j)))^3;
                    A1(j,i) = (abs(x(i)-x(j)))^3;
                end
            end
            % Assign values to the B1, B2 matrix
            switch class
                case 0  % Merton
                    for i = 1:Nx+1
                        fii = @(z) 1/(sqrt(2*pi)*delt)*abs(z).^3.*exp(-(z-mu).^2/2/(delt^2));  % Define the anonymous function inside the integral
                        zmax = sqrt(-2*(delt)^2*log(epsilon*delt*(sqrt(2*pi))/2))+mu;  % Define the upper bound of the numerical integration
                        B1(i,i) = (r1+lam1)*abs(x(i)-x(i)).^3-(r1-d1-0.5*sig1^2-lam1*kappaM)*0-0.5*sig1^2*(6*0)...
                            -lam1*quadgk(fii,-zmax,zmax);
                        B2(i,i) = (r2+lam2)*abs(x(i)-x(i)).^3-(r2-d2-0.5*sig2^2-lam2*kappaM)*0-0.5*sig2^2*(6*0)...
                            -lam2*quadgk(fii,-zmax,zmax);
                    end
                    for i = 2:Nx+1
                        for j = 1:i-1
                            fij = @(z) 1/(sqrt(2*pi)*delt)*abs(z+x(i)-x(j)).^3.*exp(-(z-mu).^2/2/(delt^2));
                            B1(i,j) = (r1+lam1)*abs(x(i)-x(j)).^3-(r1-d1-0.5*sig1^2-lam1*kappaM)*3*(x(i)-x(j)).^2 ...
                            -0.5*sig1^2*(6*abs(x(i)-x(j)))-lam1*quadgk(fij,-zmax,zmax);
                            B2(i,j) = (r2+lam2)*abs(x(i)-x(j)).^3-(r2-d2-0.5*sig2^2-lam2*kappaM)*3*(x(i)-x(j)).^2 ...
                                -0.5*sig2^2*(6*abs(x(i)-x(j)))-lam2*quadgk(fij,-zmax,zmax);
                        end
                    end
                    for i = 1:Nx
                        for j = i+1:Nx+1
                            fji = @(z) 1/(sqrt(2*pi)*delt)*abs(z+x(i)-x(j)).^3.*exp(-(z-mu).^2/2/(delt^2));
                            B1(i,j) = (r1+lam1)*abs(x(i)-x(j)).^3-(r1-d1-0.5*sig1^2-lam1*kappaM)*(-1)*3*(x(i)-x(j)).^2 ...
                                -0.5*sig1^2*(6*abs(x(i)-x(j)))-lam1*quadgk(fji,-zmax,zmax);
                            B2(i,j) = (r2+lam2)*abs(x(i)-x(j)).^3-(r2-d2-0.5*sig2^2-lam2*kappaM)*(-1)*3*(x(i)-x(j)).^2 ...
                                -0.5*sig2^2*(6*abs(x(i)-x(j)))-lam2*quadgk(fji,-zmax,zmax);
                        end
                    end
                case 1  % Kou
                    for i = 1:Nx+1
                        fii = @(z) abs(z).^3.*(q*a2*exp(a2*z).*(z<0)+p*a1*exp(-a1*z).*(z>=0));  % Define the anonymous function inside the integral
                        zmax = log(epsilon/p)/(1-a1);  % Define the upper bound of the numerical integration
                        zmin = -log(epsilon/q)/(1-a2);  % Define the lower bound of the numerical integration
                        B1(i,i) = (r1+lam1)*abs(x(i)-x(i)).^3-(r1-d1-0.5*sig1^2-lam1*kappaK)*0-0.5*sig1^2*(6*0)...
                            -lam1*quadgk(fii,-zmin,zmax);
                        B2(i,i) = (r2+lam2)*abs(x(i)-x(i)).^3-(r2-d2-0.5*sig2^2-lam2*kappaK)*0-0.5*sig2^2*(6*0)...
                            -lam2*quadgk(fii,-zmin,zmax);
                    end
                    for i = 2:Nx+1
                        for j = 1:i-1
                            fij = @(z) abs(z+x(i)-x(j)).^3.*(q*a2*exp(a2*z).*(z<0)+p*a1*exp(-a1*z).*(z>=0));
                            B1(i,j) = (r1+lam1)*abs(x(i)-x(j)).^3-(r1-d1-0.5*sig1^2-lam1*kappaK)*3*(x(i)-x(j)).^2 ...
                            -0.5*sig1^2*(6*abs(x(i)-x(j)))-lam1*quadgk(fij,-zmax,zmax);
                            B2(i,j) = (r2+lam2)*abs(x(i)-x(j)).^3-(r2-d2-0.5*sig2^2-lam2*kappaK)*3*(x(i)-x(j)).^2 ...
                            -0.5*sig2^2*(6*abs(x(i)-x(j)))-lam2*quadgk(fij,-zmax,zmax);
                        end
                    end
                    for i = 1:Nx
                        for j = i+1:Nx+1
                            fji = @(z) abs(z+x(i)-x(j)).^3.*(q*a2*exp(a2*z).*(z<0)+p*a1*exp(-a1*z).*(z>=0));
                            B1(i,j) = (r1+lam1)*abs(x(i)-x(j)).^3-(r1-d1-0.5*sig1^2-lam1*kappaK)*(-1)*3*(x(i)-x(j)).^2 ...
                            -0.5*sig1^2*(6*abs(x(i)-x(j)))-lam1*quadgk(fji,-zmax,zmax);
                            B2(i,j) = (r2+lam2)*abs(x(i)-x(j)).^3-(r2-d2-0.5*sig2^2-lam2*kappaK)*(-1)*3*(x(i)-x(j)).^2 ...
                            -0.5*sig2^2*(6*abs(x(i)-x(j)))-lam2*quadgk(fji,-zmax,zmax);
                        end
                    end
            end
    end
    
    % Assembly Matrix Coefmatrix
    Coefmatrix = [A1+dt*(B1-A(1,1)*A1) -dt*A(1,2)*A1;-dt*A(2,1)*A1 A1+dt*(B2-A(2,2)*A1)];



end