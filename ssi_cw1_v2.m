classdef ssi_cw1_v2 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                      matlab.ui.Figure
        iteracjaLabel                 matlab.ui.control.Label
        iteracjaLabel_2               matlab.ui.control.Label
        UITableIter10                 matlab.ui.control.Table
        UITableIter4                  matlab.ui.control.Table
        STARTButton                   matlab.ui.control.Button
        LiczbaiteracjiEditField       matlab.ui.control.NumericEditField
        LiczbaiteracjiEditFieldLabel  matlab.ui.control.Label
        LiczbagrupEditField           matlab.ui.control.NumericEditField
        LiczbagrupEditFieldLabel      matlab.ui.control.Label
        MetrykaButtonGroup            matlab.ui.container.ButtonGroup
        CzebyszewButton               matlab.ui.control.RadioButton
        ManhattanButton               matlab.ui.control.RadioButton
        EuklidesButton                matlab.ui.control.RadioButton
        UIAxes                        matlab.ui.control.UIAxes
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button down function: MetrykaButtonGroup
        function MetrykaButtonGroupButtonDown(app, event)
            
        end

        % Button pushed function: STARTButton
        function STARTButtonPushed(app, event)
rand ('seed',123);
t=1:0.01:2;
probki = [t.*sin(t*2*pi)-0.1+0.2*rand(1, length(t)); t.*cos(t*2*pi)-0.1+0.2*rand(1,length(t))]';
clear t;
%plot (probki(:,1), probki(:,2), 'sk');
%xlabel ('x1');
%ylabel ('x2');

k = app.LiczbagrupEditField.Value;              % liczba grup
iteracje = app.LiczbaiteracjiEditField.Value;      % liczba iteracji

M = size(probki,1); % liczba próbek
m = randperm(M, k);  % wybór losowo m różnych próbek
V = probki(m, :);   % środki grup
% Tablica przynależności próbek
przynaleznosc = zeros(M,1);

% Kolory dla grup
kolory = lines(k);

ax = app.UIAxes;
hold(ax, 'on');
axis(ax, 'equal');
% title('K-średnie – animacja iteracji');
% xlabel('X1');
% ylabel('X2');

for it = 1:iteracje   % pętla wykonywana przez zadaną liczbę iteracji
    
    % Krok 1: przypisanie próbek do najbliższego środka, pętla po
    % wszystkich M próbkach
    for s = 1:M
        selected = app.MetrykaButtonGroup.SelectedObject;

        % Odległość euklidesowa
        if selected == app.EuklidesButton
        d = sqrt(sum((V - probki(s,:)).^2, 2));

        % Odległość manhattan
        elseif selected == app.ManhattanButton
        d = abs(V(:,1) - probki(s,1));

        % Odległość Czebyszewa
        elseif selected == app.CzebyszewButton
        d = max(abs(V - probki(s,:)), [], 2);
        end
        [~, idx] = min(d);
        przynaleznosc(s) = idx;
    end
    
    cla(app.UIAxes); % czyścimy wykres
    
    % Rysowanie punktów w kolorach grup, pętla po wszystkich grupach
    for j = 1:k
        scatter(ax, probki(przynaleznosc==j,1), probki(przynaleznosc==j,2), ...
                25, kolory(j,:),'s');
    end
    
    % Rysowanie środków grup
    scatter(ax,V(:,1), V(:,2), 120, kolory, 's', 'filled');
    
    subtitle(ax, ['Iteracja: ', num2str(it)]);
    drawnow;    % aktualizacja animacji
    pause(1);   % opóźnienie 1s między kolejnymi iteracjami
    
    if it == 4

    exportgraphics(app.UIAxes,'kmeans_iteracja_4.png');

    Grupa = (1:k)';
    LiczbaProbek = zeros(k,1);
    SrodekX1 = V(:,1);
    SrodekX2 = V(:,2);
    MinX1 = NaN(k,1);
    MaxX1 = NaN(k,1);
    MinX2 = NaN(k,1);
    MaxX2 = NaN(k,1);

    for j = 1:k

        punkty = probki(przynaleznosc == j,:);

        LiczbaProbek(j) = size(punkty,1);

        if ~isempty(punkty)

            MinX1(j) = min(punkty(:,1));
            MaxX1(j) = max(punkty(:,1));

            MinX2(j) = min(punkty(:,2));
            MaxX2(j) = max(punkty(:,2));

        end
    end

    app.UITableIter4.Data = table( ...
        Grupa,...
        LiczbaProbek,...
        SrodekX1,...
        SrodekX2,...
        MinX1,...
        MaxX1,...
        MinX2,...
        MaxX2);

    end
    
    if it == 10  % zapis wyników przy 10 iteracji
         exportgraphics(app.UIAxes,'kmeans_iteracja_10.png');

        Grupa = (1:k)';
        LiczbaProbek = zeros(k,1);
        SrodekX1 = V(:,1);
        SrodekX2 = V(:,2);
        MinX1 = NaN(k,1);
        MaxX1 = NaN(k,1);
        MinX2 = NaN(k,1);
        MaxX2 = NaN(k,1);
    
        for j = 1:k
    
            punkty = probki(przynaleznosc == j,:);
    
            LiczbaProbek(j) = size(punkty,1);
    
            if ~isempty(punkty)
    
                MinX1(j) = min(punkty(:,1));
                MaxX1(j) = max(punkty(:,1));
    
                MinX2(j) = min(punkty(:,2));
                MaxX2(j) = max(punkty(:,2));
    
            end
        end
    
        app.UITableIter10.Data = table( ...
            Grupa,...
            LiczbaProbek,...
            SrodekX1,...
            SrodekX2,...
            MinX1,...
            MaxX1,...
            MinX2,...
            MaxX2);

    end
    for j = 1:k
        punkty = probki(przynaleznosc == j, :);
        if ~isempty(punkty)
            V(j,:) = mean(punkty, 1);
        end
    end


