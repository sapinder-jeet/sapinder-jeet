clc
tic
clear
close all
 total_jobs=120;
for i=1:total_jobs
    jobs(i,1)=i; %id
    jobs(i,2)=randi([200,300],1,1); %burst
    jobs(i,3)=randi([1,3],1,1); %resources
    jobs(i,4)=0; %wait
    jobs(i,5)=0; %status
end

disp('Jobs fetched successfully');

Cluster=5;
j=1;
for i=1:Cluster
    if mod(i,4)==0
        j=j+1;
    end
        ser(i,1)=i; %server number
    ser(i,2)=5; %resources
        ser(i,3)=randi([1,3],1,1);; %speed
%ser(i,4)=j;
end
disp('Server no., Resources, Speed, Cluster no.');
ser


%ser(i,3)=[2 2 3 1 2];

max_res=5;
speed=ser(:,3);
disp('Servers initialized successfully');
% initial parameter

% 
dim =2;

% 
chromosome = 30;

%
Itermax = 10;

% 
Solution = Initial(dim,chromosome);

% 
Mr = 0.05;
% 
Cr = 0.4;
iter = 0;
Vrange = [-2,2
          -2,2];

while iter < Itermax
sol= random_sol(total_jobs, total_jobs);

    iter = iter +1;
   [row,col] = size(Solution);
    
    
    % 
    Snew = MutationOperation(Solution,Mr);
    
    % 
    SolutionC = CrossoverOperation(Solution,Snew,Cr);
    
    SolutionC = CheckRange(SolutionC,Vrange);
    % 
    [SolutionNew,fitbest,best] = SelectOperation(SolutionC,Solution);
    fitness(iter) = fitbest;
    Solution = SolutionNew;
    tmpv=[best,fitbest];
   

dd=1;
k=1;
ser1=randi([2 5],1,1);
time(1,1)=0;
for jj=1:Cluster
time(jj,2)=0;
end
for i=1:total_jobs-2
   if jobs(sol(i),3)+jobs(sol(i+1),3)+jobs(sol(i+2),3)<=max_res
result(k,4)=max_res-jobs(sol(i),3)
result(k+1,4)=max_res-(jobs(sol(i),3)+jobs(sol(i+1),3))
result(k+2,4)=max_res-(jobs(sol(i),3)+jobs(sol(i+1),3)++jobs(sol(i+2),3))
    
result(k,2)=jobs(sol(i),2);
result(k,1)=sol(i);
result(k,3)=ser1;
result(k+1,2)=jobs(sol(i+1),2);
result(k+1,1)=sol(i+1);
result(k+1,3)=ser1;
result(k+2,2)=jobs(sol(i+2),2);
result(k+2,1)=sol(i+2);
result(k+2,3)=ser1;

result(k,5)=jobs(sol(i),3);
result(k+1,5)=jobs(sol(i+1),3);
result(k+2,5)=jobs(sol(i+2),3);

time(ser1,1)=time(ser1,1)+max(result(k,2),result(k+1,2))/speed(ser1);
time(ser1,2)=time(ser1,1)-max(result(k,2),result(k+1,2))/speed(ser1);

i=i+2;
k=k+3;
    elseif jobs(sol(i),3)+jobs(sol(i+1),3)<=max_res
result(k,4)=max_res-jobs(sol(i),3);
result(k+1,4)=max_res-(jobs(sol(i),3)+jobs(sol(i+1),3));
    
result(k,2)=jobs(sol(i),2);
result(k,1)=sol(i);
result(k,3)=ser1;
result(k+1,2)=jobs(sol(i+1),2);
result(k+1,1)=sol(i+1);
result(k+1,3)=ser1;

result(k,5)=jobs(sol(i),3);
result(k+1,5)=jobs(sol(i+1),3);

time(ser1,1)=time(ser1,1)+max(result(k,2),result(k+1,2))/speed(ser1);
time(ser1,2)=time(ser1,1)-max(result(k,2),result(k+1,2))/speed(ser1);

i=i+1;
k=k+2;


    else
        result(k,4)=max_res-jobs(sol(i),3);
result(k,2)=jobs(sol(i),2);
result(k,1)=sol(i);
result(k,3)=ser1;

