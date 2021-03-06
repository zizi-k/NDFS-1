function [F,W,obj]=NDFS(X,L,F,W,maxIter,alpha,beta,gamma)
%	X: Rows of vectors of data points
%	L: The laplacian matrix.
%   F: the cluster result
%   W: the feature selection matrix

if nargin == 0
    return; 
end

[nFeat,nSamp] = size(X);

if size(L,1) ~= nSamp
    error('L is error');
end
XX=X*X';

Wi = sqrt(sum(W.*W,2)+eps);
d = 0.5./Wi;
D = diag(d);

% G=inv(XX+beta*D);
% W=G*X*F;
% Wi = sqrt(sum(W.*W,2)+eps);
% d = 0.5./Wi;
% D = diag(d);
% clear Wi
% M=L+alpha*(eye(nSamp)-X'*G*X);
% clear G
% M=(M+M')/2;
% F = F.*(gamma*F + eps)./(M*F + gamma*F*F'*F + eps);
% F = F*diag(sqrt(1./(diag(F'*F)+eps)));

iter=1;
while iter<=maxIter || (iter>2&& obj(end-1)-obj(end)>10^(-3)*obj(end))
    
    G=inv(XX+beta*D);
    W=G*X*F;
    Wi = sqrt(sum(W.*W,2)+eps);
    d = 0.5./Wi;
    D = diag(d);
    clear Wi
    M=L+alpha*(eye(nSamp)-X'*G*X);
    clear G
    M=(M+M')/2;

    F = F.*(gamma*F + eps)./(M*F + gamma*F*F'*F + eps);
    F = F*diag(sqrt(1./(diag(F'*F)+eps)));
    clear Wnew   
    
    obj(iter)=trace(F'*M*F)+gamma/4*norm(F'*F-eye(size(F,2)),'fro')^2;
    
    if mod(iter, 100) == 0
        fprintf('Iter %d\tobj=%f\n',iter,obj(end));
    end
    
    iter=iter+1;
    
end