end
        end

        % Cell edit callback: UITableIter4
        function UITableIter4CellEdit(app, event)
            indices = event.Indices;
            newData = event.NewData;
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 1324 803];
            app.UIFigure.Name = 'MATLAB App';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Wykres k-średnich')
            xlabel(app.UIAxes, 'X1')
            ylabel(app.UIAxes, 'X2')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Position = [742 311 531 463];

            % Create MetrykaButtonGroup
            app.MetrykaButtonGroup = uibuttongroup(app.UIFigure);
            app.MetrykaButtonGroup.Title = 'Metryka';
            app.MetrykaButtonGroup.ButtonDownFcn = createCallbackFcn(app, @MetrykaButtonGroupButtonDown, true);
            app.MetrykaButtonGroup.Position = [71 659 123 115];

            % Create EuklidesButton
            app.EuklidesButton = uiradiobutton(app.MetrykaButtonGroup);
            app.EuklidesButton.Text = 'Euklides';
            app.EuklidesButton.Position = [11 69 67 22];
            app.EuklidesButton.Value = true;

            % Create ManhattanButton
            app.ManhattanButton = uiradiobutton(app.MetrykaButtonGroup);
            app.ManhattanButton.Text = 'Manhattan';
            app.ManhattanButton.Position = [11 47 79 22];

            % Create CzebyszewButton
            app.CzebyszewButton = uiradiobutton(app.MetrykaButtonGroup);
            app.CzebyszewButton.Text = 'Czebyszewa';
            app.CzebyszewButton.Position = [11 23 90 22];

            % Create LiczbagrupEditFieldLabel
            app.LiczbagrupEditFieldLabel = uilabel(app.UIFigure);
            app.LiczbagrupEditFieldLabel.HorizontalAlignment = 'right';
            app.LiczbagrupEditFieldLabel.Position = [300 744 99 22];
            app.LiczbagrupEditFieldLabel.Text = 'Liczba grup';

            % Create LiczbagrupEditField
            app.LiczbagrupEditField = uieditfield(app.UIFigure, 'numeric');
            app.LiczbagrupEditField.Position = [455 744 51 22];
            app.LiczbagrupEditField.Value = 3;

            % Create LiczbaiteracjiEditFieldLabel
            app.LiczbaiteracjiEditFieldLabel = uilabel(app.UIFigure);
            app.LiczbaiteracjiEditFieldLabel.HorizontalAlignment = 'right';
            app.LiczbaiteracjiEditFieldLabel.Position = [299 703 110 22];
            app.LiczbaiteracjiEditFieldLabel.Text = 'Liczba iteracji';

            % Create LiczbaiteracjiEditField
            app.LiczbaiteracjiEditField = uieditfield(app.UIFigure, 'numeric');
            app.LiczbaiteracjiEditField.Position = [455 703 51 22];
            app.LiczbaiteracjiEditField.Value = 10;

            % Create STARTButton
            app.STARTButton = uibutton(app.UIFigure, 'push');
            app.STARTButton.ButtonPushedFcn = createCallbackFcn(app, @STARTButtonPushed, true);
            app.STARTButton.Position = [335 646 100 23];
            app.STARTButton.Text = 'START';

            % Create UITableIter4
            app.UITableIter4 = uitable(app.UIFigure);
            app.UITableIter4.ColumnName = {'Grupa'; 'Liczba próbek'; 'Środek X1'; 'Środek X2'; 'Min X1'; 'Max X1'; 'Min X2'; 'Max X2'};
            app.UITableIter4.RowName = {};
            app.UITableIter4.CellEditCallback = createCallbackFcn(app, @UITableIter4CellEdit, true);
            app.UITableIter4.Position = [47 364 675 124];

            % Create UITableIter10
            app.UITableIter10 = uitable(app.UIFigure);
            app.UITableIter10.ColumnName = {'Grupa'; 'Liczba próbek'; 'Środek X1'; 'Środek X2'; 'Min X1'; 'Max X1'; 'Min X2'; 'Max X2'};
            app.UITableIter10.RowName = {};
            app.UITableIter10.Position = [47 164 675 126];

            % Create iteracjaLabel_2
            app.iteracjaLabel_2 = uilabel(app.UIFigure);
            app.iteracjaLabel_2.Position = [49 299 60 22];
            app.iteracjaLabel_2.Text = '10 iteracja';

            % Create iteracjaLabel
            app.iteracjaLabel = uilabel(app.UIFigure);
            app.iteracjaLabel.Position = [49 497 54 22];
            app.iteracjaLabel.Text = '4 iteracja';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = ssi_cw1_v2

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end