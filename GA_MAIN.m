clc
tic
clear
close all

jobs=[
399264 172830 5 5 3
427130 172829 5 5 3
494829 172832 5 5 3
495154 172831 5 5 3
506793 35968 11 5 3
522378 11872 32 1 4
559483 59965 4 1 4
566129 28826 1 5 3
567314 8071 8 1 4
574294 64384 7 1 3
576100 19000 1 1 3
577685 118561 5 1 3
578846 24861 1 1 3
581034 10979 1 1 4
581434 16674 11 1 3
582841 8385 32 1 2
583532 16793 11 1 3
584165 3634 24 5 3
584785 1229 2 5 3
584801 2207 16 1 3
584826 40 8 1 3
584832 311 8 1 3
584838 1228 8 5 3
584875 47 16 1 3
584919 213 16 1 3
584928 40 16 1 3
585786 51164 1 1 3
586496 1970 2 1 3
588559 58046 4 1 3
589428 28 2 5 2
589449 275 1 1 3
589503 3708 2 5 2
589535 3625 1 1 2
590405 54 32 1 3
590414 45 32 1 3
590419 292 32 1 3
590427 42 32 5 3
590434 155 32 1 3
590439 66 32 1 3
590470 64 1 5 2
590531 34 1 1 2
590978 252 2 1 1
591120 11298 2 1 4
591442 16440 1 1 3
591612 293 2 1 1
593508 257 2 1 1
595008 216 2 1 1
595228 32 2 1 1
595239 24866 1 1 4
595276 34 4 1 1
595584 26228 1 1 3
595641 213 2 1 1
596042 214 2 1 1
596561 212 2 1 1
597048 276 1 1 3
597139 144 4 1 1
597147 106 8 1 1
597497 314 1 1 1
597928 925 16 1 3
597955 689 32 1 3
598080 203 8 1 1
598354 274 4 1 1
598608 412 2 1 1
598823 691 1 1 1
599263 1716 8 1 1
600209 16792 11 1 3
613917 95 24 1 3
614987 336 16 1 3
615362 277 1 1 3
617472 257 16 1 3
617486 523 32 1 3
617729 182 100 1 3
617737 216 65 1 3
617748 263 64 1 3
617752 334 90 1 3];
d=max(jobs(:,1));
[mm nn]=size(jobs);
total_jobs=mm;
result=zeros(mm+10,nn);
d=mm;

%fragment jobs for co-allocation
kkk=1;
for i=1:mm
jobs(i,nn+1)=0;
    if jobs(i,3)>32
    jobs(i,nn+1)=kkk;
    jobs(i,3)=fix(jobs(i,3)/4);
    jobs(d+1,:)=jobs(i,:);
    jobs(d+2,:)=jobs(i,:);
    jobs(d+3,:)=jobs(i,:);
    d=d+3;
    kkk=kkk+1;
end
end

[mm nn]=size(jobs);
total_jobs=mm;
result=zeros(mm+10,8);

%end
disp('Jobs fetched successfully');
max_res=32;

Cluster=5;
j=1;
for i=1:Cluster
    if mod(i,4)==0
        j=j+1;
    end
        Clust(i,1)=i; %Cluster number
        Clust(i,2)=max_res; %resources
        %Clust(i,3)=randi([4,5],1,1); %speed
       Clust(i,3)=i;  
%Clust(i,4)=j;
end
Clust(:,2)=[32 32 32 16 16];
disp('Cluster no., Resources, Speed');
Clust


%Clust(i,3)=[2 2 3 1 2];

speed=Clust(:,3);
disp('Clusters initialized successfully');

        
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
Clust1=randi([2 Cluster],1,1);
time(1,1)=0;
for jj=1:Cluster
time(jj,2)=0;
end
ij=1;
while ij<=total_jobs
agg_jobs=0;
while Clust(Clust1,2)>agg_jobs && ij<=total_jobs
max_res=Clust(Clust1,2);
agg_jobs=agg_jobs+jobs(sol(ij),3);    
if agg_jobs<=Clust(Clust1,2)

    result(k,4)=max_res-agg_jobs;
result(k,2)=jobs(sol(ij),2);
result(k,1)=sol(ij);
result(k,3)=Clust1;
result(k,5)=jobs(sol(ij),3);

%time(Clust1,1)=time(Clust1,1)+max(result(k,2),result(k+1,2))/speed(Clust1);
%time(Clust1,2)=time(Clust1,1)-max(result(k,2),result(k+1,2))/speed(Clust1);

ij=ij+1;
k=k+1;
end    
end
    
    Clust2=Clust1;
Clust1=randi([1 Cluster],1,1);
while Clust2==Clust1
Clust1=randi([1 Cluster],1,1);
end
end
end





clc
disp('Best schedule')


result=abs(result);
disp('Flowtime analysis')

time
Makespan=fix(max(time(:,1)))
mean_waiting_time=fix(mean(time(:,2)))
mean_schedule_lenght=fix(mean(time(:,1)))
executiontime=toc
result(:,5)
%c1=0
%c2=0
%c3=0
%c4=0
%c5=0
c1(1:Cluster)=0;
j=1;

