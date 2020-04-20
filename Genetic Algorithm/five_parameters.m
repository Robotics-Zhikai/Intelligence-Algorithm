clc
clear
close all
%��������������x1(i1)^2+x2(i2)^2+3*x3(i3)^2+4*x4(i4)^2+2*x5(i5)^2-8*x1(i1)-2*x2(i2)-3*x3(i3)-x4(i4)-2*x5(i5)�ļ�ֵ
Set_precision=0.0001;
population_number=80;  %��ʼ��Ⱥ����
Mating_probability=0.4; %�������
Mutation_probability=0.001; %ͻ�����
Gen=1500; %��������
%���ֵΪ1.02e5
%1.027e5
%1.028e5
%%
%���Ա�����5��ʱ
% x1=0:0.01:100;
% x2=0:0.01:100;
% x3=0:0.01:70;
% x4=0:0.01:80;
% x5=0:0.01:150;
% k=1;
% for i1=1:size(x1,2)
%     for i2=1:size(x2,2)
%         for i3=1:size(x3,2)
%             for i4=1:size(x4,2)
%                 for i5=1:size(x5,2)
%                     result(k)=x1(i1)^2+x2(i2)^2+3*x3(i3)^2+4*x4(i4)^2+2*x5(i5)^2-8*x1(i1)-2*x2(i2)-3*x3(i3)-x4(i4)-2*x5(i5);
%                     k=k+1;
%                 end
%             end
%         end
%     end
% end

parameter_x1_range_low=0;
parameter_x2_range_low=0;
parameter_x3_range_low=0;
parameter_x4_range_low=0;
parameter_x5_range_low=0;
parameter_x1_range_upper=100;
parameter_x2_range_upper=100;
parameter_x3_range_upper=70;
parameter_x4_range_upper=80;
parameter_x5_range_upper=150;

%����Ⱦɫ��
population_x1=init_population(parameter_x1_range_low,parameter_x1_range_upper,Set_precision,population_number);
population_x2=init_population(parameter_x2_range_low,parameter_x2_range_upper,Set_precision,population_number);
population_x3=init_population(parameter_x3_range_low,parameter_x3_range_upper,Set_precision,population_number);
population_x4=init_population(parameter_x4_range_low,parameter_x4_range_upper,Set_precision,population_number);
population_x5=init_population(parameter_x5_range_low,parameter_x5_range_upper,Set_precision,population_number);
population=[population_x1,population_x2,population_x3,population_x4,population_x5];

global column_x1;
column_x1=size(population_x1,2);
global column_x2;
column_x2=size(population_x2,2);
global column_x3;
column_x3=size(population_x3,2);
global column_x4;
column_x4=size(population_x4,2);
global column_x5;
column_x5=size(population_x5,2);

parameter_range_Low=[parameter_x1_range_low;parameter_x2_range_low;parameter_x3_range_low;parameter_x4_range_low;parameter_x5_range_low];%���ǳ�����
parameter_range_Upper=[parameter_x1_range_upper;parameter_x2_range_upper;parameter_x3_range_upper;parameter_x4_range_upper;parameter_x5_range_upper];%���ǳ�����

fitness_list=eval(parameter_range_Low,parameter_range_Upper,Set_precision,population);
for i=1:Gen
    population=operate_copy(fitness_list,population);
    population=Mating_operation(Mating_probability,population);
    population=Mutation_operate(Mutation_probability,population);
    fitness_list=eval(parameter_range_Low,parameter_range_Upper,Set_precision,population);
    [Best_dec_independent,Best_dec_dependent]=get_best_result_from_population(parameter_range_Low,parameter_range_Upper,Set_precision,fitness_list,population); %��һ����Ⱥ�еõ���Ӧ����õ�һ���⣬�������Ϊ����Ⱥ�͸���Ⱥ����Ӧ�ȱ�
    subplot(121)
    plot(i,Best_dec_dependent,'.');
    xlabel('����')
    ylabel('Best_dec_dependent')
    hold on;
    subplot(122)
    plot(i,mean(fitness_list(:,1)),'.');
    xlabel('����')
    ylabel('average��each generation��') %��������Կ���������Ⱥ�Ľ���
    hold on;
    drawnow;
end
%%
%% ����
function Bin_number=Encode(parameter_range_Low,parameter_range_Upper,Set_precision,Dec_number) %����Ϊʮ�����������Ϊ����������
    digits=ceil(log2((parameter_range_Upper-parameter_range_Low)*(1/Set_precision)+1));
    Dec_number=round((Dec_number-parameter_range_Low) / ((parameter_range_Upper-parameter_range_Low)/(2^digits-1)));
    Sub_Bin_number=dec2bin(Dec_number,digits);
    for i=1:digits
        Bin_number(i)=double(Sub_Bin_number(i))-48;
    end
end

function Dec_number=Decode(parameter_range_Low,parameter_range_Upper,Set_precision,Bin_number) %����Ϊ�����������������Ϊ10������
    Sub_dec=0;
    for i=1:size(Bin_number,2)
        Sub_dec=Sub_dec+Bin_number(size(Bin_number,2)-i+1)*2^(i-1);
    end
    Dec_number=parameter_range_Low+Sub_dec* ( (parameter_range_Upper-parameter_range_Low) / (2^size(Bin_number,2)-1) );
end

function init_list_Bin=init_population(parameter_range_Low,parameter_range_Upper,Set_precision,population_number) %��ʼ����Ⱥ����������������ޡ����Ⱥ���Ⱥ����
    for i=1:population_number
        init_list_Bin(i,:)=Encode(parameter_range_Low,parameter_range_Upper,Set_precision,parameter_range_Low+unifrnd(Set_precision,parameter_range_Upper-parameter_range_Low));
    end
