clear all; close all; clc;

data = xlsread('Train.xls');

akurasi = 0;
alloutput=zeros(size(data,1),1);
for i=1 : size(data,1)

    %% x4 fuzzification
    x4=data(i,5);
        %% lowest
        c=-1.95;
        d=-1.6;
        if x4 <=c
            x4Lowest = 1;
        elseif x4 >c && x4 < d
            x4Lowest = -(x4-d)/(d-c);
        elseif x4 >= d
            x4Lowest = 0;
        end
        
        %% low
        a=-1.8;
        b=-1.5;
        c=-1;
        if x4 == b
            x4Low = 1;
        elseif x4<b && x4>a
            x4Low = (x4-a)/(b-a);
        elseif x4>b && x4<c
            x4Low = -(x4-c)/(c-b);
        elseif x4<=a || x4>= c
            x4Low = 0;
        end
        
        %%high
        a=-1.04;
        b=-0.88;
        c=-0.43;
         if x4 ==b
            x4High = 1;
        elseif x4<b && x4>a
            x4High = (x4-a)/(b-a);
        elseif x4>b && x4<c
            x4High = -(x4-c)/(c-b);
        elseif x4<=a || x4>= c
            x4High= 0;
         end
        
         %%highest
         a=-0.6;
         b=-0.26;
         if x4<=a
             x4Highest = 0;
         elseif x4>a && x4<b
             x4Highest = (x4-a)/(b-a);
         elseif x4>=b
             x4Highest = 1;
         end
    %% x7 fuzzificcation
    x7=data(i,8);
        %%low
        a=0;
        b=0;
        c=0.8;
        if x7 <=b
            x7Low = 1;
        elseif x7>b && x7<c
            x7Low = -(x7-c)/(c-b);
        elseif  x7>= c
            x7Low= 0;
        end
        
        %%mid
        a = 0.2;
        b = 1.34;
        c = 1.66;
        if x7 ==b
            x7Mid = 1;
        elseif x7<b && x7>a
            x7Mid = (x7-a)/(b-a);
        elseif x7>b && x7<c
            x7Mid = -(x7-c)/(c-b);
        elseif x7<=a || x7>= c
            x7Mid= 0;
        end
        
        %%high
        a = 1.05;
        b = 2;
        c = 2;
        if x7 >=b
            x7High = 1;
        elseif x7<b && x7>a
            x7High = (x7-a)/(b-a);
        elseif x7<=a
            x7High= 0;
        end
        
     Low = zeros(1,15);
     High = zeros(1,15);
    LowCol = 1;
    HighCol = 1;
    %%rule
    if x4Lowest ~= 0 && x7Low ~= 0
        High(1,HighCol) = min([x4Lowest,x7Low]);
        HighCol= HighCol +1;
    end
    if x4Lowest ~= 0 && x7Mid ~= 0
        High(1,HighCol) = min([x4Lowest,x7Mid]);
        HighCol= HighCol +1;
    end
    if x4Lowest ~= 0 && x7High ~= 0
        High(1,HighCol) = min([x4Lowest,x7High]);
        HighCol= HighCol +1;
    end
    if x4Low ~= 0 && x7Low ~= 0
        Low(1,LowCol) = min([x4Low,x7Low]);
        LowCol=LowCol+1;
    end
    if x4Low ~= 0 && x7Mid ~= 0
        High(1,HighCol) = min([x4Low,x7Mid]);
        HighCol=HighCol+1;
    end
    if x4Low ~= 0 && x7High ~= 0
        Low(1,LowCol) = min([x4Low,x7High]);
        LowCol=LowCol+1;
    end
    if x4High ~= 0 && x7Low ~= 0
        Low(1,LowCol) = min([x4High,x7Low]);
        LowCol=LowCol+1;
    end
    if x4High ~= 0 && x7Mid ~= 0
        High(1,HighCol) = min([x4High,x7Mid]);
        HighCol= HighCol +1;
    end
    if x4High ~= 0 && x7High ~= 0
        Low(1,LowCol) = min([x4High,x7High]);
        LowCol=LowCol+1;
    end
    if x4Highest ~= 0 && x7Low ~= 0
        Low(1,LowCol) = min([x4Highest,x7Low]);
        LowCol=LowCol+1;
    end
    if x4Highest ~= 0 && x7Mid ~= 0
        Low(1,LowCol) = min([x4Highest,x7Mid]);
        LowCol=LowCol+1;
    end
    if x4Highest ~= 0 && x7High ~= 0
        Low(1,LowCol) = min([x4Highest,x7High]);
        LowCol=LowCol+1;
    end
    if LowCol == 1
        output0 = 0;
    else
        for j=1 : LowCol-1
            output0 = max(Low(1,j));
        end
    end
    if HighCol ==1
        output1=0;
    else
        for j=1 :HighCol-1
            output1 = max(High(1,j));
        end
    end
   %% deffuzification
   if output0 ~= 0 && output1 ~= 0
       output = output0*1+output1*2/(output1+output0);
       output = round(output);
   elseif output0 ~= 0
       output = output0*1/output0;
       output = round(output);
   else
       output = output1*2/output1;
       output = round(output);
   end
   
   %% akurasi
   alloutput(i,1)=output-1;
   if output-1 == data(i,12)
       akurasi = akurasi + 1;
   end
   

end
hasil = real(akurasi/size(data,1));
