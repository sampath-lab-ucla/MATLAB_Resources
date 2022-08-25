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
% Format
%% 
% * Names for functions must satisfy MATLAB <https://www.mathworks.com/help/matlab/ref/function.html 
% naming rules>, e.g., cannot start number or have spaces. Names for scripts only 
% need to comply with the naming rules if the script shall be run from the command 
% line.
% * Functions have special syntax for the header and footer lines, i.e., funcsion 
% must contain function declaration statement and end.
% * Functions require external variables to be declared in function declaration 
% statement, i.e., input argumnets and output arguments.
% * All code for a function must reside inside a function declaration, in its 
% own file. Scripts are open-ended and run as though being every line is being 
% sent directly to the command window.
% * Each function must reside in its own file with the file name matching the 
% function name.
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
%   function template = dotTemplate()...
%
%% 
% Save the file in the Current Folder. This makes the function availabel to 
% MATLAB while your Current Folder contains the function file (*.m). _Use the 
% function here_

%!
parabolaData = importdata("lib/data/Week2Data.csv");
knownAmps =  [];

%@
% - create plot of responses
% - estimate the amplitudes using custom function
% - create a plot of estimated ~ known

%% Use A Function In A Script
% Functions and scripts should be used together to produce analyses. In this 
% way, we can compartmentalize our analysis routines. In this section, we will 
% cover how to use a custom function in a custom script as a means of documenting 
% our analysis process and making transparent our processes. In the following 
% example, we will create a function file that averages matrix rows in a column-wise 
% manner from a grouping variable. This is the same process we have been repeating 
% over and over in previous topics. Once we have a working function, we will import 
% multiple data files which contain reponse~intensity values from an earlier analysis 
% (assumed). While importing the files, we will average their reponses values 
% based on their intensity values and store the results in a container variable. 
% Once we have our individual averages, we will perform some data wrangling to 
% put the aggregate data into a form that allows us to use our avgByGroup function 
% again. We will then 
% 
% 
% 
% Task: creat new function that... Then, create a script that load a dataset, 
% wrangles data, the processess with created function
%%
% 
%   function averagedData = avgByGroup(data,by,opts)
%    %%avgByGroup Takes data matrix and grouping row-vector and performs statistic (optional) on groups
%     arguments
%       data double
%       by (1,:) double {mustHaveEqualColumns(by,data)}
%       opts.statistic (1,1) function_handle
%     end
%     % average BY, use opts.statistic on averages
%   end
%   %% helper functions
%   function mustHaveEqualColumns(v,ref)
%     if numel(v) ~= size(ref,1)
%       error("Incorrect number of columns! Needed: %d",size(ref,1));
%     end
%   end
%
%% 
% Create script
%%
% 
%   %% IR Curve analysis for RBCs
%   % data were analyzed previously and intensites are in R*, amplitudes are in pA
%   
%   %% locate data files
%   dataLoc = "lib/data/";
%   dataFileNames = dir(fullfile(dataLoc,"*.idata"));
%   
%   %% loop files and analyze
%   avgFcn = @(x) mean(x,2,'omitnan');
%   analysisResults(1:numel(datFileNames),1) = struct(data=[],result=struct());
%   for d = 1:numel(dataFileNames)
%    this = struct();
%    this.data = load(fullfile(dataFileNames(d).folder,dataFileNames(d).name),'intensities','responseAmplitudes');
%    this.result = avgByGroup(this.data.responseAmplitudes,by=this.data.intensities);
%    analysisResults(d) = this;
%   end
%   
%   %% Aggregate results
%   
%   %% Analyze aggregates
%   hillFc = @(param,intensity) = 1./(1+(param(1)/intensity).^param(2));
%   % fit to averaged data
%   
%   %% Plot for manuscript
%   % response ~ intensity 
%   % make fit line from fit parameters
%   
%   
%
%% 
% 
% 
% 
% 
% 
% 
% 
% 
%
