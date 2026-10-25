%% Planned M13 Metro Line Capacity Analysis- Fleet and Headway Selection

%% Peak Passenger Demand Computation

DailyBoardings = 620000; % Official (Historical) declared reference
UsageRate = 0.60; % Hypothetical usage rate per day
PeakShare = 0.10; % Peak-hour share;
DirectionShare = 0.55; % One-way direction share
SectionShare = 0.60; % Critical section share

%% Formulation of Daily Capacity

DDaily = DailyBoardings*UsageRate;
QPeak = DDaily*PeakShare*DirectionShare*SectionShare;  
% Peak passenger scenario reference

fprintf('Daily scenario demand is %.0f passengers.\n',DDaily);
fprintf('Peak section demand is %.0f passenger/hour/direction\n',QPeak);

%% Three Car Train Capacity

NumberOfCars = 3;
CapacityOfCars = 250; %Hypothetical capacity of cars
RhoMax = 0.85; %Hypothetical target maximum usage rate

CapacityTotal = NumberOfCars*CapacityOfCars;
HourlyUsage = (60./Headway)*CapacityTotal*RhoMax;

SystemIsFeasible = HourlyUsage >= QPeak;

%% Selection of Fleet and Headway

Selection = find(SystemIsFeasible);

if isempty(Selection)
    disp('There is no feasible operation alternative.');
else
    SelectedHeadway = Headway(Selection);
    SelectedTrainNumber = TrainNumber(Selection);

    Passengers = QPeak*SelectedHeadway/60;
    PassengersPerCar = Passengers/NumberOfCars;
    LoadRatio = Passengers/CapacityTotal;

    disp('SELECTED OPERATING PLAN');
    fprintf('Selected headway is %.2f minutes.\n',SelectedHeadway);
    fprintf('Selected train number is %d.\n',SelectedTrainNumber);
    fprintf('Number of passengers per set is %.1f.\n',Passengers);
    fprintf('Number of passengers per car is %.1f.\n',PassengersPerCar);
    fprintf('Load ratio is %.2f.\n',LoadRatio);
end

%% Results In Table

Results = table(Headway',TrainNumber',HourlyUsage',SystemIsFeasible');
disp(Results);

%% Maximum Headway

HeadwayMax = 60*CapacityTotal*RhoMax/QPeak;
fprintf('Maxium headway is %.2f minutes.\n',HeadwayMax);

%% Graphics

figure;

plot(Headway, HourlyUsage, 'o-');
hold on;
yline(QPeak,'--','Peak Demand');
xlabel('Headway(minutes)');
ylabel('Capacity(passenger/hour/direction)');
title('Headway-Capacity Analysis');
grid on;