time(ser1,1)=time(ser1,1)+result(k,2);
time(ser1,2)=time(ser1,1)-result(k,2);;
k=k+1;
result(k,5)=jobs(sol(i),3);
result(k+1,5)=jobs(sol(i+1),3);

    end
    ser2=ser1;
ser1=randi([1 5],1,1);
while ser2==ser1
ser1=randi([1 5],1,1);
end
end
end
clc
disp('Best schedule')


result
disp('Flowtime analysis')

time
Makespan=fix(max(time(:,1)))
mean_waiting_time=fix(mean(time(:,2)))
mean_schedule_lenght=fix(mean(time(:,1)))
executiontime=toc
result(:,5)
c1=0
c2=0
c3=0
c4=0
c5=0
j=1;
while(j<=((total_jobs)-3))
    if(result(j,3)==1) && (result(j+1,3)==1) && (result(j+2,3)==1) && (result(j+3,3)==1)
        result(j,6)=c1;
        result(j,7)=c1+result(j,2)
        result(j+1,6)=c1;
        result(j+1,7)=c1+result(j+1,2)
        result(j+2,6)=c1;
        result(j+2,7)=c1+result(j+2,2)
        result(j+3,6)=c1;
        result(j+3,7)=c1+result(j+3,2)
     
        c1=c1+max(result(j,2),max(result(j+1,2),result(j+2,2)));
j=j+4;
    elseif(result(j,3)==1) && (result(j+1,3)==1) && (result(j+2,3)==1)
        result(j,6)=c1;
        result(j,7)=c1+result(j,2)
        result(j+1,6)=c1;
        result(j+1,7)=c1+result(j+1,2)
        result(j+2,6)=c1;
        result(j+2,7)=c1+result(j+2,2)
        c1=c1+max(result(j,2),max(result(j+1,2),result(j+2,2)));
j=j+3;
    elseif(result(j,3)==1) && (result(j+1,3)==1)
        result(j,6)=c1;
        result(j,7)=c1+result(j,2)
        result(j+1,6)=c1;
        result(j+1,7)=c1+result(j+1,2)
        c1=c1+max(result(j,2),result(j+1,2));
j=j+2;
    elseif(result(j,3)==1)
        result(j,6)=c1;
        result(j,7)=c1+result(j,2);
        c1=c1+result(j,2);
        
j=j+1;
    end    
 
    
    if(result(j,3)==2) && (result(j+1,3)==2) && (result(j+2,3)==2) && (result(j+3,3)==2)
        result(j,6)=c2;
        result(j,7)=c2+result(j,2)
        result(j+1,6)=c2;
        result(j+1,7)=c2+result(j+1,2)
        result(j+2,6)=c2;
        result(j+2,7)=c2+result(j+2,2)
        result(j+3,6)=c2;
        result(j+3,7)=c2+result(j+3,2)
     
        c2=c2+max(result(j,2),max(result(j+1,2),result(j+2,2)));
j=j+4;
    elseif(result(j,3)==2) && (result(j+1,3)==2) && (result(j+2,3)==2)
        result(j,6)=c2;
        result(j,7)=c2+result(j,2)
        result(j+1,6)=c2;
        result(j+1,7)=c2+result(j+1,2)
        result(j+2,6)=c2;
        result(j+2,7)=c2+result(j+2,2)
        c2=c2+max(result(j,2),max(result(j+1,2),result(j+2,2)));
j=j+3;
    elseif(result(j,3)==2) && (result(j+1,3)==2)
        result(j,6)=c1;
        result(j,7)=c1+result(j,2)
        result(j+1,6)=c1;
        result(j+1,7)=c1+result(j+1,2)
        c2=c2+max(result(j,2),result(j+1,2));
j=j+2;
    elseif(result(j,3)==2)
        result(j,6)=c1;
        result(j,7)=c1+result(j,2);
        c2=c2+result(j,2);
        
j=j+1;
    end 
    
    if(result(j,3)==3) && (result(j+1,3)==3) && (result(j+2,3)==3) && (result(j+3,3)==3)
        result(j,6)=c3;
        result(j,7)=c3+result(j,2)
        result(j+1,6)=c3;
        result(j+1,7)=c3+result(j+1,2)
        result(j+2,6)=c3;
        result(j+2,7)=c3+result(j+2,2)
        result(j+3,6)=c3;
        result(j+3,7)=c3+result(j+3,2)
     
        c3=c3+max(result(j,2),max(result(j+1,2),result(j+2,2)));
