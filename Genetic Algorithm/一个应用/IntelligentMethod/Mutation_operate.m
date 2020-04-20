function list_Bin_out=Mutation_operate(Mutation_probability,list_Bin_in) %突变操作
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
    
    for i=1:Mutation_Bin_number
        r=fix(picked_id(i)/size(list_Bin_in,2));
        l=mod(picked_id(i),size(list_Bin_in,2));
        if l==0
            if list_Bin_in(r,size(list_Bin_in,2))==0
                    list_Bin_in(r,size(list_Bin_in,2))=1;
            else
                if list_Bin_in(r,size(list_Bin_in,2))==1
                    list_Bin_in(r,size(list_Bin_in,2))=0;
                end
            end
        else
            if list_Bin_in(r+1,l)==0
                    list_Bin_in(r+1,l)=1;
            else
                if list_Bin_in(r+1,l)==1
                    list_Bin_in(r+1,l)=0;
                end
            end
        end
    end
    list_Bin_out=list_Bin_in;
end