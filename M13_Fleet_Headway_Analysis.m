%% M13 Metro Line Fleet-Capacity-Headway Analysis

%% System Parameters

LineLength = 24.6; % One-way line length (km)
AvgSpeed = 35; % Hypotetical average commercial speed (km/h)
TerminalTurnTime = 8; % Hypotetical total terminal time (min)

%% Cycle-Turn Time Calculations

TOneCycle = (LineLength/AvgSpeed)*60; %Simplified one-way turn time
TTotal = (2*TOneCycle)+TerminalTurnTime;

fprintf('One way time is %.2f minutes.\n',TOneCycle)
fprintf('Total cycle time is %.2f minutes.\n',TTotal)

%% Headway Alternatives to Operate

Headway = 2:0.5:10;
disp(Headway);

%% Fleet-Train Necessity

TrainNumber = ceil(TTotal./Headway);
disp(TrainNumber)

%% Making Table From Operation Knowledges

AllResults = table(Headway,TrainNumber);
disp(AllResults)

%% Plotting the Knowledges

figure;
stairs(Headway,TrainNumber,'Linewidth', 1.5);
xlabel('Headway(minutes)');
ylabel('Train Number For Operation');

title('Planned M13 Metro Line Headway-Train Number Analysis');
yticks(10:2:50);

grid on;

writetable(AllResults,'Planned M13 Metro Line Headway-Train Number Analysis.csv')
