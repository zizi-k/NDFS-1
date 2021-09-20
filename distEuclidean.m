function [ d ] = distEuclidean( M, N )


d = abs(sum((M - N) .^ 2));

end
