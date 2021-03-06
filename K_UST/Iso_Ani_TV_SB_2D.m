
function [u,errAll] = Iso_Ani_TV_SB_2D(modeTV,J,f, N,mu, lambda, gamma, alpha, nBreg,varargin)
% [u,errAll] = Iso_Ani_TV_SB_2D(modeTV,J,f, N,mu, lambda, gamma, alpha, nBreg)
% 
% [u,errAll] = Iso_Ani_TV_SB_2D(modeTV,J,f, N,mu, lambda, gamma, alpha, nBreg,target)
%
% Iso_Ani_TV_SB_2D solves the 2D constrained isotropic or anisotropic total
% variation image reconstruction problem using the Split Bregman formulation.
%
% Inputs:
%
% modeTV    = 'iso': Isotropic TV, 'ani': Anisotropic TV, ixy': isotropic
% TV on xy and anisotropic in z.
% J         = Linear operator or Jacobian that maps image pixels into
% measurements, matrix of size mxn, where m and n are the number of
% measurements and voxels, respectively
% f         = data, a column vector mx1
% N         = image size vector [size_x size_y size_z]
% mu        = 1 (decrease if data is noisy and increase for faste
% convergence)
% lambda    = 1, regularization parameter
% gamma     = 1, regularization parameter
% alpha     = sparsity weighting parameter. 1 for 'iso', [1 1] for
% 'ani'.
% nInner    = 1
% nBreg     = the number of Bregman iterations. Choose a number of
% iterations such that the method converges (for that see the solution
% error norm errAll)
% uTarget   = target image solution of size N used to compute the error
%
% Outputs:
% u         = image of size N
% errAll    = solution error
%
% It solves the constrained total variation problem
%
% 'ani': min_u alpha(1)||grad_x u||_1 + alpha(2)||grad_y u||_1 st. ||Au-f||^2 < delta,
%
% 'iso': min_u alpha(1)||(grad_x u,grad_y u)||_1 st. ||Au-f||^2 < delta,
%
% where A is a linear operator (a matrix) the projects the image u to the
% data f. The code works for general linear inverse problems. It currently
% expects A to be a matrix; it can be easily modified to use A as a MATLAB
% function by changing A and A' for functions that compute forward and adjoint
% operators (eg. projection and retroprojection operations).
%
% If you use this code, please, cite the following paper:
% Abascal JF, Chamorro-Servent J, Aguirre J, Arridge S, Correia T, Ripoll
% J, Vaquero JJ, Desco M. Fluorescence diffuse optical tomography using the
% split Bregman method. Med Phys. 38(11):6275-84, 2011.
% DOI: http://dx.doi.org/10.1118/1.3656063
%
% Code downloaded from repository:
%
% Juan FPJ Abascal
% CREATIS (CNRS)

% Normalize data
normFactor  = getNormalizationFactor(f,f);
f           = normFactor*f;

switch nargin
    case 10
        uTarget     = varargin{1};
end % nargin

errAll      = zeros(nBreg,1);

