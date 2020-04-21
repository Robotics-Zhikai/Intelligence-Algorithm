clc
clear
close all

Set_precision=0.0005;
population_number=250;  %初始种群数量
Mating_probability=0.4; %交配概率
Mutation_probability=0.0001; %突变概率
Gen=150; %迭代代数 1500

%%
%修改如下的分数可以对相对排序进行修改
%四周都是实体
global szbq ;
szbq = 9;
%x方向有一个空缺
global x1q;
x1q = 8;
%y方向有一个空缺
global y1q;
y1q = 7;
%x方向有两个空缺
global x2q ;
x2q = 6;
%y方向和X方向各有一个空缺
global y1qx1q;
y1qx1q = 5;
%y方向有两个空缺
global y2q ;
y2q = 3;
%y方向有两个空缺和x方向有一个空缺
global y2qx1q ;
y2qx1q = 2;
%四周都是空缺
global szq ;
szq = 1;
%x有两个空缺，y有1个空缺21
global x2qy1q;
x2qy1q = 4;

global Area;

% Areastore = xlsread('数据图.xlsx');
Areastore = ones(10,15);
Area = Areastore;

ParameterLow = 1;
ParameterUper = size(Area,1)*size(Area,2);
population = [];
for j=1:population_number
    OneSolution = randperm(ParameterUper);
    chromosome = Getchromosome(ParameterLow,ParameterUper,Set_precision,OneSolution);
%     chromosome = [];
%     for i=1:size(OneSolution,2)
%         chromosome = [chromosome Encode(ParameterLow,ParameterUper,Set_precision,OneSolution(i))];
%     end
    population = [population;chromosome];
end

%构建染色体

population_x1 = Encode(ParameterLow,ParameterUper,Set_precision,ParameterLow);
global column;
column=size(population_x1,2);


parameter_range_Low=ParameterLow;%这是常矩阵
parameter_range_Upper=ParameterUper;%这是常矩阵

[fitness_list,GradeList,population]=evalfuc(parameter_range_Low,parameter_range_Upper,Set_precision,population);
 lastbestfigure = max(fitness_list(:,1));
axis([0 Gen (3/4)*max(fitness_list(:,1)) max(fitness_list(:,1))]);
recordBest = [];
flag = 1;
gifFlag = 1;
for i=1:Gen
    population=operate_copy(fitness_list,population);
    population=Mating_operation(Mating_probability,population,parameter_range_Low,parameter_range_Upper,Set_precision);
    population=Mutation_operate(Mutation_probability,population,parameter_range_Low,parameter_range_Upper,Set_precision);
    [fitness_list,GradeList,population]=evalfuc(parameter_range_Low,parameter_range_Upper,Set_precision,population);
    [Best_dec_independent,Best_dec_dependent,Best_Grade]=get_best_result_from_population(parameter_range_Low,parameter_range_Upper,Set_precision,fitness_list,population,GradeList); %从一个种群中得到适应度最好的一个解，输入参数为该种群和该种群的适应度表
%     if flag == 1
%         flag = 0;
%         lastbestfigure = Best_dec_dependent;
%     end
    recordBest{i,1} = Best_dec_dependent;
    recordBest{i,2} = Best_dec_independent;
    recordBest{i,3} = Best_Grade;
    subplot(121)
    plot(i,Best_dec_dependent,'r.');
    xlabel('代数')
    ylabel('Best_dec_dependent')
    title('最好的分数')
%     temp = ylim;
    if Best_dec_dependent>lastbestfigure
        axis([0 Gen (3/4)*Best_dec_dependent Best_dec_dependent]);
    end
%     axis([0 Gen temp(1) temp(2)]);
    hold on;
    subplot(122)
    plot(i,mean(fitness_list(:,1)),'r.');
    xlabel('代数')
    ylabel('average（each generation）') %从这里可以看到优势种群的进化
    title('每代的分数平均值')
    if Best_dec_dependent>lastbestfigure
        axis([0 Gen (3/4)*Best_dec_dependent Best_dec_dependent]);
        lastbestfigure = Best_dec_dependent;
    end
    hold on;
    drawnow;
    
    
    frame=getframe(gcf);
    imind=frame2im(frame);
    [imind,cm] = rgb2ind(imind,256);

    if gifFlag~=99
    imwrite(imind,cm,'test5.gif','gif', 'Loopcount',inf,'DelayTime',1e-4);
    gifFlag = 99;
    else
    imwrite(imind,cm,'test5.gif','gif','WriteMode','append','DelayTime',1e-4);
    end
            
end
maxBest_dec_dependent = recordBest{1,1}; %找到历史中最好的
final = recordBest(1,:);
for i=1:size(recordBest,1)
    if (recordBest{i,1}>maxBest_dec_dependent)
        maxBest_dec_dependent = recordBest{i,1};
        final = recordBest(i,:);
    end
end
% disp('最好结果储存在final中');
disp('最好的分数是Best')
Best  = final{1}

disp('挖矿顺序是BestPath');
BestPath = [];
for i =1:size(final{2},2)
    xy = [ceil(final{2}(i)/size(Areastore,1)),mod(final{2}(i)-1,size(Areastore,1))+1];
    if (Areastore(xy(2),xy(1))~=-1)
        BestPath = [BestPath;{xy}];
    end
end

disp('所有的不同情况出现的次数存储在allsitnum中')
allsitnum = [];
for i=1:size(recordBest,1)
    sitnum = getsitnum(recordBest{i,3});
    allsitnum = [allsitnum;sitnum];
end
disp('最好的不同情况出现的次数存储在bestsitnum中')
bestsitnum = getsitnum(final{3})

equalallsitnum = [];
recordindex = [];
for i = 1:size(recordBest,1)
    if (recordBest{i,1}==final{1}) %进行第二轮筛选，在相等的最高分数中筛选
        recordindex = [recordindex;i];
        equalallsitnum =[equalallsitnum; allsitnum(i,:)];
    end
end
disp('第二轮筛选的最好的不同情况出现的次数存储在bestbestsitnum中')
[bestbestsitnum,bestindex] = GetsecondRoundbest(equalallsitnum,recordindex);
bestbestsitnum

disp('第二轮筛选后的挖矿顺序是BestBestPath');
BestBestPath = [];
for i =1:size(recordBest{bestindex,2},2)
    xy = [ceil(recordBest{bestindex,2}(i)/size(Areastore,1)),mod(recordBest{bestindex,2}(i)-1,size(Areastore,1))+1];
    if (Areastore(xy(2),xy(1))~=-1)
        BestBestPath = [BestBestPath;{xy}];
    end
end

%%
%% 函数
