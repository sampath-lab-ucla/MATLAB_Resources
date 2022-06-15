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
%   %% Convert prices
%   % Convert prices from USD/gallon to USD/liter using conversion factor in gal2lit
%   gal2lit = 0.2642;
%   Australia = gal2lit*Australia;
%   Germany = gal2lit*Germany;
%   Mexico = gal2lit*Mexico;
%   Canada = gal2lit*Canada;
%   
%   %% Plot results
%   plot(Year,Australia,"*--")
%   hold on
%   plot(Year,Germany,"*--")
%   plot(Year,Mexico,"*--")
%   plot(Year,Canada,"*--")
%   hold off
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
% In a script, using two consecutive comment characters (|%%| ) will create 
% a section break.
% 
% 
%% Differences Between Script And Function Files
% 
%% Create A Function
% 
%% Use A Function In A Script
% 
% 
% 
% 
% 
% 
%