end

function fitness_list=eval(parameter_range_Low,parameter_range_Upper,Set_precision,init_list_Bin) %������Ӧ�ȣ���Ӧ�Ⱥ����������������ʵ���������,����������Ƕ����Ƶĳ�ʼ����Ⱥ
    global column_x1;
    global column_x2;
    global column_x3;
    global column_x4;
    global column_x5;
    Sum=0;
    for i=1:size(init_list_Bin,1)
        Dec_number_x1=Decode(parameter_range_Low(1,:),parameter_range_Upper(1,:),Set_precision,init_list_Bin(i,1:column_x1));
        Dec_number_x2=Decode(parameter_range_Low(2,:),parameter_range_Upper(2,:),Set_precision,init_list_Bin(i,column_x1+1:column_x1+column_x2));
        Dec_number_x3=Decode(parameter_range_Low(3,:),parameter_range_Upper(3,:),Set_precision,init_list_Bin(i,column_x1+column_x2+1:column_x1+column_x2+column_x3));
        Dec_number_x4=Decode(parameter_range_Low(4,:),parameter_range_Upper(4,:),Set_precision,init_list_Bin(i,column_x1+column_x2+column_x3+1:column_x1+column_x2+column_x3+column_x4));
        Dec_number_x5=Decode(parameter_range_Low(5,:),parameter_range_Upper(5,:),Set_precision,init_list_Bin(i,column_x1+column_x2+column_x3+column_x4+1:column_x1+column_x2+column_x3+column_x4+column_x5));
        
        fitness_list(i,1)=Dec_number_x1^2+Dec_number_x2^2+3*Dec_number_x3^2+4*Dec_number_x4^2+2*Dec_number_x5^2-8*Dec_number_x1-2*Dec_number_x2-3*Dec_number_x3-Dec_number_x4-2*Dec_number_x5;
        Sum=Sum+fitness_list(i,1); %������Ӧ��ֵ�ܺ�
    end
    for i=1:size(init_list_Bin,1)
        fitness_list(i,2)=fitness_list(i,1)/Sum; %�ڶ�������ӦȾɫ�屻���Ƶĸ���
        if i==1
            fitness_list(i,3)=fitness_list(i,2);
        else
            fitness_list(i,3)=fitness_list(i-1,3)+fitness_list(i,2);
        end
    end
end

function list_Bin_out=operate_copy(fitness_list,list_Bin_in) %��Ȼѡ��
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

function list_Bin_out=Mating_operation(Mating_probability,list_Bin_in)   %�������
    %ceil(10*unifrnd(0,1)); %����1-10��������� ���ȷֲ�
    mating_number=round(size(list_Bin_in,1)*Mating_probability);
    if (mod(mating_number,2)~=0)  %��֤�Ƕ��ı���
        mating_number=fix(mating_number);
    end
    if (mod(mating_number,2)~=0)
        mating_number=ceil(mating_number);
    end
    if (mod(mating_number,2)~=0)
        mating_number=mating_number+1;
    end
    
    for i=1:mating_number %�������mating_number�������ظ���������picked_id��
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
        random_number=ceil(size(chromosome1,2)*unifrnd(0,1));
        for j=random_number:size(chromosome1,2)
            mid_number=chromosome1(j);
            chromosome1(j)=chromosome2(j);
            chromosome2(j)=mid_number;
        end
        list_Bin_in(picked_id(i),:)=chromosome1;
        list_Bin_in(picked_id(i+1),:)=chromosome2;
    end
    list_Bin_out=list_Bin_in;
end

function list_Bin_out=Mutation_operate(Mutation_probability,list_Bin_in) %ͻ�����
    Sum_Bin_number=size(list_Bin_in,1)*size(list_Bin_in,2);
    Mutation_Bin_number=ceil(Sum_Bin_number*Mutation_probability); %ͻ��Ļ�����
    
    for i=1:Mutation_Bin_number %�������Mutation_Bin_number�������ظ���������picked_id��
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

function [Best_dec_independent,Best_dec_dependent]=get_best_result_from_population(parameter_range_Low,parameter_range_Upper,Set_precision,fitness_list,list_Bin_in) %��һ����Ⱥ�еõ���Ӧ����õ�һ���⣬�������Ϊ����Ⱥ�͸���Ⱥ����Ӧ�ȱ�
    global column_x1;
    global column_x2;
    global column_x3;
    global column_x4;
    global column_x5;
    column=[column_x1,column_x2,column_x3,column_x4,column_x5];
    Sub_max=fitness_list(1,1);
    row_of_max=1;
    for i=1:size(fitness_list,1) %�ҵ�����Ⱥ�������Ӧ�ȵĸ���
        if fitness_list(i,1)>Sub_max
            Sub_max=fitness_list(i,1);
            row_of_max=i;
        end
    end
    j=0;
    for i=1:size(parameter_range_Low,1)
        if (i==1)
            j=1;
        else
            j=j+column(i-1);
        end
        Best_dec_independent(i)=Decode(parameter_range_Low(i,:),parameter_range_Upper(i,:),Set_precision,list_Bin_in(row_of_max,j:j-1+column(i)));
    end
    Best_dec_dependent=Best_dec_independent(1)^2+Best_dec_independent(2)^2+3*Best_dec_independent(3)^2+4*Best_dec_independent(4)^2+2*Best_dec_independent(5)^2-8*Best_dec_independent(1)-2*Best_dec_independent(2)-3*Best_dec_independent(3)-Best_dec_independent(4)-2*Best_dec_independent(5);
end

