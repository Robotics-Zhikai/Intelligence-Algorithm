function chromosome = Getchromosome(ParameterLow,ParameterUper,Set_precision,randpermseq)
    chromosome = [];
    for i=1:size(randpermseq,2)
        chromosome = [chromosome Encode(ParameterLow,ParameterUper,Set_precision,randpermseq(i))];
    end
end