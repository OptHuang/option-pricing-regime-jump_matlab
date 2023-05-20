function ComputeVtrue

    format long
    
    %% Merton
    class = 0;
    [T,K,sigma1,sigma2,~,~,d1,~,lam1,lam2,gamma,mun,rho0,eps,L,A,x0,t0,~,~,~,~,...
    mu,delt,nM1,nM2,mM1,mM2,mu_star1,mu_star2,C1,C2,~,~,~,~,~,~,~,~,~] = ParaImput(class);
    Nt0 = 200;
    Nx0 = 256;
    dt0 = T/Nt0;
    dx0 = 2*L/Nx0;
    [Vmertrue1,Vmertrue2] = DataMatrixMerton(K,sigma1,sigma2,lam1,lam2,gamma,mun,rho0,eps,L,A,x0,t0,Nx0,Nt0,dx0,dt0,...
    mu,delt,nM1,nM2,mM1,mM2,mu_star1,mu_star2,C1,C2);
    
    % Get the current working directory
    current_folder = cd;
    
    % Construct the desired destination folder path
    destination_folder = fullfile(current_folder, '..', 'data_truevalue');
    filename = sprintf('class=%d_d=%.4f_lam=%.2f_Nx=%d_Nt=%d.mat', class, d1, lam1, Nx0, Nt0);
    full_path = fullfile(destination_folder, filename);
    save(full_path,'Vmertrue1','Vmertrue2')
    
    %% Kou
    class = 1;
    [T,K,sigma1,sigma2,~,~,d1,~,lam1,lam2,gamma,mun,rho0,eps,L,A,x0,t0,~,~,~,~,...
    ~,~,~,~,~,~,~,~,~,~,p,q,a1,a2,~,nK1,nK2,mK1,mK2] = ParaImput(class);
    Nt0 = 200;
    Nx0 = 128;
    dt0 = T/Nt0;
    dx0 = 2*L/Nx0;
    [Vkoutrue1,Vkoutrue2] = DataMatrixKou(K,sigma1,sigma2,lam1,lam2,gamma,mun,rho0,eps,L,A,x0,t0,Nx0,Nt0,dx0,dt0,...
    p,q,a1,a2,nK1,nK2,mK1,mK2);
    
    % Get the current working directory
    current_folder = cd;
    
    % Construct the desired destination folder path
    destination_folder = fullfile(current_folder, '..', 'data_truevalue');
    filename = sprintf('class=%d_d=%.4f_lam=%.2f_Nx=%d_Nt=%d.mat', class, d1, lam1, Nx0, Nt0);
    full_path = fullfile(destination_folder, filename);
    save(full_path,'Vkoutrue1','Vkoutrue2')
    
end