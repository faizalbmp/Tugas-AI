clear all; close all; clc;

data = xlsread('Book1.xlsx');

pjgKromosom = 31;
jlhPopulasi = 10;
jlhGenerasi = 1000;
mutationRate = 0.03;
jlhTournament = 3;
kapasitasAwal = 100;

individu = zeros(jlhPopulasi, pjgKromosom);

totalJarak = zeros(jlhPopulasi, 1);

%%
for x = 1 : jlhGenerasi
    
    for i = 1 : jlhPopulasi
        individu(i,:) = randperm(31,pjgKromosom);
    end

    for i = 1:jlhPopulasi
        kapasitasSisa = 0;
        for j = 1:pjgKromosom
            if j==1
                kapasitasSisa = kapasitasAwal - data(individu(i,1),4);
                totalJarak(i,1) = round(sqrt(sum((data(1,[2 3]) - data(individu(i,1)+1,[2 3])).^2))); 
            else
                if kapasitasSisa < data(individu(i,j),4)
                    totalJarak(i,1) = totalJarak(i,1) + round(sqrt(sum((data(1,[2 3]) - data(individu(i,j-1)+1,[2 3])).^2)));
                    totalJarak(i,1) = totalJarak(i,1) + round(sqrt(sum((data(1,[2 3]) - data(individu(i,j)+1,[2 3])).^2)));
                    kapasitasSisa = kapasitasAwal - data(individu(i,j)+1,4);
                else
                    totalJarak(i,1) = totalJarak(i,1) + round(sqrt(sum((data(individu(i,j-1)+1,[2 3]) - data(individu(i,j)+1,[2 3])).^2)));
                    kapasitasSisa = kapasitasSisa - data(individu(i,j)+1,4);
                end
            end
        end
    end

%%

    % hitung fitness
    fitness = zeros(jlhPopulasi, 2);
    for i = 1:jlhPopulasi
        fitness(i,1) =  1/totalJarak(i,1);
        fitness(i,2) = i;
    end

%%

% elitisme
    sortedfitness = sortrows(fitness,-1);
    elitisme = individu(sortedfitness([1 2],2),:);
    for i = 1 : jlhPopulasi
        sortedfitness(i,3) = i;
        fitness(sortedfitness(i,2),3) = i; 
    end
%%

% parent selection

    selectedParent = zeros(2,jlhTournament);
    parent = zeros(2,1);
    tempIndividu = zeros(jlhPopulasi, pjgKromosom);
    for i = 1:(jlhPopulasi-2)/2
        for j = 1:2
            selectedParent(j,:) = (randperm(jlhPopulasi,jlhTournament));
            parent(j,1) = find(fitness(:,3) == min(fitness(selectedParent(j,:),3)));
            while parent(1,1) == parent(2,1)
                selectedParent(j,:) = (randperm(jlhPopulasi,jlhTournament));
                parent(j,1) = find(fitness(:,3) == min(fitness(selectedParent(j,:),3)));
            end
        end
        % cross-over
        for j = 1: round(pjgKromosom/2)
            tempIndividu(i,j) = individu(parent(1,1),j);
            tempIndividu(i+((jlhPopulasi-2)/2),j) = individu(parent(2,1),j);
        end
        for j = round(pjgKromosom/2) : pjgKromosom
            tempIndividu(i,j) = individu(parent(2,1),j);
            tempIndividu(i+((jlhPopulasi-2)/2),j) = individu(parent(1,1),j);
        end
        krom1 = 1;
        krom2 = 1;
        for j = round(pjgKromosom/2) : pjgKromosom
            for k = 1 : round(pjgKromosom/2)-1
                while tempIndividu(i,j) == tempIndividu(i,k)
                    if krom1 == round(pjgKromosom/2)-1
                        krom1 = 1;
                    end
                    tempIndividu(i,j) = individu(parent(2,1),krom1);
                    krom1 = krom1 + 1;

                end
                while tempIndividu(i+((jlhPopulasi-2)/2),j) == tempIndividu(i+((jlhPopulasi-2)/2),k)
                    if krom2 == round(pjgKromosom/2)-1
                        krom2 = 1;
                    end
                    tempIndividu(i+((jlhPopulasi-2)/2),j) = individu(parent(1,1),krom2);
                    krom2 = krom2 + 1;

                end
            end
        end
    end

 % mutation
    selectedKromosom = zeros(2);

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
    %%
    
    for i = 1 : 2
        tempIndividu(i+jlhPopulasi-2,:) = elitisme(i,:);
    end
    individu=tempIndividu;
    for i = 1:jlhPopulasi
        kapasitasSisa = 0;
        for j = 1:pjgKromosom
            if j==1
                kapasitasSisa = kapasitasAwal - data(individu(i,1),4);
                totalJarak(i,1) = round(sqrt(sum((data(1,[2 3]) - data(individu(i,1)+1,[2 3])).^2))); 
            else
                if kapasitasSisa < data(individu(i,j),4)
                    totalJarak(i,1) = totalJarak(i,1) + round(sqrt(sum((data(1,[2 3]) - data(individu(i,j-1)+1,[2 3])).^2)));
                    totalJarak(i,1) = totalJarak(i,1) + round(sqrt(sum((data(1,[2 3]) - data(individu(i,j)+1,[2 3])).^2)));
                    kapasitasSisa = kapasitasAwal - data(individu(i,j)+1,4);
                else
                    totalJarak(i,1) = totalJarak(i,1) + round(sqrt(sum((data(individu(i,j-1)+1,[2 3]) - data(individu(i,j)+1,[2 3])).^2)));
                    kapasitasSisa = kapasitasSisa - data(individu(i,j)+1,4);
                end
            end
        end
    end
    
    fitness = zeros(jlhPopulasi, 2);
    for i = 1:jlhPopulasi
        fitness(i,1) =  1/totalJarak(i,1);
        fitness(i,2) = i;
    end
    
    sortedfitness = sortrows(fitness,-1);
    elitisme = individu(sortedfitness([1 2],2),:);
    for i = 1 : jlhPopulasi
        sortedfitness(i,3) = i;
        fitness(sortedfitness(i,2),3) = i; 
    end
    
    jarakOptimal = totalJarak(find(fitness(:,3) == max(fitness(:,3))));
    peningkatanJarakOptimal(x) =  jarakOptimal;
    kromosomOptimal(1,:) = individu(find(fitness(:,3) == max(fitness(:,3))),:)

end
