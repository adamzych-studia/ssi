rand ('seed',123);

t=1:0.01:2;
probki = [t.*sin(t*2*pi)-0.1+0.2*rand(1, length(t)); t.*cos(t*2*pi)-0.1+0.2*rand(1,length(t))]';
clear t;
%plot (probki(:,1), probki(:,2), 'sk');
%xlabel ('x1');
%ylabel ('x2');

k = 3;              % liczba grup
iteracje = 10;      % liczba iteracji

M = size(probki,1); % liczba próbek
m = randperm(M, k);  % wybór losowo m różnych próbek
V = probki(m, :);   % środki grup

% Tablica przynależności próbek
przynaleznosc = zeros(M,1);

% Kolory dla grup
kolory = lines(k);

figure;
hold on;
axis equal;
title('K-średnie – animacja iteracji');
xlabel('X1');
ylabel('X2');

for it = 1:iteracje   % pętla wykonywana przez zadaną liczbę iteracji
    
    % Krok 1: przypisanie próbek do najbliższego środka, pętla po
    % wszystkich M próbkach
    for s = 1:M
        %d = sum((V - probki(s,:)).^2, 2);  % wyliczenie odległości euklidesowej
        d = abs(V(:,1) - probki(s,1));  % wyliczenie odległości manhattan
        [~, idx] = min(d);
        przynaleznosc(s) = idx;
    end
    
    cla; % czyścimy wykres
    
    % Rysowanie punktów w kolorach grup, pętla po wszystkich grupach
    for j = 1:k
        scatter(probki(przynaleznosc==j,1), probki(przynaleznosc==j,2), ...
                25, kolory(j,:),'s');
    end
    
    % Rysowanie środków grup
    scatter(V(:,1), V(:,2), 120, kolory, 's', 'filled');
    
    title(['Iteracja: ', num2str(it)]);
    drawnow;    % aktualizacja animacji
    pause(1);   % opóźnienie 1s między kolejnymi iteracjami
    
    if it == 4           % zapis wyników przy 4 iteracji
        saveas(gcf, 'k_srednie_iteracja_4.png');
        centra_it4 = V;
        przyn_it4 = przynaleznosc;
        save('wyniki_iteracja4.mat','centra_it4','przyn_it4');
    end
    
    if it == 10  % zapis wyników przy 10 iteracji
        saveas(gcf, 'k_srednie_iteracja_10.png');
        centra_it10 = V;
        przyn_it10 = przynaleznosc;
        save('wyniki_iteracja10.mat','centra_it10','przyn_it10');
    end
    %  Krok 2: aktualizacja środków
    for j = 1:k
        punkty = probki(przynaleznosc == j, :);
        if ~isempty(punkty)
            V(j,:) = mean(punkty, 1);
        end
    end
end
