%% Conditional Programming
% In this document, we cover program flow control using conditional statements.
%
%% What is conditional programming?
% In computer science, conditionals are programming language commands for handling 
% decisions. Specifically, conditionals perform different computations or actions 
% depending on whether a programmer-defined boolean condition evaluates to 
% true or false (<https://en.wikipedia.org/wiki/Conditional_(computer_programming)
% wiki>).
%
%% Conditional flavors
% Up to this point, we have been using comparators that result in non-scalar Boolean
% values. These non-scalar comparators come in the following forms:
%
% 
% * Element-wise comparisons
% * Scalar expansion comparisons
% * Multiple comparisons ( |&|,||| )
% * Membership determination
% 
%%%
% To control program flow, we must instead employ tactics that result in scalar
% comparisons. We can use the |all| and |any| functions to reduce non-scalar
% comparisons to single values:
%

%!
A = [0, 2, 6, 8, 0];

any(A == 0)
all(A < 0)

%%%
% For 2D arrays or larger, these two functions test along the first dimension if nothing else is
% specified. To change this behavior, a dimension can be specified.

%!
rng(326)
B = randi([-3,3],4,2);

any(B == 1, 2)
any(B == 0, 1)

%%%
% The argument 'all' will test the whole array.

%!
all(B < 1, 'all')

%%% Task 1 Determine if the array B above contains negative numbers.

%@
any(B < 0, 'all')

%%% Task 2 Which rows of B contains values equal or greater than 3? 

%@
find(any(B >= 3, 2))

%%%
% Below is a table of other functions we can use to evaluate statements as logical
% values:
%
% 
% <<lib/img/logicalOperations.png>>
% 
%% The IF Block
% We can control the flow a by using the |if| construct. The |if| block controls flow
% by allowing us to place constraints on a particular component of our code and
% executing the block of code if the conditions of our constraints are met. The
% syntax for an |if| block is as follows:
%
% 
%   if expression
%     statements
%   end
% 
%%%
% The |statements| are only executed when |expression| evaluates to |true|.
%
%%%
% We can also catch any conditions which aren't within our desired constraints with
% the |else| keyword. 
%
%   if expression
%     % if true
%     statements
%   else
%     % otherwise
%     statements
%   end
%
%%%
%
% <<lib/img/ifEnd.png>>
% 
%% The ELSEIF Block
% Based on the |if| block, |elseif| blocks can be chained together inside an
% |if| construct to allow for multiple binary branches. 
%
% 
% <<lib/img/ifElseIf.png>>
% 
%
% Consider the variable v:

%!
v = randi([-10,10]);

%%% Task 1 Make a decission tree that operates on v and displays "small" 
%%% for positive values smaller than 4, "large" for values larger than 4,
%%% "equal" for values equal to 4, and "negative" for values smaller than
%%% 0.

%@
if v < 4 && v >= 0
  disp("small");
elseif v > 4
  disp("large");
elseif v == 4
  disp("equal");
else
  disp("negative")
end

%%% Task 2 Consider the matrix B in the previous section. Write a short
%%% program that will return a variable C. If B contains any negative 
%%% values C should be the sum of all
%%% positive values in B. Otherwise C should be 0.

%@
if any(B < 0, "all")
  C = sum(B(B > 0), "all");
else
  C = 0;
end
disp(C);

%% The SWITCH
% Similar to the |elseif| construct, the |switch| block allows us to define a set of
% preferences, _cases_, that may alter the program flow. Switches are useful for
% setting user-defined preferences and for creating an organized and clean script.
% For our purposes, employing a |switch| statement to alter the method 
% used for a particular analysis could look like:
% 
% 
%   switch cellType
%     case "Rod"
%       analysisFcn = @peakFinder;
%     case "RBC"
%       analysisFcn = @dotTemplate;
%   end
%   % perform analysis
%   result = analysisFcn(Data,Parameters{:});
% 
%%%
% Like |else| for |if| statements, |otherwise| may be used as a catch-all for
% |switch| statements. 
% 
% 
%   switch cellType
%     case "Rod"
%       analysisFcn = @peakFinder;
%     case "RBC"
%       analysisFcn = @dotTemplate;
%     otherwise
%       error("unknown cell type");
%   end
% 
%%%
% Below is a diagram for the functional layout of a |switch| statement.
% 
% <<lib/img/switchCase.png>>
% 
%
% Given the struct array retina, below:

