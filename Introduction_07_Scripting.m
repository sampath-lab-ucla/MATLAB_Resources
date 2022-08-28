%% Scripts and Functions
% In this document, we will cover the basics of using scripts and functions.
%% Using Comments To Organize Code
% How do you write a script that is easy to read and understand? We often write 
% and rewrite code to produce analyses and the train of thought could become derailed, 
% especially when read by others. For example, the below block of code loads, 
% converts, and plots data about gasoline prices from several countries. What 
% if you wanted to add data from another country or do some other conversion?
%%
% 
%   load gCosts
%   gal2lit = 0.2642;
%   Australia = gal2lit*Australia;
%   Germany = gal2lit*Germany;
%   Mexico = gal2lit*Mexico;
%   Canada = gal2lit*Canada;
%   plot(Year,Australia,"*--")
%   hold on
%   plot(Year,Germany,"*--")
%   plot(Year,Mexico,"*--")
%   plot(Year,Canada,"*--")
%   hold off
%   title("International Gasoline Prices")
%   xlabel("Year")
%   ylabel("Price (USD/L)")
%   legend("Australia","Germany","Mexico","Canada","Location","northwest")
%
%% 
% To increase the readability of this code, we can use comments (|%|) to annotate 
% sections of the code. An example of a cleaner version of the above code block 
% is below:
%%
% 
%   %% Import data
%   load gCosts
%
%%
% 
%   %% Convert prices
%   % Convert prices from USD/gallon to USD/liter using conversion factor in gal2lit
%   gal2lit = 0.2642;
%   Australia = gal2lit * Australia;
%   Germany = gal2lit * Germany;
%   Mexico = gal2lit * Mexico;
%   Canada = gal2lit * Canada;
%
%%
% 
%   %% Plot results
%   plot(Year,Australia,"*--")
%   hold on
%   plot(Year,Germany,"*--")
%   plot(Year,Mexico,"*--")
%   plot(Year,Canada,"*--")
%   hold off
%
%%
% 
%   %% Annotate the plot
%   title("International Gasoline Prices")
%   xlabel("Year")
%   ylabel("Price (USD/L)")
%   legend( ...
%     "Australia", "Germany", "Mexico", "Canada", ...
%     "Location", "northwest" ...
%     );
%
%% 
% In a script, using two consecutive comment characters ( |%%| ) will create 
% a section break.
%% Differences Between Script And Function Files
% Scripts and functions both contain code for MATLAB to run and have file names 
% that end with |.m|. Here, we highlight some of the differences.
% Scope
% Variables defined in scripts are GLOBAL (stroed to Global Workspace), while 
% variables defined in functions are LOCAL (stored in the running function's Local 
% Workspace). Because of scoped variables, functions allow for argument validation.
% 
%% Format
% * Names for functions must satisfy MATLAB <https://www.mathworks.com/help/matlab/ref/function.html 
% naming rules>, e.g., cannot start number or have spaces. Names for scripts only 
% need to comply with the naming rules if the script shall be run from the command 
% line.
% * Functions have special syntax for the header and footer lines, i.e., function 
% must contain function declaration statement and end.
% * Functions require external variables to be declared in function declaration 
% statement, i.e., input argumnets and output arguments.
% * All code for a function must reside inside a function declaration, in its 
% own file. Scripts are open-ended and run as though being every line is being 
% sent directly to the command window.
% * Each function must reside in its own file with the file name matching the 
% function name.
%
%% Argument validation
% Functions allows for argument validation and restriction through an optional arguments
% block (see example below for syntax). The arguments block must start 
% before the first executable line of the function.  
% In the argeuments block you can define required size, data class and add default values to your input arguments.
% Arguments that have defult values are considered *optional* and must be
% positioned after *required* arguments. There ara also a number of
% <https://www.mathworks.com/help/matlab/matlab_prog/argument-validation-functions.html validation functions> that can be implemented.
%
%   function output = myFunction(inArg1, inArg2, inArg3)
%     arguments
%       inArg1 (1,1) double {mustBeNonZero, mustBeFinite}
%       inArg2 (:,1) double {mustBeFinite}
%       inArg3 (logical) = false
%     end
%     if inArg3
%       output = inArg2 .* inArg1;
%     else
%       output = inArg2 ./ inArg1;
%     end
%   end
% 
%% Create A Function
% Go to New > Function and the following (or similar) will pop up in a new editor 
% window.
%%
% 
%   function [outputArg1,outputArg2] = untitled1(inputArg1,inputArg2)
%     %UNTITLED1 Summary of this function goes here
%     %   Detailed explanation goes here
%     outputArg1 = inputArg1;
%     outputArg2 = inputArg2;
%   end
%
%% 
% Edit the output and input arguments, and set the name of the function so that 
% the header line reads:
%%
% 
%   function amplitudes = dotTemplate(respMat, firstIdx, lastIdx)
%     % Function for estimate amplitudes by template matching.
%     %   The inputs are: 
%     %     respMat -> response traces organised in columns
%     %     firstIdx -> index of first element in window of interest
%     %     lastIdx -> index of last element in widow of interest
%   end
%%
% Add an arguments block with approriate validations and restrictions.
%% 
%
%   function amplitudes = dotTemplate(respMat, firstIdx, lastIdx)
%     % Function for estimate amplitudes by template matching.
%     %   The inputs are: 
%     %     respMat -> response traces organised in columns
%     %     firstIdx -> index of first element in window of interest
%     %     lastIdx -> index of last element in widow of interest     
%     arguments
%       respMat (:,:) double {mustBeFinite}
%       firstIdx (1,1) uint8 {mustBePositive}
%       lastIdx (1,1) uint8 {mustBePositive, mustBeGreaterThan(lastIdx, firstIdx)}
%     end
%   end
%%
% Now we can add the executable body of the function.
%
%   function amplitudes = dotTemplate(respMat, firstIdx, lastIdx)
%     % Function for estimate amplitudes by template matching.
%     %   The inputs are: 
%     %     respMat -> response traces organised in columns
%     %     firstIdx -> index of first element in window of interest
%     %     lastIdx -> index of last element in widow of interest   
%     arguments
%       respMat (:,:) double {mustBeFinite}
%       firstIdx (1,1) uint8 {mustBePositive}
%       lastIdx (1,1) uint8 {mustBePositive, mustBeGreaterThan(lastIdx, firstIdx)}
%     end
%     subMat = respMat(firstIdx:lastIdx, :); % subset data
%     templ = mean(subMat, 2, 'omitnan'); % template as mean response
%     [~, maxIdx] = max(abs(templ)); % find peak value of template
%     templ = templ ./ mean(templ((-25:25)+maxIdx)); % scale template by peak value 
%     templ = templ ./ dot(templ.',templ); % scale template by squared magnitude
%     amplitudes = templ.' * subMat; % amplitudes from dot product
%   end
%
%%
% Save the file in the Current Folder. This makes the function available to 
% MATLAB while your Current Folder contains the function file (*.m). 
%
%% Use A Function In A Script
% Functions and scripts should be used together to produce analyses. In this 
% way, we can compartmentalize our analysis routines. In this section, we will 
% cover how to use a custom function in a custom script as a means of documenting 
% our analysis process and making transparent our processes. 
%
% *Task 1: Use the function above to complete the TASK 1 of the home work
% from week 2.*

%!
% - create plot of responses
% - estimate the amplitudes using custom function
% - create a plot of estimated ~ known

% Given:
fs = 1000; % hz
duration = 2; % sec
amps = 0:1.5:7.5; % mV

% import
responses = importdata('./lib/data/Week2Data.csv');
[nPts,nResp] = size(responses);

% make time vector
%time = linspace(0,duration,nResp));
time = ((1:nPts).' - 1) ./ fs;

% use our function
ampEstimates = dotTemplate(responses, 1, nPts);

fig1 = figure('Color',[1,1,1]);
layout = tiledlayout(fig1,1,2, Padding='compact',TileSpacing='compact');
% initialze array of axes for this figure
ax = gobjects(1,2);

% left axes: plot responses against time (sec)
ax(1) = nexttile(layout);
ax(1).XLabel.String = "Time (sec)";
ax(1).YLabel.String = "Response (mV)";
% plot responses on axes
line(ax(1),repmat(time,1,nResp),responses,'color',[0,0,0]);

% right axes: plot known vs estimates use filled circles
ax(2) = nexttile(layout);
ax(2).XLabel.String = "Amplitude (mV)";
ax(2).YLabel.String = "Estimate (mV)";
% put amplitudes on plot
line( ...
  ax(2), ...
  amps, ...
  ampEstimates, ...
  Color = [0,0,0], ...
  LineStyle = 'none', ...
  Marker = 'o', ...
  MarkerFaceColor = [0,0,0] ...
  );

% set ax(2) and ax(1) to same ylimit
linkaxes(ax,'y');

% BONUS: Fit a line to the amplitude
ampFitParams = [ones(nResp,1),amps.']\ampEstimates.';

fitLine = refline(ax(2),ampFitParams(2),ampFitParams(1));
fitLine.Color = 'r';
fitLine.LineStyle = ':';

% pad right axes x-axis by 5% on lower and upper bounds
ax(2).XLim = ax(2).XLim + diff(ax(2).XLim).*[-0.05,0.05];

grid(ax,"on")

%% Generate and use generalized functions
% There are several advantages of creating and using functions. One of them
% is to avoid having to re-write (or copy-paste) code for common tasks that
% we perform often. 
%
% In the following example, we will create a function file that produces a grouping vector that can be used to average data. 
% This is the same process we have been repeating 
% over and over in previous topics. Once we have a working function, we will import 
% a data file which contain response~intensity values from multiple recordings, average their reponses values 
% based on their intensity values and store the results in a container variable. 
%%
% *Task 2: Create new function that produces a grouping vector based on an input vector and save it on your path. 
% Then, create a script that loads the data set "/lib/data/rbcAmplitudes.mat", 
% and average the amplitude data based on the stimulus intensities.* 
%
%@

dataLoc = "lib/data/";
dataFileNames = fullfile(dataLoc,"rbcAmplitudes.mat");

load(dataFileNames, "R_star", "pA");

[groupVector,groupId,groupCount] = generateGroups(R_star);

aggAmplitudes = nan(numel(groupId, 1));

for group = 1:numel(groupId)
  aggAmplitudes(group) = mean(pA(groupVector == group));
end
fig = figure( ...
  Color=[1,1,1], ...
  defaultAxesFontName = 'Arial', ...
  defaultAxesFontSize = 20 ...
  );
ax = axes(fig);

% labels
ax.XLabel.String = 'Flash Strength (R^{*})';
ax.YLabel.String = 'Photoresponse (pA)';
% set xscale to log
ax.XScale = 'log';
ax.YScale = 'linear';
ax.LineWidth = 2;
ax.TickLength = [2, 1]./100;

% draw individual stimulus response
line( ...
  ax, ...
  R_star, pA, ...
  Color=[1,1,1].*0.6, ...
  LineStyle='none', ...
  Marker='o', ...
  MarkerFaceColor=[1,1,1].*0.6, ...
  MarkerSize=6 ...
  );
% draw average stimulus response
line( ...
  ax, ...
  groupId, aggAmplitudes, ...
  Color=[1,1,1].*0, ...
  LineStyle='none', ...
  Marker='o', ...
  MarkerFaceColor=[1,1,1].*0, ...
  MarkerSize=12 ...
  );

% 
%% 
% The grouping function is useful, but there is a lot more to the script
% that could be included in the function. We could for instance make a
% function that does both the grouping and perform the statistics.
%
% *Task 3: Create a function that produces an aggregate on a vector y 
% based on groups determined by vector x. Use the function with the 
% same data set as in Task 2.*
% 
%@
dataLoc = "lib/data/";
dataFileNames = fullfile(dataLoc,"rbcAmplitudes.mat");

load(dataFileNames, "R_star", "pA");

aggData = aggregateByX(R_star,pA,@mean);

% Fitt Hill Eq using lsqcurvefit
Eq = @(b,x) (b(1).*x.^b(3)./(b(2).^b(3)+x.^b(3))); % Hill eq
b0 = [max(aggData(:,1)), mean(aggData(:,2)), 1]; % guess

coef = lsqcurvefit( ...
  Eq, ...
  b0, ...
  aggData(:,1), ... % X data
  aggData(:,2), ... % Y data
  [100, 0.1, 1], ... % lower bounds
  [500, 10, 2], ... % upper bounds
  optimoptions('lsqcurvefit','Display', 'off'));
  
  Xfit = logspace(log10(aggData(1,1)), log10(aggData(end,1)), 100);
  Yfit = Eq(coef, Xfit);

fig = figure( ...
  Color=[1,1,1], ...
  defaultAxesFontName = 'Arial', ...
  defaultAxesFontSize = 20 ...
  );
ax = axes(fig);

% labels
ax.XLabel.String = 'Flash Strength (R^{*})';
ax.YLabel.String = 'Photoresponse (pA)';
% set xscale to log
ax.XScale = 'log';
ax.YScale = 'linear';
ax.LineWidth = 2;
ax.TickLength = [2, 1]./100;

% draw individual stimulus response
line( ...
  ax, ...
  R_star, pA, ...
  Color=[1,1,1].*0.6, ...
  LineStyle='none', ...
  Marker='o', ...
  MarkerFaceColor=[1,1,1].*0.6, ...
  MarkerSize=6 ...
  );
% draw average stimulus response
line( ...
  ax, ...
  aggData(:,1), aggData(:,2), ...
  Color=[1,1,1].*0, ...
  LineStyle='none', ...
  Marker='o', ...
  MarkerFaceColor=[1,1,1].*0, ...
  MarkerSize=12 ...
  );
% darw fit line
line( ...
  ax, ...
  Xfit, ...
  Yfit, ...
  Color=[0,0,0], ...
  LineStyle='-', ...
  LineWidth=2 ...
  );

%% Function definitions 
% 
% The functions used in this live script are defined below:
% 
function [groupVector,groupId,groupCount] = generateGroups(xInput)
  arguments
    xInput (:,1) 
  end 
  % get unique ids 
  [groupId,groups,groupVector] = unique(xInput,'stable'); 
  nGroups = numel(groupId); 
  groupCount = zeros(nGroups,1); 
  for g = 1:nGroups 
    groupCount(g) = sum(groupVector == groups(g)); 
  end 
end 

function agg = aggregateByX(xInput,yInput,statistic) 
% validate arguments 
arguments 
  xInput (:,1) double 
  yInput (:,1) double {mustHaveEqualRows(yInput, xInput)}
  statistic (1,1) function_handle
end 

% Check how many outputs in statistic
nOutStat = nargout(statistic);
statOut = cell(nOutStat, 1);
% get unique ids 
[vals,~,idx] = unique(xInput,'stable'); 
nGroups = numel(vals); 
gNums = 1:nGroups; 

% create storage variable 
agg = zeros(nGroups,1+nOutStat); 
for g = gNums 
  gIndex = idx == g; 
  thisY = yInput(gIndex); 
  agg(g,1) = vals(g); 
  [statOut{:}] = statistic(thisY);
  agg(g,2:end) = [statOut{:}]; 
end 
end 

%% helper functions
function mustHaveEqualRows(v,ref)
  if numel(v) ~= size(ref,1)
    error("Incorrect number of columns! Needed: %d",size(ref,1));
  end
end
