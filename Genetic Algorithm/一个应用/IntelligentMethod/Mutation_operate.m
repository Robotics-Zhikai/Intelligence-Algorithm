function list_Bin_out=Mutation_operate(Mutation_probability,list_Bin_in,parameter_range_Low,parameter_range_Upper,Set_precision) %突变操作
    global column;
    Sum_Bin_number=size(list_Bin_in,1)*size(list_Bin_in,2);
    Mutation_Bin_number=ceil(Sum_Bin_number*Mutation_probability); %突变的基因数
    
    for i=1:Mutation_Bin_number %随机生成Mutation_Bin_number个互不重复的数字在picked_id里
        picked_id(i)=ceil(Sum_Bin_number*unifrnd(0,1));
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
                picked_id(i)=ceil(Sum_Bin_number*unifrnd(0,1));
            end
        end
    end
    
    %对于本问题来说，因为是全排列，解向量的各项有耦合关系，所以突变应成对突变。
    recordMutation = [];%记录突变的行数
    list_Bin_origin = list_Bin_in;%记录未突变的
    for i=1:Mutation_Bin_number
        r=fix(picked_id(i)/size(list_Bin_in,2));
        l=mod(picked_id(i),size(list_Bin_in,2));
        if l==0
            if list_Bin_in(r,size(list_Bin_in,2))==0
                    list_Bin_in(r,size(list_Bin_in,2))=1;
                    recordMutation = [recordMutation;[r,size(list_Bin_in,2)]];
            else
                if list_Bin_in(r,size(list_Bin_in,2))==1
                    list_Bin_in(r,size(list_Bin_in,2))=0;
                    recordMutation = [recordMutation;[r,size(list_Bin_in,2)]];
                end
            end
        else
            if list_Bin_in(r+1,l)==0
                    list_Bin_in(r+1,l)=1;
                    recordMutation = [recordMutation;[r+1,l]];
            else
                if list_Bin_in(r+1,l)==1
                    list_Bin_in(r+1,l)=0;
                    recordMutation = [recordMutation;[r+1,l]];
                end
            end
        end
    end
    
    for i=1:size(recordMutation,1)
        if mod(recordMutation(i,2),column) == 0
            nomut = Decode(parameter_range_Low,parameter_range_Upper,Set_precision,list_Bin_origin(recordMutation(i,1),(fix(recordMutation(i,2)/column)-1)*column+1 : (fix(recordMutation(i,2)/column))*column));
            aftermut = Decode(parameter_range_Low,parameter_range_Upper,Set_precision,list_Bin_in(recordMutation(i,1),(fix(recordMutation(i,2)/column)-1)*column+1 : (fix(recordMutation(i,2)/column))*column));
        else
            nomut = Decode(parameter_range_Low,parameter_range_Upper,Set_precision,list_Bin_origin(recordMutation(i,1),(fix(recordMutation(i,2)/column))*column+1 : (fix(recordMutation(i,2)/column)+1)*column));
            aftermut = Decode(parameter_range_Low,parameter_range_Upper,Set_precision,list_Bin_in(recordMutation(i,1),(fix(recordMutation(i,2)/column))*column+1 : (fix(recordMutation(i,2)/column)+1)*column));
        end
        if (nomut~=aftermut)
            row = recordMutation(i,1);
            nomutBin = list_Bin_origin(recordMutation(i,1),(fix(recordMutation(i,2)/column))*column+1 : (fix(recordMutation(i,2)/column)+1)*column);
%             afternumBin = list_Bin_in(recordMutation(i,1),(fix(recordMutation(i,2)/column))*column+1 : (fix(recordMutation(i,2)/column)+1)*column);
%             nomutDecNumber = Decodechromosome2dec(parameter_range_Low,parameter_range_Upper,Set_precision,list_Bin_origin(row,:));
            aftermutDecNumber = Decodechromosome2dec(parameter_range_Low,parameter_range_Upper,Set_precision,list_Bin_in(row,:));
%             sum(list_Bin_origin(row,:)-list_Bin_in(row,:))
            index = find(aftermutDecNumber==aftermut);
            if size(index,2)~=2
                disp('由于交配出现这样的错误，需要修改交配机制');
                size(index,2)
                continue;
            end
            for indexi = 1:size(index,2)
                if index(indexi) ~= fix(recordMutation(i,2)/column)+1
                    for k=1:column
                        list_Bin_in(row,(index(indexi)-1)*column + k) = nomutBin(k);
                    end
                end
            end
%             for j=1:column:size(list_Bin_in,2)
%                 flag = 0;
%                 for k=0:column-1
%                     if list_Bin_in(row,j+k) ~= afternumBin(k+1)
%                         flag = 1;
%                         break;
%                     end
%                 end
%                 if flag==0
%                     if j~=(fix(recordMutation(i,2)/column))*column+1
%                         for k=0:column - 1
%                             list_Bin_in(row,j+k) = nomutBin(k+1);
%                         end
%                         break;
%                     end
%                 end
%             end
%         nomutDecNumber = Decodechromosome2dec(parameter_range_Low,parameter_range_Upper,Set_precision,list_Bin_origin(row,:));
%         aftermutDecNumber = Decodechromosome2dec(parameter_range_Low,parameter_range_Upper,Set_precision,list_Bin_in(row,:));
%          nomutDecNumber-aftermutDecNumber
        end
        
%         nomut = list_Bin_origin(recordMutation(i),:);
%         aftermut = list_Bin_in(recordMutation(i),:);
%         nomut-aftermut
    end
    list_Bin_out=list_Bin_in;
end