j=j+4;
    elseif(result(j,3)==3) && (result(j+1,3)==3) && (result(j+2,3)==3)
        result(j,6)=c3;
        result(j,7)=c3+result(j,2)
        result(j+1,6)=c3;
        result(j+1,7)=c3+result(j+1,2)
        result(j+2,6)=c3;
        result(j+2,7)=c3+result(j+2,2)
        c3=c3+max(result(j,2),max(result(j+1,2),result(j+2,2)));
j=j+3;
    elseif(result(j,3)==3) && (result(j+1,3)==3)
        result(j,6)=c3;
        result(j,7)=c3+result(j,2)
        result(j+1,6)=c3;
        result(j+1,7)=c3+result(j+1,2)
        c3=c3+max(result(j,2),result(j+1,2));
j=j+2;
    elseif(result(j,3)==3)
        result(j,6)=c3;
        result(j,7)=c3+result(j,2);
        c3=c3+result(j,2);
        
j=j+1;
    end 
    
    if(result(j,3)==4) && (result(j+1,3)==4) && (result(j+2,3)==4) && (result(j+3,3)==4)
        result(j,6)=c4;
        result(j,7)=c4+result(j,2)
        result(j+1,6)=c4;
        result(j+1,7)=c4+result(j+1,2)
        result(j+2,6)=c4;
        result(j+2,7)=c4+result(j+2,2)
        result(j+3,6)=c4;
        result(j+3,7)=c4+result(j+3,2)
     
        c1=c1+max(result(j,2),max(result(j+1,2),result(j+2,2)));
j=j+4;
    elseif(result(j,3)==4) && (result(j+1,3)==4) && (result(j+2,3)==4)
        result(j,6)=c4;
        result(j,7)=c4+result(j,2)
        result(j+1,6)=c4;
        result(j+1,7)=c4+result(j+1,2)
        result(j+2,6)=c4;
        result(j+2,7)=c4+result(j+2,2)
        c4=c4+max(result(j,2),max(result(j+1,2),result(j+2,2)));
j=j+3;
    elseif(result(j,3)==4) && (result(j+1,3)==4)
        result(j,6)=c4;
        result(j,7)=c4+result(j,2)
        result(j+1,6)=c4;
        result(j+1,7)=c4+result(j+1,2)
        c4=c4+max(result(j,2),result(j+1,2));
j=j+2;
    elseif(result(j,3)==4)
        result(j,6)=c1;
        result(j,7)=c1+result(j,2);
        c4=c4+result(j,2);
        
j=j+1;
    end 
    
    if(result(j,3)==5) && (result(j+1,3)==5) && (result(j+2,3)==5) && (result(j+3,3)==5)
        result(j,6)=c5;
        result(j,7)=c5+result(j,2)
        result(j+1,6)=c5;
        result(j+1,7)=c5+result(j+1,2)
        result(j+2,6)=c5;
        result(j+2,7)=c5+result(j+2,2)
        result(j+3,6)=c5;
        result(j+3,7)=c5+result(j+3,2)
     
        c5=c5+max(result(j,2),max(result(j+1,2),result(j+2,2)));
j=j+4;
    elseif(result(j,3)==5) && (result(j+1,3)==5) && (result(j+2,3)==5)
        result(j,6)=c5;
        result(j,7)=c5+result(j,2)
        result(j+1,6)=c5;
        result(j+1,7)=c5+result(j+1,2)
        result(j+2,6)=c5;
        result(j+2,7)=c5+result(j+2,2)
        c5=c5+max(result(j,2),max(result(j+1,2),result(j+2,2)));
j=j+3;
    elseif(result(j,3)==5) && (result(j+1,3)==5)
        result(j,6)=c5;
        result(j,7)=c5+result(j,2)
        result(j+1,6)=c5;
        result(j+1,7)=c5+result(j+1,2)
        c5=c5+max(result(j,2),result(j+1,2));
j=j+2;
    elseif(result(j,3)==5)
        result(j,6)=c5;
        result(j,7)=c5+result(j,2);
        c5=c5+result(j,2);
        
j=j+1;
    end 
   
end 
clc
for j=1:(total_jobs)-3
final1(j,:)=result(j,:);
end
final1