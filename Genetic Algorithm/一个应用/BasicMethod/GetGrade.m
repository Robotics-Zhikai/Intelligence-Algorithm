function Grade = GetGrade(Area,xy) %�õ�ĳһ����ķ���
    Area = [-1*ones(size(Area,1),1),Area];
    Area = [Area;-1*ones(1,size(Area,2))];
    Area = [Area,-1*ones(size(Area,1),1)];
    Area = [-1*ones(1,size(Area,2));Area];
    %����ñ�֤�������������ľ���������ֵΪ-1
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
    
    %���ܶ���ʵ�� 00
    if (Area(xy(1)-1,xy(2))==1 && Area(xy(1)+1,xy(2))==1 && Area(xy(1),xy(2)-1)==1 && Area(xy(1),xy(2)+1)==1)
        Grade = szbq;
        return ;
    end
    %x������һ����ȱ10
    if ((Area(xy(1),xy(2)+1)==1 && Area(xy(1),xy(2)-1)==1 && Area(xy(1)-1,xy(2))==1 && Area(xy(1)+1,xy(2))==0)||...
            (Area(xy(1),xy(2)+1)==1 && Area(xy(1),xy(2)-1)==1 && Area(xy(1)-1,xy(2))==0 && Area(xy(1)+1,xy(2))==1))
        Grade = x1q;
        return ;
    end
    %y������һ����ȱ01
    if ((Area(xy(1),xy(2)+1)==1 && Area(xy(1),xy(2)-1)==0 && Area(xy(1)-1,xy(2))==1 && Area(xy(1)+1,xy(2))==1)||...
            (Area(xy(1),xy(2)+1)==0 && Area(xy(1),xy(2)-1)==1 && Area(xy(1)-1,xy(2))==1 && Area(xy(1)+1,xy(2))==1))
        Grade = y1q;
        return ;
    end
    %x������������ȱ��yû�п�ȱ20
    if ((Area(xy(1),xy(2)+1)==1 && Area(xy(1),xy(2)-1)==1 && Area(xy(1)-1,xy(2))==0 && Area(xy(1)+1,xy(2))==0))
        Grade = x2q;
        return ;
    end
%     if ( Area(xy(1)-1,xy(2))==0 && Area(xy(1)+1,xy(2))==0)
%         Grade = x2q;
%         return ;
%     end
    %y�����X�������һ����ȱ11
    if ((Area(xy(1),xy(2)+1)==1 && Area(xy(1),xy(2)-1)==0 && Area(xy(1)-1,xy(2))==1 && Area(xy(1)+1,xy(2))==0)||...
            (Area(xy(1),xy(2)+1)==1 && Area(xy(1),xy(2)-1)==0 && Area(xy(1)-1,xy(2))==0 && Area(xy(1)+1,xy(2))==1)||...
            (Area(xy(1),xy(2)+1)==0 && Area(xy(1),xy(2)-1)==1 && Area(xy(1)-1,xy(2))==1 && Area(xy(1)+1,xy(2))==0)||...
            (Area(xy(1),xy(2)+1)==0 && Area(xy(1),xy(2)-1)==1 && Area(xy(1)-1,xy(2))==0 && Area(xy(1)+1,xy(2))==1))
        Grade = y1qx1q;
        return ;
    end
    %y������������ȱ02
    if ((Area(xy(1),xy(2)+1)==0 && Area(xy(1),xy(2)-1)==0 && Area(xy(1)-1,xy(2))==1 && Area(xy(1)+1,xy(2))==1))
        Grade = y2q;
        return ;
    end
    %y������������ȱ��x������һ����ȱ12
    if ((Area(xy(1),xy(2)+1)==0 && Area(xy(1),xy(2)-1)==0 && Area(xy(1)-1,xy(2))==1 && Area(xy(1)+1,xy(2))==0)||...
            (Area(xy(1),xy(2)+1)==0 && Area(xy(1),xy(2)-1)==0 && Area(xy(1)-1,xy(2))==0 && Area(xy(1)+1,xy(2))==1))
        Grade = y2qx1q;
        return ;
    end
    %���ܶ��ǿ�ȱ 22
    if ((Area(xy(1),xy(2)+1)==0 && Area(xy(1),xy(2)-1)==0 && Area(xy(1)-1,xy(2))==0 && Area(xy(1)+1,xy(2))==0))
        Grade = szq;
        return ;
    end
    %x��������ȱ��y��1����ȱ21
    if ((Area(xy(1),xy(2)+1)==0 && Area(xy(1),xy(2)-1)==1 && Area(xy(1)-1,xy(2))==0 && Area(xy(1)+1,xy(2))==0)||...
           (Area(xy(1),xy(2)+1)==1 && Area(xy(1),xy(2)-1)==0 && Area(xy(1)-1,xy(2))==0 && Area(xy(1)+1,xy(2))==0) )
        Grade = x2qy1q;
        return ;
    end
end
