function [W_sim] = SimGraph(data)

% set the parameters
sigma = 1;
n=size(data,1);
for ii = 1:n
            dist_1 = distEuclidean(repmat(data(ii,:)', 1, n), data');
            
            [s, O] = sort(dist_1, 'ascend');
            
            kk(ii,:)=O(1,2:6);
end

for i=1:size(data,1)    
    for j=1:size(data,1)
        
        if(ismember(i,kk(j,:))~=0 || ismember(j,kk(i,:))~=0 )
           % dist = sqrt((data(i,1) - data(j,1))^2 + (data(i,2) - data(j,2))^2);
           dist_2=distEuclidean(data(i,:),data(j,:));
            W_sim(i,j) = exp(-dist_2/(2*sigma^2));
        else 
           W_sim(i,j)=0;
        end

    end
end
end
