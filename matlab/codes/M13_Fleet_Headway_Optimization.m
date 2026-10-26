%% M13 Metro Line Objective Function

HeadwayMin = 2;    % Signalling limit (minutes)
HeadwayMax = 10;   % Service limit (minutes)

TrainNumberAll = 1:floor(TTotal/HeadwayMin);       % 1 to 46 trainsets
HeadwayAll     = TTotal ./ TrainNumberAll;         % actual headway (minutes)
HourlyUsageAll = (60 ./ HeadwayAll) * CapacityTotal * RhoMax;

SystemIsFeasibleAll = (HourlyUsageAll >= QPeak) & ...
    (HeadwayAll >= HeadwayMin) & (HeadwayAll <= HeadwayMax);

%% Objective Function
CV = 0.10; % Hypothetical Headway Variability
PassengerWaitingCost = 300*PeakDaily.*(HeadwayAll/120)*(1+CV^2);
ActiveTrainCost      = 13000*TrainNumberAll;
ReserveTrainCost     = 3000*ceil(0.10*TrainNumberAll);

J = PassengerWaitingCost + ActiveTrainCost + ReserveTrainCost;
J(~SystemIsFeasibleAll) = Inf;

%% Optimization
[Jmin, idx] = min(J);
if isinf(Jmin)
    disp('There is no feasible operation alternative.');
else
    TrainNumberOptimized = TrainNumberAll(idx);
    HeadwayOptimized     = HeadwayAll(idx);
    ReserveTrainNumber   = ceil(0.10*TrainNumberOptimized);
    fprintf('Optimal train number is %d trainsets.\n', TrainNumberOptimized);
    fprintf('Optimal headway is %.2f minutes.\n', HeadwayOptimized);
    fprintf('Required reserve trainset number is %d trainsets.\n', ReserveTrainNumber);
    fprintf('Total fleet is %d trainsets.\n', TrainNumberOptimized + ReserveTrainNumber);
    fprintf('Total cost is %.2f TL/hour.\n', Jmin);
end

%% Results in Table
ResultsOptimized = table(TrainNumberAll', HeadwayAll', HourlyUsageAll', ...
    Jall', SystemIsFeasibleAll', ...
    'VariableNames', {'Fleet','Headway','Capacity','Cost','Feasible'});
disp(ResultsOptimized(SystemIsFeasibleAll', :))

%% Results in Graphics
fig = figure;
hold on;
showGrey = ~SystemIsFeasibleAll & (HeadwayAll <= HeadwayMax);
plot(TrainNumberAll(showGrey), Jall(showGrey)/1000, 'x', ...
    'Color', [0.6 0.6 0.6], 'DisplayName', 'Infeasible (capacity)');
plot(TrainNumberAll(SystemIsFeasibleAll), Jall(SystemIsFeasibleAll)/1000, 'o-', ...
    'MarkerSize', 5, 'DisplayName', 'Feasible alternatives');
if ~isinf(Jmin)
    plot(TrainNumberOptimized, Jmin/1000, 'ro', ...
        'MarkerFaceColor','r', 'MarkerSize', 9, 'DisplayName', 'Optimum');
    text(TrainNumberOptimized, Jmin/1000, ...
        sprintf('  N=%d, h=%.2f minutes, %.1f k TL/h', ...
        TrainNumberOptimized, HeadwayOptimized, Jmin/1000), ...
        'VerticalAlignment','bottom');
end
xlabel('Operating Trainsets');
ylabel('Cost (1000 TL/hour)');
title('M13 - Operational Optimization');
grid on; legend('show','Location','northwest');
hold off;

%% Export Results
writetable(ResultsOptimized, 'M13_Optimization_v04.csv');
exportgraphics(fig, 'M13_Optimization_v04.png', 'Resolution', 200);