while(j<=((total_jobs)))
    for kk=1:Cluster
        
               if(result(j,3)==kk) && (result(j+1,3)==kk) && (result(j+2,3)==kk) && (result(j+3,3)==kk)&& (result(j+4,3)==kk) && (result(j+5,3)==kk) && (result(j+6,3)==kk) 
        result(j,6)=c1(kk);
        result(j,7)=c1(kk)+result(j,2)/speed(result(j,3))
        result(j+1,6)=c1(kk);
        result(j+1,7)=c1(kk)+result(j+1,2)/speed(result(j,3))
        result(j+2,6)=c1(kk);
        result(j+2,7)=c1(kk)+result(j+2,2)/speed(result(j,3))
        result(j+3,6)=c1(kk);
        result(j+3,7)=c1(kk)+result(j+3,2)/speed(result(j,3))
        result(j+4,6)=c1(kk);
        result(j+4,7)=c1(kk)+result(j+4,2)/speed(result(j,3))
        result(j+5,6)=c1(kk);
        result(j+5,7)=c1(kk)+result(j+5,2)/speed(result(j,3))
        result(j+6,6)=c1(kk);
        result(j+6,7)=c1(kk)+result(j+6,2)/speed(result(j,3))
        c1(kk)=c1(kk)+max(result(j,2),max(result(j+1,2),result(j+2,2)))/speed(result(j,3));
        
        j=j+7;
        
               elseif(result(j,3)==kk) && (result(j+1,3)==kk) && (result(j+2,3)==kk) && (result(j+3,3)==kk)&& (result(j+4,3)==kk) && (result(j+5,3)==kk) 
        result(j,6)=c1(kk);
        result(j,7)=c1(kk)+result(j,2)/speed(result(j,3))
        result(j+1,6)=c1(kk);
        result(j+1,7)=c1(kk)+result(j+1,2)/speed(result(j,3))
        result(j+2,6)=c1(kk);
        result(j+2,7)=c1(kk)+result(j+2,2)/speed(result(j,3))
        result(j+3,6)=c1(kk);
        result(j+3,7)=c1(kk)+result(j+3,2)/speed(result(j,3))
        result(j+4,6)=c1(kk);
        result(j+4,7)=c1(kk)+result(j+4,2)/speed(result(j,3))
        result(j+5,6)=c1(kk);
        result(j+5,7)=c1(kk)+result(j+5,2)/speed(result(j,3))
        c1(kk)=c1(kk)+max(result(j,2),max(result(j+1,2),result(j+2,2)))/speed(result(j,3));
        
        j=j+6;
        elseif(result(j,3)==kk) && (result(j+1,3)==kk) && (result(j+2,3)==kk) && (result(j+3,3)==kk)&& (result(j+4,3)==kk) 
        result(j,6)=c1(kk);
        result(j,7)=c1(kk)+result(j,2)/speed(result(j,3))
        result(j+1,6)=c1(kk);
        result(j+1,7)=c1(kk)+result(j+1,2)/speed(result(j,3))
        result(j+2,6)=c1(kk);
        result(j+2,7)=c1(kk)+result(j+2,2)/speed(result(j,3))
        result(j+3,6)=c1(kk);
        result(j+3,7)=c1(kk)+result(j+3,2)/speed(result(j,3))
        result(j+4,6)=c1(kk);
        result(j+4,7)=c1(kk)+result(j+4,2)/speed(result(j,3))

        c1(kk)=c1(kk)+max(result(j,2),max(result(j+1,2),result(j+2,2)))/speed(result(j,3));
        
        j=j+5;

        elseif(result(j,3)==kk) && (result(j+1,3)==kk) && (result(j+2,3)==kk) && (result(j+3,3)==kk)
        result(j,6)=c1(kk);
        result(j,7)=c1(kk)+result(j,2)/speed(result(j,3))
        result(j+1,6)=c1(kk);
        result(j+1,7)=c1(kk)+result(j+1,2)/speed(result(j,3))
        result(j+2,6)=c1(kk);
        result(j+2,7)=c1(kk)+result(j+2,2)/speed(result(j,3))
        result(j+3,6)=c1(kk);
        result(j+3,7)=c1(kk)+result(j+3,2)/speed(result(j,3))
        c1(kk)=c1(kk)+max(result(j,2),max(result(j+1,2),result(j+2,2)))/speed(result(j,3));
        
        j=j+4;
    elseif(result(j,3)==kk) && (result(j+1,3)==kk) && (result(j+2,3)==kk)
        result(j,6)=c1(kk);
        result(j,7)=c1(kk)+result(j,2)/speed(result(j,3))
        result(j+1,6)=c1(kk);
        result(j+1,7)=c1(kk)+result(j+1,2)/speed(result(j,3))
        result(j+2,6)=c1(kk);
        result(j+2,7)=c1(kk)+result(j+2,2)/speed(result(j,3))
        c1(kk)=c1(kk)+max(result(j,2),max(result(j+1,2),result(j+2,2)))/speed(result(j,3));
        
        j=j+3;
    elseif(result(j,3)==kk) && (result(j+1,3)==kk)
        result(j,6)=c1(kk);
        result(j,7)=c1(kk)+result(j,2)/speed(result(j,3))
        result(j+1,6)=c1(kk);
        result(j+1,7)=c1(kk)+result(j+1,2)/speed(result(j,3))
        c1(kk)=c1(kk)+max(result(j,2),result(j+1,2))/speed(result(j,3));
        
        j=j+2;
    elseif(result(j,3)==kk)
        result(j,6)=c1(kk);
        result(j,7)=c1(kk)+result(j,2)/speed(result(j,3));
        c1(kk)=c1(kk)+result(j,2)/speed(result(j,3));
        
        j=j+1;
    end    
    end 
   
end 
clc
for j=1:(total_jobs)
final1(j,:)=result(j,:);
final1(j,8)=jobs(j,6);
end

disp('Job id,  Burst time, Cluster id, Rem res, Rqrd res, Waiting time, Execution time');
fix(final1)

disp('Flowtime analysis')

time
Makespan=fix(max(result(:,7)))
mean_waiting_time=fix(mean(result(:,6)))
mean_schedule_lenght=fix(mean(result(:,7)))
Utilization=mean_schedule_lenght/Makespan
executiontime=toc

