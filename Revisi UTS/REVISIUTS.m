clear all; close all; clc;

dataRute = xlsread('Rute.xlsx');
dataWaktuTempuh = xlsread('WakuTempuh.xlsx');

pjgKromosom = 8;
jlhPopulasi = 10;
jlhGenerasi = 2000;
mutationRate = 0.3;
jlhTournament = 3;
finish = 8;
firstloop = 0;

individu = zeros(jlhPopulasi, pjgKromosom);




for x = 1 : jlhGenerasi
    
        
    %% buat Individu
    if firstloop == 0
        
        for i = 1 : jlhPopulasi
            individu(i,:) = randperm(8,pjgKromosom);
            for j = 1 : pjgKromosom
                if individu(i,j) == 1
                    temp = individu(i,j);
                    individu(i,j) = individu(i,1);
                    individu(i,1) = temp;
                end
            end
        end
    end

%      end
%     %% hitung fitness
    fitness = zeros(jlhPopulasi, 2);
    waktuTempuhX = zeros(jlhPopulasi, 1);
    waktuTempuh = ones(jlhPopulasi, 1);
    for i = 1 : jlhPopulasi
        for j = 1 : pjgKromosom
            
%              if dataRute(individu(i,j),individu(i,j+1))==0
%                  waktuTempuh(i,1) = 142;
%                  break;
%              end
            if individu(i,j) == 8
                
                break;
            end
                waktuTempuh(i,1) = waktuTempuh(i,1)* dataWaktuTempuh(individu(i,j),individu(i,j+1)) ;
                waktuTempuhX(i,1) = waktuTempuhX(i,1)+ dataWaktuTempuh(individu(i,j),individu(i,j+1)) ;


        end

        if waktuTempuh(i,1) == 0
            waktuTempuh(i,1) = 5*10^15;
        end
        fitness(i,1) = 1/waktuTempuh(i,1);
        fitness(i,2) = i;
    end
    % elitisme
    sortedfitness = sortrows(fitness,-1);
    elitisme = individu(sortedfitness([1 2],2),:);
    for i = 1 : jlhPopulasi
        sortedfitness(i,3) = i;
        fitness(sortedfitness(i,2),3) = i; 
    end
    
%

 % parent selection
    selectedParent = zeros(2,jlhTournament);
    parent = zeros(2,1);
    tempIndividu=zeros(jlhPopulasi,pjgKromosom);
    for i = 1:(jlhPopulasi)/2
        for j = 1:2
%             parent(j,1)=randi(jlhPopulasi);
            selectedParent(j,:) = (randperm(jlhPopulasi,jlhTournament));
            parent(j,1) = find(fitness(:,3) == min(fitness(selectedParent(j,:),3)));
            while parent(1,1) == parent(2,1)
                selectedParent(j,:) = (randperm(jlhPopulasi,jlhTournament));
                parent(j,1) = find(fitness(:,3) == min(fitness(selectedParent(j,:),3)));
            end
        end
        %%cross-over
        for j=pjgKromosom-3:pjgKromosom-1
            tempIndividu(i,j) = individu(parent(1,1),j);
            tempIndividu(i+((jlhPopulasi)/2),j) = individu(parent(2,1),j);
        end
        for j=1:pjgKromosom
            for k=1:pjgKromosom
                if k < 5 || k== 8 
                    if individu(i,j)==tempIndividu(i,k)||tempIndividu(i,j)==tempIndividu(i,k)
                        tempIndividu(i,j) = randi(8);
                        k=1;
                    else
                        tempIndividu(i,j)=individu(i,j);
                    end
                end
            end
            for k=1:pjgKromosom
                if k < 5 || k ==8
                    if individu(i+((jlhPopulasi)/2),j)==tempIndividu(i+((jlhPopulasi)/2),k)||tempIndividu(i+((jlhPopulasi)/2),j)==tempIndividu(i+((jlhPopulasi)/2),k)
                        tempIndividu(i+((jlhPopulasi)/2),j) = randi(8);
                        k=1;
                    else
                        tempIndividu(i+((jlhPopulasi)/2),j)=individu(i+((jlhPopulasi)/2),j);
                    end
                end
            end
        end

        for k=1:pjgKromosom-1
            if individu(i,8)==tempIndividu(i,k)||tempIndividu(i,8)==tempIndividu(i,k)
                tempIndividu(i,8) = randi(8);
                k=1;
            else
                tempIndividu(i,8)=individu(i,8);
            end
        end
        for k = 1:pjgKromosom-1
            if individu(i+((jlhPopulasi)/2),8)==tempIndividu(i+((jlhPopulasi)/2),k)||tempIndividu(i+((jlhPopulasi)/2),8)==tempIndividu(i+((jlhPopulasi)/2),k)
                tempIndividu(i+((jlhPopulasi)/2),8) = randi(8);
                k=1;
            else
                tempIndividu(i+((jlhPopulasi)/2),8)=individu(i+((jlhPopulasi)/2),8);
            end
        end

    end
    
     %mutation
        for i = 1 : jlhPopulasi-2
            for j = 1 : pjgKromosom
                for k = 1 : pjgKromosom
                    chance =  rand(1);
                    if chance > mutationRate
                        break;
                    end
                end
                chance = rand(1);
                if chance > mutationRate
                    temp = tempIndividu(i,j);
                    tempIndividu(i,j) = tempIndividu(i,k);
                    tempIndividu(i,k) = temp;
                    break;
                end
                
            end
        end
        
   
    for i = 1 : 2
        tempIndividu(i+jlhPopulasi-2,:) = elitisme(i,:);
    end
    individu=tempIndividu;
    
    for i = 1 : jlhPopulasi
        for j = 1 : pjgKromosom
            if individu(i,j) == 1
                temp = individu(i,j);
                individu(i,j) = individu(i,1);
                individu(i,1) = temp;
            end
        end
    end
    waktuTempuhOptimal = waktuTempuhX(fitness(:,3) == min(fitness(:,3)));
    peningkatanGA(x) =  sortedfitness(1,1);
    kromosomOptimal(1,:) = individu(fitness(:,3) == min(fitness(:,3)),:);
    
    firstloop = 1;

end 
