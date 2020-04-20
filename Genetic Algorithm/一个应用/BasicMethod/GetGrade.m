function Grade = GetGrade(Area,xy) %得到某一网格的分数
    Area = [-1*ones(size(Area,1),1),Area];
    Area = [Area;-1*ones(1,size(Area,2))];
    Area = [Area,-1*ones(size(Area,1),1)];
    Area = [-1*ones(1,size(Area,2));Area];
    %必须得保证从网格抽象过来的矩阵的最外层值为-1
    Area = Area';
    if (Area(xy(1),xy(2))==-1)
        Grade = 0;
        return;
    end
    global szbq ;
    global x1q;
    global y1q;
    global x2q;
    global y1qx1q;
    global y2q;
    global y2qx1q;
    global szq;
    global x2qy1q;
    Grade = 0;
    if (IsEdge(Area,xy)==1)
        if (Area(xy(1),xy(2)+1)==-1)
            Area(xy(1),xy(2)+1) = 1;
        end
        if (Area(xy(1),xy(2)-1)==-1)
            Area(xy(1),xy(2)-1) = 1;
        end
        if (Area(xy(1)-1,xy(2))==-1)
            Area(xy(1)-1,xy(2)) = 1;
        end
        if (Area(xy(1)+1,xy(2))==-1)
            Area(xy(1)+1,xy(2)) = 1;
        end
    end
    
    %四周都是实体 00
    if (Area(xy(1)-1,xy(2))==1 && Area(xy(1)+1,xy(2))==1 && Area(xy(1),xy(2)-1)==1 && Area(xy(1),xy(2)+1)==1)
        Grade = szbq;
        return ;
    end
    %x方向有一个空缺10
    if ((Area(xy(1),xy(2)+1)==1 && Area(xy(1),xy(2)-1)==1 && Area(xy(1)-1,xy(2))==1 && Area(xy(1)+1,xy(2))==0)||...
            (Area(xy(1),xy(2)+1)==1 && Area(xy(1),xy(2)-1)==1 && Area(xy(1)-1,xy(2))==0 && Area(xy(1)+1,xy(2))==1))
        Grade = x1q;
        return ;
    end
    %y方向有一个空缺01
    if ((Area(xy(1),xy(2)+1)==1 && Area(xy(1),xy(2)-1)==0 && Area(xy(1)-1,xy(2))==1 && Area(xy(1)+1,xy(2))==1)||...
            (Area(xy(1),xy(2)+1)==0 && Area(xy(1),xy(2)-1)==1 && Area(xy(1)-1,xy(2))==1 && Area(xy(1)+1,xy(2))==1))
        Grade = y1q;
        return ;
    end
    %x方向有两个空缺，y没有空缺20
    if ((Area(xy(1),xy(2)+1)==1 && Area(xy(1),xy(2)-1)==1 && Area(xy(1)-1,xy(2))==0 && Area(xy(1)+1,xy(2))==0))
        Grade = x2q;
        return ;
    end
%     if ( Area(xy(1)-1,xy(2))==0 && Area(xy(1)+1,xy(2))==0)
%         Grade = x2q;
%         return ;
%     end
    %y方向和X方向各有一个空缺11
    if ((Area(xy(1),xy(2)+1)==1 && Area(xy(1),xy(2)-1)==0 && Area(xy(1)-1,xy(2))==1 && Area(xy(1)+1,xy(2))==0)||...
            (Area(xy(1),xy(2)+1)==1 && Area(xy(1),xy(2)-1)==0 && Area(xy(1)-1,xy(2))==0 && Area(xy(1)+1,xy(2))==1)||...
            (Area(xy(1),xy(2)+1)==0 && Area(xy(1),xy(2)-1)==1 && Area(xy(1)-1,xy(2))==1 && Area(xy(1)+1,xy(2))==0)||...
            (Area(xy(1),xy(2)+1)==0 && Area(xy(1),xy(2)-1)==1 && Area(xy(1)-1,xy(2))==0 && Area(xy(1)+1,xy(2))==1))
        Grade = y1qx1q;
        return ;
    end
    %y方向有两个空缺02
    if ((Area(xy(1),xy(2)+1)==0 && Area(xy(1),xy(2)-1)==0 && Area(xy(1)-1,xy(2))==1 && Area(xy(1)+1,xy(2))==1))
        Grade = y2q;
        return ;
    end
    %y方向有两个空缺和x方向有一个空缺12
    if ((Area(xy(1),xy(2)+1)==0 && Area(xy(1),xy(2)-1)==0 && Area(xy(1)-1,xy(2))==1 && Area(xy(1)+1,xy(2))==0)||...
            (Area(xy(1),xy(2)+1)==0 && Area(xy(1),xy(2)-1)==0 && Area(xy(1)-1,xy(2))==0 && Area(xy(1)+1,xy(2))==1))
        Grade = y2qx1q;
        return ;
    end
    %四周都是空缺 22
    if ((Area(xy(1),xy(2)+1)==0 && Area(xy(1),xy(2)-1)==0 && Area(xy(1)-1,xy(2))==0 && Area(xy(1)+1,xy(2))==0))
        Grade = szq;
        return ;
    end
    %x有两个空缺，y有1个空缺21
    if ((Area(xy(1),xy(2)+1)==0 && Area(xy(1),xy(2)-1)==1 && Area(xy(1)-1,xy(2))==0 && Area(xy(1)+1,xy(2))==0)||...
           (Area(xy(1),xy(2)+1)==1 && Area(xy(1),xy(2)-1)==0 && Area(xy(1)-1,xy(2))==0 && Area(xy(1)+1,xy(2))==0) )
        Grade = x2qy1q;
        return ;
    end
end
