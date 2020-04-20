function list_Bin_out=operate_copy(fitness_list,list_Bin_in) %×ÔÈ»Ñ¡Ôñ
    for i=1:size(list_Bin_in,1)
        random_array(i)=unifrnd(0,1);
    end
    k=1;
    for i=1:size(list_Bin_in,1)
        for j=1:size(list_Bin_in,1)-1
            if (random_array(i)>fitness_list(j,3))&&(random_array(i)<fitness_list(j+1,3))
                list_Bin_out(k,:)=list_Bin_in(j+1,:);
              %  if k<size(list_Bin_in,1)
                   k=k+1;
            end
        end
        if (random_array(i)<fitness_list(1,3))
                list_Bin_out(k,:)=list_Bin_in(1,:);
                %if k<size(list_Bin_in,1)
                   k=k+1;
               % end
        end
    end
end