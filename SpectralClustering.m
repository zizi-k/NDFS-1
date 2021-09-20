function [L] = SpectralClustering( W)
% calculate degree matrix
degs = sum(W, 2);
D= sparse(1:size(W, 1), 1:size(W, 2), degs);
%D=full(D);
% compute unnormalized Laplacian
L = D - W;

degs(degs == 0) = eps;
% calculate D^(-1/2)
D = spdiags(1./(degs.^0.5), 0, size(D, 1), size(D, 2));

% calculate normalized Laplacian
L = D * L * D;

end
