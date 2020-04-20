function [bestsitnum,b] = GetsecondRoundbest(allsitnum,recordindex)%得到第二轮筛选的最好序列 allsitnum需要是第一轮打分均相等的情况组成的集合 
    gradelist = [];
    for i=1:size(allsitnum,1)
        gradelist = GetsitnumGrade(allsitnum(i,:));
    end
    [a,b] = max (gradelist);
    bestsitnum = allsitnum(b,:);
    b = recordindex(b);
end