%! 
retina = struct();
retina(1).celltype = "rod";
retina(2).celltype = "rod bipolar cell";
retina(3).celltype = "cone";
retina(4).celltype = "horizontal cell";

%%% Task 1 Using a loop and a switch statement, make a new field in retina,
%%% Vm, that contains the resting membrane potentials of the celltypes (-40
%%% to the photoreceptors and -60 to the interneurons). 

%@

for idx = 1:numel(retina)
  switch retina(idx).celltype
    case {"rod", "cone"}
      retina(idx).Vm = -40;
    case {"rod bipolar cell", "horizontal cell"}
      retina(idx).Vm = -60;
  end
end

%%% Task 2 Find and the display the names of the cell types in retina that have a
%%% resting membrane potential above -50 mV.

%@
for idx = 1:numel(retina)
  if retina(idx).Vm > -50
    disp(retina(idx).celltype);
  end
end

%%% Task 3 Add another field "category" to retina that is the string "photoreceptor"
%%% for photoreceptors and "interneuron" for all other celltypes.

for idx = 1:numel(retina)
  switch retina(idx).celltype
    case {"rod", "cone"}
      retina(idx).category = "photoreceptor";
    otherwise
      retina(idx).category = "interneuron";
  end
end

%% Strings and Character Arrays
% MATLAB has a whole library of functions and methods dedicated to parsing strings
% and characters. If a string is not part of a categorical data-grouping, then we are
% interested in the contents of the string as it pertains to metadata, or information
% about our acquired data. To tell MATLAB how to "read" the string, we will either
% search the text for an expected substring, or we will modify the string in some
% way, or determine if the string is a member of an expected set. To achieve this, we
% can use many approaches that employ, under the hood, regular expressions or
% patterns. 
%
%%% Regular Expressions
% A regular expression is a sequence of characters that defines a certain pattern. 
% You normally use a regular expression to search text for a group of words that 
% matches the pattern, for example, while parsing program input or while processing 
% a block of text. Regular expressions are primarily used with the |regexp| and
% similar functions.
%
%%% Patterns
% MATLAB 2020b and newer releases have an alternative way to build patterns. A
% _pattern_ defines rules for matching text with text-searching functions like 
% |contains|, |matches|, and |extract|. We can build a _pattern_ expression using 
% pattern functions, operators, and literal text. We may even build regular
% expression _patterns_.
% 
% For more information about
% _patterns_, see <https://www.mathworks.com/help/matlab/ref/pattern.html>.
%
%%%
% The table below shows some useful functions for parsing strings using plain text or
% _patterns_.
% 
% <<lib/img/stringFn.png>>
% 
%% Locating A Substring
% Finding substrings can be a nontrivial matter. Sometimes the useful information
% within a string is surrounded by useless information. Depending on our purpose, we
% can find the substring, or information about the substring in a few ways. Consider
% the following string:
%

%!
labMembers = "Sam, Gordon, Rikard, Ala, Paul, Khris, Chris";

%%% Where does the substring "Paul" start?
%
% *Regular expression* approach:
%

%! 
regexp(labMembers, "Paul")
% Or
strfind(labMembers, "Paul")

%%% Is the substring "Rikard" present?
%
% *Regular expression*
%

%! 
~isempty(regexp(labMembers, "Rikard"))

% 
%%%
% *Pattern*
%

%!
contains(labMembers, "Rikard")

%%% Extract all members separated by a delimiter to a string Array

%!
lab  = split(labMembers, ', ');

%% Modifying A String
% Typical modifications to strings come in the form of insertion/deletion, case
% changes, splitting, and extraction. 
%
% For instance, the variable units below contains information on the units used
% in two recording devices, separated by semicolon and spaces.

%!
units = {'x:sec;y:pA; x:sec;y:V'};

%%% Task 1 Extract the x- and y-units from the recording devices and create
%%% strings (x, and y for each device) that can be used to label the axes
%%% in a figure.

%@

% split into devices by '; '
deviceArray = split(units, '; ');
xLabDev1 = {[replace( ...
  extractBefore( ...
  deviceArray{1}, ';'), 'x:', 'Time ('), ')']};
yLabDev1 = {[replace( ...
  extractAfter( ...
  deviceArray{1}, ';'), 'y:', 'Current ('), ')']};
xLabDev2 = {[replace( ...
  extractBefore( ...
  deviceArray{2}, ';'), 'x:', 'Time ('), ')']};
yLabDev2 = {[replace( ...
  extractAfter( ...
  deviceArray{2}, ';'), 'y:', 'Voltage ('), ')']};