% Normalize Jacobian such that its Hessian diagonal is equal to 1
normFactorJ = 1/sqrt(max(diag(J'*J)));
J           = J*normFactorJ;

% Scale the forward and adjoint operations so it doesnt depend on the size
scale       = 1/max(abs(J'*f));

% Define forward and adjoint operators
A           = @(x)(((J*x(:)))/scale);
AT          = @(x)(reshape((J'*x)*scale,N));

% Krylov convergence criterion: decrease to improve precision for solving
% the linear system, increase to go faster
tolKrylov   = 1e-1; % 1e-4

% Reserve memory for the auxillary variables
rows        = N(1);
cols        = N(2);
f0          = f;
u           = zeros(N);
x           = zeros(N);
y           = zeros(N);
bx          = zeros(N);
by          = zeros(N);

murf        = mu*AT(f);

%  Do the reconstruction
for outer = 1:nBreg;
    % update u
    rhs     = murf+lambda*Dxt(x-bx)+lambda*Dyt(y-by)+gamma*u;
    
    u       = reshape(krylov(rhs(:)),N);
    
    dx      = Dx(u);
    dy      = Dy(u);
    
    % update x and y and z
    switch modeTV
        case 'iso'
            [x,y]     = shrink2(dx+bx,dy+by,alpha(1)/lambda);
        case 'ani'
            x           = shrink1(dx+bx,alpha(1)/lambda);
            y           = shrink1(dy+by,alpha(2)/lambda);
    end
    
    % update bregman parameters
    bx          = bx+dx-x;
    by          = by+dy-y;
    
    fForw           = A(u);
    f               = f + f0-fForw;
    murf            = mu*AT(f);
    
    if nargin >= 10
        % Solution error norm
        errAll(outer)       = norm(uTarget(:)-abs(u(:)*normFactorJ/(normFactor*scale)))/norm(uTarget(:));
        
%         if any([outer ==1, outer == 10, rem(outer, 50) == 0])
%             close;
%             h=figure;
%             subplot(32,2,1);
%             imagesc(abs(u*normFactorJ/(normFactor*scale))); title(['u, iter. ' num2str(outer)]); colorbar;
%             subplot(2,2,2);
%             imagesc(abs(x)); title(['x']); colorbar;
%             subplot(2,2,3);
%             imagesc(abs(y)); title(['y']); colorbar;
%             subplot(2,2,4);
%             plot(errAll(1:outer)); axis tight; title(['Sol. error' ]);
%             drawnow;
%         end % rem
    end % nargin
end % outer

% undo the normalization so that results are scaled properly
u = u*normFactorJ/(normFactor*scale);

    function normFactor = getNormalizationFactor(R,f)
        
        normFactor = 1/norm(f(:)/size(R==1,1));
        
    end

    function d = Dx(u)
        [rows,cols,height] = size(u);
        d = zeros(rows,cols,height);
        d(:,2:cols,:) = u(:,2:cols,:)-u(:,1:cols-1,:);
        d(:,1,:) = u(:,1,:)-u(:,cols,:);
    end

    function d = Dxt(u)
        [rows,cols,height] = size(u);
        d = zeros(rows,cols,height);
        d(:,1:cols-1,:) = u(:,1:cols-1,:)-u(:,2:cols,:);
        d(:,cols,:) = u(:,cols,:)-u(:,1,:);
    end

    function d = Dy(u)
        [rows,cols,height] = size(u);
        d = zeros(rows,cols,height);
        d(2:rows,:,:) = u(2:rows,:,:)-u(1:rows-1,:,:);
        d(1,:,:) = u(1,:,:)-u(rows,:,:);
    end

    function d = Dyt(u)
        [rows,cols,height] = size(u);
        d = zeros(rows,cols,height);
        d(1:rows-1,:,:) = u(1:rows-1,:,:)-u(2:rows,:,:);
        d(rows,:,:) = u(rows,:,:)-u(1,:,:);
    end
  
    function [xs,ys] = shrink2(x,y,lambda)
        s = sqrt(x.*conj(x)+y.*conj(y));
        ss = s-lambda;
        ss = ss.*(ss>0);
        
        s = s+(s<lambda);
        ss = ss./s;
        
        xs = ss.*x;
        ys = ss.*y;
    end

    function xs = shrink1(x,lambda)
        s = abs(x);
        xs = sign(x).*max(s-lambda,0);
    end

% =====================================================================
% Krylov solver subroutine
% X = GMRES(A,B,RESTART,TOL,MAXIT,M)
% bicgstab(A,b,tol,maxit)
    function dx = krylov(r)
        %dx = gmres (@jtjx, r, 30, tolKrylov, 100);
        [dx,flag,relres,iter] = bicgstab(@jtjx, r, tolKrylov, 100);
    end

% =====================================================================
% Callback function for matrix-vector product (called by krylov)
    function b = jtjx(sol)
        solMat  = reshape(sol,N);
        
        % Laplacian part
        bTV     = lambda*(Dxt(Dx(solMat))+Dyt(Dy(solMat)));
        
        % Jacobian part
        bJac    = mu*AT(A(sol));
        
        % Stability term
        bG      = gamma*sol;
        
        b       = bTV(:) + bJac(:) + bG(:);
    end
% =====================================================================
end

%