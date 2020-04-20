clear 
clc
close all

global Distance_matrix;
global city;
Data

global alpha;
global yita;
global beita;
global pheromone_concentration_matrix;
global thou;
global Q; %信息素常数
%启发函数
for i=1:size(Distance_matrix,1)
    for j=1:size(Distance_matrix,2)
        yita(i,j)=1/Distance_matrix(i,j);
    end
end
%信息素浓度矩阵


alpha=1; %信息素重要程度因子
beita=4.5; %启发函数重要程度因子
thou=0.2; %挥发因子
Q=1;

MAXGEN=60; %最大迭代次数
amout_of_ants=78; %蚂蚁的个数
Min_Distance=inf;
The_end=0;
for i=1:size(Distance_matrix,1)
    for j=1:size(Distance_matrix,2)
        if i~=j
            pheromone_concentration_matrix(i,j)=1;
        else
            pheromone_concentration_matrix(i,j)=0;
        end
    end
end

        
for GEn=1:MAXGEN
    ant_colony_path_list=init_path(amout_of_ants);
    while The_end==0
        [ant_colony_path_list,The_end]=update_pheromone_concentration_matrix(ant_colony_path_list);
    end
    The_end=0;
    [Distance,record,path]=Get_distance(ant_colony_path_list);
     %取消下面的注释可以只看每次迭代路程的值
%     plot(GEn,Distance,'o');
%     xlabel('代数')
%     ylabel('计算得到的总路程')
%     hold on;
%     drawnow;
   
   %Min_Distance_record=Min_record;
   Distance=min(Distance);
    if Distance<Min_Distance
        Min_Distance=Distance;
        Min_record=record;
        Min_path=path;
       path_sequence_last=path';
        for i=1:size(path_sequence_last,2)
            position_x(i)=city(path_sequence_last(i),1);
            position_y(i)=city(path_sequence_last(i),2);
            if i==1
                plot(position_x(i),position_y(i),'o');
            else
                plot(position_x(i),position_y(i),'.');
            end
            hold on;
        end
        position_x(i+1)=city(path_sequence_last(1),1);
        position_y(i+1)=city(path_sequence_last(1),2);
        plot(position_x,position_y);
        drawnow;
        hold off;
    end
end


function ant_colony_path_list_out=init_path(amout_of_ants)
    global city;
    for i=1:amout_of_ants
        ant_colony_path_list_out(1,i)=ceil(size(city,1)*unifrnd(0,1));
    end
end

function Not_walked_city=Get_allow_city(walked_city) %输出为一列的列向量,输入为已经走过的城市编号,输出为未走过的城市,城市编号从1开始
    global city;
      k=1;
      flag=0;
      Not_walked_city=0;
