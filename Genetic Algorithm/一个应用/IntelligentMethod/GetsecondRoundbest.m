function [bestsitnum,b] = GetsecondRoundbest(allsitnum,recordindex)%�õ��ڶ���ɸѡ��������� allsitnum��Ҫ�ǵ�һ�ִ�־���ȵ������ɵļ��� 
    gradelist = [];
    for i=1:size(allsitnum,1)
        gradelist = GetsitnumGrade(allsitnum(i,:));
    end
    [a,b] = max (gradelist);
    bestsitnum = allsitnum(b,:);
    b = recordindex(b);
end