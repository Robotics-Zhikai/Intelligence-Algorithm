function DecNumber = Decodechromosome2dec(parameter_range_Low,parameter_range_Upper,Set_precision,chromosome)
    global column;
    DecNumber = [];
    for numdecn = 1:size(chromosome,2)/column
        DecNumber(numdecn) = Decode(parameter_range_Low,parameter_range_Upper,Set_precision,chromosome(1,(numdecn-1)*column+1 : numdecn*column));
    end
end