function [ accuracy ] = ACC( actual,pred )

numcorrect = sum(actual==pred);
accuracy = numcorrect/length(actual);
end