%    Not_walked_city=setdiff(1:1:size(city,1),walked_city');
    for i=1:size(city,1)
        for j=1:size(walked_city,1)
            if i==walked_city(j,1)
                flag=1;
                break;
            end
        end
        if flag==0
            Not_walked_city(k)=i;
            k=k+1;
        else
            flag=0;
        end
    end
%     if isempty(Not_walked_city)
%         Not_walked_city=0;
%         return;
%     end
    if Not_walked_city==0
        return;
    end
    Not_walked_city=Not_walked_city';
end

function possibility_2_j=Get_possibility(city_j,ant_colony_path_list_column) %输出为到city_j的概率，pheromone_concentration_matrix为信息素浓度矩阵
    global alpha;
    global yita;
    global beita;
    global pheromone_concentration_matrix;
%     persistent flag11;
%     if isempty(flag11)
%         flag11=1;
%     end
    city_i=ant_colony_path_list_column(size(ant_colony_path_list_column,1),1);
    Not_walked_city=Get_allow_city(ant_colony_path_list_column); %找到没有走过的城市集合
    for i=1:size(ant_colony_path_list_column,1)
        if city_j==ant_colony_path_list_column(i,1)
            possibility_2_j=0;
            return;
        end
    end
    possibility_2_j=(pheromone_concentration_matrix(city_i,city_j))^alpha*(yita(city_i,city_j))^beita;
    Sum=0;
    for i=1:size(Not_walked_city,1)
        Sum=Sum+(pheromone_concentration_matrix(city_i,Not_walked_city(i,1)))^alpha*yita(city_i,Not_walked_city(i,1))^beita;
    end
    possibility_2_j=possibility_2_j/Sum; %当迭代代数过多时，pheromone_concentration_matrix对应元素太小，为十的负344次方，直接溢出，造成了0/0=NAN而出错
end

function city_j=Get_next_city(ant_colony_path_list_column) %得到单个蚂蚁下一步将要去的城市
    Not_walked_city=Get_allow_city(ant_colony_path_list_column);
    if Not_walked_city == 0
        city_j=0;
        return;
    end
    accumulation_possibility=0;
    accumulation_possibility(1,2)=Get_possibility(Not_walked_city(1,1),ant_colony_path_list_column);
    accumulation_possibility(1,1)=Not_walked_city(1,1);
    for i=2:size(Not_walked_city,1) %得到累积概率
        accumulation_possibility(i,2)=accumulation_possibility(i-1,2)+Get_possibility(Not_walked_city(i,1),ant_colony_path_list_column);
        accumulation_possibility(i,1)=Not_walked_city(i,1);
    end
    evaluation=unifrnd(0,1);   
    accumulation_possibility=[0,0;accumulation_possibility];
    for i=1:size(accumulation_possibility,1) %按照概率得到下一步要去的城市
        if (evaluation>accumulation_possibility(i,2))&&(evaluation<=accumulation_possibility(i+1,2))
            city_j=accumulation_possibility(i+1,1);
        end
    end
    if isempty(city_j)
        city_j=Get_allow_city(ant_colony_path_list_column);
    end
end

function [ant_colony_path_list_OUT,The_end]=update_ant_colony_path_list(ant_colony_path_list_IN) %更新蚂蚁路径表,所有的蚂蚁
    The_end=0;
    ant_colony_path_list_OUT=[];
    for i=1:size(ant_colony_path_list_IN,2)
        ant_colony_path_list_IN_column=ant_colony_path_list_IN(:,i);
        city_j=Get_next_city(ant_colony_path_list_IN_column);
        if city_j~=0
            ant_colony_path_list_IN_column(size(ant_colony_path_list_IN_column,1)+1,1)=city_j;
        else
            The_end=1;
        end
        ant_colony_path_list_OUT=[ant_colony_path_list_OUT,ant_colony_path_list_IN_column];
    end
end

function [ant_colony_path_list,The_end]=update_pheromone_concentration_matrix(ant_colony_path_list_in) %更新信息素浓度矩阵，并得到蚂蚁路径表
    global pheromone_concentration_matrix;
    global thou;
    global Distance_matrix;
    global Q; 
    The_end=0;
    [ant_colony_path_list,The_end]=update_ant_colony_path_list(ant_colony_path_list_in);
    if The_end==1
        return;
    end
    for i=1:size(pheromone_concentration_matrix,1) %逐个更新信息素矩阵浓度
        for j=i+1:size(pheromone_concentration_matrix,2)
            deltaij=0;
            for k=1:size(ant_colony_path_list,2)
                for l=1:size(ant_colony_path_list,1)-1
                    if ((ant_colony_path_list(l,k)==i)&&(ant_colony_path_list(l+1,k)==j))||((ant_colony_path_list(l,k)==j)&&(ant_colony_path_list(l+1,k)==i))
                        %deltaij=deltaij+Q/Distance_matrix(i,j); %把当前所有蚂蚁经过该段路程释放信息素而增加的信息素浓度累积起来
                        deltaij=deltaij+Q;
                    end
                end
            end
            pheromone_concentration_matrix(i,j)=(1-thou)*pheromone_concentration_matrix(i,j)+deltaij;
            pheromone_concentration_matrix(j,i)=(1-thou)*pheromone_concentration_matrix(j,i)+deltaij;
        end
    end
end

function [Min_distance,Min_record,path]=Get_distance(ant_colony_path_list_in) %获取ant_colony_path_list_in中走最短的路径，Min_record为对应的蚂蚁编号
    global Distance_matrix;
    for i=1:size(ant_colony_path_list_in,2)
        Distance(1,i)=0;
        for j=1:size(ant_colony_path_list_in,1)-1
            Distance(1,i)=Distance(1,i)+Distance_matrix(ant_colony_path_list_in(j,i),ant_colony_path_list_in(j+1,i));
        end
    end
    Min_distance=min(Distance);
    Min_record=0;
    for i=1:size(Distance,2)
        if Min_distance==Distance(1,i)
           Min_record=i;
        end
    end
    Min_distance=Min_distance+Distance_matrix(ant_colony_path_list_in(size(ant_colony_path_list_in,1),Min_record),ant_colony_path_list_in(1,Min_record));
    path=ant_colony_path_list_in(:,Min_record);
end











