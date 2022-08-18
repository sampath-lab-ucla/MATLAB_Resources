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
% Rikard, need string here

%%% Where does the substring start?
%
% *Regular expression* approach:
%
% 
% *Pattern*
%
%
%%% Is the substring present?
%
% *Regular expression*
%
% 
% *Pattern*
%
%
%% Modifying A String
% Typical modifications to strings come in the form of insertion/deletion, case
% changes, splitting, and extraction. 
%
%% Membership
% We often need to to determin
%% Advanced Matching And Tokenizing
% MAYBE REMOVE THIS SECTION: I HAD INTENDED ON COVERING SOME ADVANCED REGEX,
% LOOKAROUNDS, MULTIPLE MATCHES, SPLITTING ON TOKENS... BUT MAYBE IT IS A LITTLE TOO
% MUCH.

