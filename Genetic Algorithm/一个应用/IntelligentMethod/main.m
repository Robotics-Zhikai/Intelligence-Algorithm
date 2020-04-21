clc
clear
close all

Set_precision=0.0005;
population_number=250;  %��ʼ��Ⱥ����
Mating_probability=0.4; %�������
Mutation_probability=0.0001; %ͻ�����
Gen=150; %�������� 1500

%%
%�޸����µķ������Զ������������޸�
%���ܶ���ʵ��
global szbq ;
szbq = 9;
%x������һ����ȱ
global x1q;
x1q = 8;
%y������һ����ȱ
global y1q;
y1q = 7;
%x������������ȱ
global x2q ;
x2q = 6;
%y�����X�������һ����ȱ
global y1qx1q;
y1qx1q = 5;
%y������������ȱ
global y2q ;
y2q = 3;
%y������������ȱ��x������һ����ȱ
global y2qx1q ;
y2qx1q = 2;
%���ܶ��ǿ�ȱ
global szq ;
szq = 1;
%x��������ȱ��y��1����ȱ21
global x2qy1q;
x2qy1q = 4;

global Area;

% Areastore = xlsread('����ͼ.xlsx');
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

%����Ⱦɫ��

population_x1 = Encode(ParameterLow,ParameterUper,Set_precision,ParameterLow);
global column;
column=size(population_x1,2);


parameter_range_Low=ParameterLow;%���ǳ�����
parameter_range_Upper=ParameterUper;%���ǳ�����

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
    [Best_dec_independent,Best_dec_dependent,Best_Grade]=get_best_result_from_population(parameter_range_Low,parameter_range_Upper,Set_precision,fitness_list,population,GradeList); %��һ����Ⱥ�еõ���Ӧ����õ�һ���⣬�������Ϊ����Ⱥ�͸���Ⱥ����Ӧ�ȱ�
%     if flag == 1
%         flag = 0;
%         lastbestfigure = Best_dec_dependent;
%     end
    recordBest{i,1} = Best_dec_dependent;
    recordBest{i,2} = Best_dec_independent;
    recordBest{i,3} = Best_Grade;
    subplot(121)
    plot(i,Best_dec_dependent,'r.');
    xlabel('����')
    ylabel('Best_dec_dependent')
    title('��õķ���')
%     temp = ylim;
    if Best_dec_dependent>lastbestfigure
        axis([0 Gen (3/4)*Best_dec_dependent Best_dec_dependent]);
    end
%     axis([0 Gen temp(1) temp(2)]);
    hold on;
    subplot(122)
    plot(i,mean(fitness_list(:,1)),'r.');
    xlabel('����')
    ylabel('average��each generation��') %��������Կ���������Ⱥ�Ľ���
    title('ÿ���ķ���ƽ��ֵ')
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
maxBest_dec_dependent = recordBest{1,1}; %�ҵ���ʷ����õ�
final = recordBest(1,:);
for i=1:size(recordBest,1)
    if (recordBest{i,1}>maxBest_dec_dependent)
        maxBest_dec_dependent = recordBest{i,1};
        final = recordBest(i,:);
    end
end
% disp('��ý��������final��');
disp('��õķ�����Best')
Best  = final{1}

disp('�ڿ�˳����BestPath');
BestPath = [];
for i =1:size(final{2},2)
    xy = [ceil(final{2}(i)/size(Areastore,1)),mod(final{2}(i)-1,size(Areastore,1))+1];
    if (Areastore(xy(2),xy(1))~=-1)
        BestPath = [BestPath;{xy}];
    end
end

disp('���еĲ�ͬ������ֵĴ����洢��allsitnum��')
allsitnum = [];
for i=1:size(recordBest,1)
    sitnum = getsitnum(recordBest{i,3});
    allsitnum = [allsitnum;sitnum];
end
disp('��õĲ�ͬ������ֵĴ����洢��bestsitnum��')
bestsitnum = getsitnum(final{3})

equalallsitnum = [];
recordindex = [];
for i = 1:size(recordBest,1)
    if (recordBest{i,1}==final{1}) %���еڶ���ɸѡ������ȵ���߷�����ɸѡ
        recordindex = [recordindex;i];
        equalallsitnum =[equalallsitnum; allsitnum(i,:)];
    end
end
disp('�ڶ���ɸѡ����õĲ�ͬ������ֵĴ����洢��bestbestsitnum��')
[bestbestsitnum,bestindex] = GetsecondRoundbest(equalallsitnum,recordindex);
bestbestsitnum

disp('�ڶ���ɸѡ����ڿ�˳����BestBestPath');
BestBestPath = [];
for i =1:size(recordBest{bestindex,2},2)
    xy = [ceil(recordBest{bestindex,2}(i)/size(Areastore,1)),mod(recordBest{bestindex,2}(i)-1,size(Areastore,1))+1];
    if (Areastore(xy(2),xy(1))~=-1)
        BestBestPath = [BestBestPath;{xy}];
    end
end

%%
%% ����
