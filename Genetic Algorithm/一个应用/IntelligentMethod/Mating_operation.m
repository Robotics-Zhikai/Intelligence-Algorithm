function list_Bin_out=Mating_operation(Mating_probability,list_Bin_in,parameter_range_Low,parameter_range_Upper,Set_precision)   %交叉操作
    %ceil(10*unifrnd(0,1)); %生成1-10的随机整数 均匀分布
    mating_number=round(size(list_Bin_in,1)*Mating_probability);
    if (mod(mating_number,2)~=0)  %保证是二的倍数
        mating_number=fix(mating_number);
    end
    if (mod(mating_number,2)~=0)
        mating_number=ceil(mating_number);
    end
    if (mod(mating_number,2)~=0)
        mating_number=mating_number+1;
    end
    
    for i=1:mating_number %随机生成mating_number个互不重复的数字在picked_id里
        picked_id(i)=ceil(size(list_Bin_in,1)*unifrnd(0,1));
        flag=0;
        while 1
            for j=1:i-1
                if (picked_id(i)~=picked_id(j))
                    flag=flag+1;
                end
            end
            if flag==i-1
                break;
            else
                flag=0;
                picked_id(i)=ceil(size(list_Bin_in,1)*unifrnd(0,1));
            end
        end
    end
    
    for i=1:2:mating_number-1
        chromosome1=list_Bin_in(picked_id(i),:);
        chromosome2=list_Bin_in(picked_id(i+1),:);
%         chromosome1DecNumbertemp = Decodechromosome2dec(parameter_range_Low,parameter_range_Upper,Set_precision,chromosome1);
%         chromosome2DecNumbertemp = Decodechromosome2dec(parameter_range_Low,parameter_range_Upper,Set_precision,chromosome2);
%         chromosome1temp = chromosome1;
%         chromosome2temp = chromosome2;
        random_number=ceil(size(chromosome1,2)*unifrnd(0,1));
        for j=random_number:size(chromosome1,2)
            mid_number=chromosome1(j);
            chromosome1(j)=chromosome2(j);
            chromosome2(j)=mid_number;
        end
        list_Bin_in(picked_id(i),:)=chromosome1;
        list_Bin_in(picked_id(i+1),:)=chromosome2;
%         chromosome1DecNumber = Decodechromosome2dec(parameter_range_Low,parameter_range_Upper,Set_precision,chromosome1);
%         chromosome2DecNumber = Decodechromosome2dec(parameter_range_Low,parameter_range_Upper,Set_precision,chromosome2);
%         chromosome1DecNumbertemp-chromosome1DecNumber
%         chromosome2DecNumbertemp-chromosome2DecNumber
    end
    list_Bin_out=list_Bin_in;
end
