%��һ�����򻮷�Ϊ������Խ��������Ϊ�������������ɿ��Ƴ���Ϊ�������пɿ��ơ�
%δ�ڵ���������Ϊ1.
%���˵�����Ϊ������Ϊ0��
%�������ڵ���������Ϊ-1��
%����ʵ�ʴ���ȱ�飬�����ڲ������ڵ�����ҲӦ��ͨ������-1 ��֤����Ĺ���
%Area �Ǹ�����Ŀ�ͼȥ�޸ĵģ���ʼ������ֵΪ1.

clear
close all
clc
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

%����ϵ��x�����ң�y������
SizeX = 15;%��ͼ��x�᷽��ĳ���
SizeY = 10;%��ͼ��y�᷽��ĳ���
Areastore = ones(SizeY,SizeX); %�����볣��ĵ�ͼx y �ǲ�һ���� ��������
% Areastore = xlsread('����ͼ.xlsx');
Area = Areastore;



BestGrade = 0;
BestPath = [];

disp('����Iteration�Σ�IterationԽ��Խ�л����ҵ�����ֵ');
Iteration = 500
recordall = [];
for num = 1:Iteration
    record = [];
    situationrecord = [];
%     Area = ones(SizeY,SizeX); %�����볣��ĵ�ͼx y �ǲ�һ���� ��������
    Area = Areastore;
    solution = randperm((size(Area,2))*(size(Area,1)));
    for i=1:size(solution,2)
        xy = [ceil(solution(i)/size(Area,1)),mod(solution(i)-1,size(Area,1))+1];
        Grade = GetGrade(Area,xy+[1,1]);
        situationrecord = [situationrecord;Grade];
        
        if (Grade~=0)
            record = [record,[{xy};Grade]];
        end
        Area(xy(2),xy(1)) = 0;
    end
    recordall = [recordall;{situationrecord}];
    allGrade = 0;
    for i=1:size(record,2)
        allGrade = record{2,i} + allGrade;
    end
    if (allGrade>BestGrade)
        BestGrade = allGrade
        BestPath = record(1,:);
        BestSituationrecord = situationrecord;
    end
end
finalBestPath = BestPath';

disp('����Iteration�κ���ѷ���ΪfinalBestGrade');
finalBestGrade = BestGrade
disp('��ѿ���˳�򴢴���finalBestPath��');

disp('��ͬ������ֵĴ������������sitnum')
for i=1:size(recordall,1)
    sitnum = getsitnum(recordall{i});
end
disp('��õĲ�ͬ������ֵĴ����洢��bestsitnum��')
bestsitnum = getsitnum(BestSituationrecord)

for i=1:size(finalBestPath,1)
    plot(finalBestPath{i}(1),finalBestPath{i}(2),'r.');
    hold on ;
    pause(0.0005);
end










