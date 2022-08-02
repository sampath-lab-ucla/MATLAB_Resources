%% Overview of MATLAB Data Types
% In this document we will explore use cases for different data types.
%%% What is a data type?
% From Wikipedia: In computer science and computer programming, a data type 
% (or simply, type) is an attribute of data which tells the compiler or interpreter 
% how the programmer intends to use the data. Most programming languages support 
% basic data types of integer numbers (of varying sizes), floating-point numbers 
% (which approximate real numbers), characters (and strings) and Booleans. A data 
% type constrains the possible values that an expression, such as a variable or a 
% function, might take. This data type defines the operations that can be done on 
% the data, the meaning of the data, and the way values of that type can be stored.
%
% Simply put, the type an item takes defines how it can be used. As the masters of
% our own code, we must tell the machine what kinds of data we will use, how we will
% use it and how much of it to use when and where. It is possible to convert one data
% type into another by a process called _casting_. MATLAB automatically casts data
% types most of the time, but one must be completely aware of which data type is
% being operated on. In most cases, automatic casting will cast the higher precision
% values to the lower precision values. Precision here means how many digits are in
% the number and how many of those digits are decimals. 
%
%% Fundamental Data Types
% The most general data types are shown in the figure below.
%
% <<lib/img/fundamentalDataTypes.png>>
% 
% For the most part, we will be working with |numeric|, |logical|, |char|, and
% |string| data types. This subset of data types make up the classes of data we will
% use. The rest of the data types function as special containers in which we will
% hold the aforementioned types.
% 
% We can check a items type by using the |class| function.
%

%!
class(true)
class(10)
class(uint8(32))

%%%
% note that MATLAB will cast logicals to double, violating the general rule of
% down-casting, when they are operated on as if they are numeric, e.g. addition.
%

%!
class(true + true)


%% Numeric Type
% Numeric data come in a few flavors. By default, MATLAB will store unspecified
% numeric values as |double| type, which is short for double-precision floating-point
% values.
%
% Numeric classes in the MATLAB software include signed and unsigned integers, and 
% single- and double-precision floating-point numbers. By default, MATLAB stores all 
% numeric values as double-precision floating point. (You cannot change the default 
% type and precision.) You can choose to store any number, or array of numbers, as 
% integers or as single-precision. Integer and single-precision arrays offer more 
% memory-efficient storage than double-precision.
% 
% All numeric types support basic array operations, such as subscripting, reshaping, 
% and mathematical operations.
% 
%%% 
% *Floating-point numbers*
%
% Floating-point refers to a type of scientific notation for the representation of
% numeric values. The footprint in memory constructed of a significand, an exponent
% and a sign, which occupy specific proportions of the bits used to construct the
% digit.
%
% Classes |double| and |single| indicate the level of precision that is used to
% express a numerical quantity. Similar to precision in mathematics, precision here
% refers to the level of detail used to express a number, with 64-bits being used for
% |double| and 32-bits for |single|. For our purposes, this knowledge is important
% when it comes to comparing data, or seraching data for particular features. MATLAB,
% by default, stores any numeric value as a |double| unless specified by the
% code/author. Further, any numeric value can be converted to |double| by using the
% |double()| function:
%

%!
class(double(int8(20)))

%%%
% The only important thing to know about floating-point numbers in our use is that
% you can get rounding errors which will mess up calculations. For example, in
% |double|-precision, the following logical test fails, even though the math should
% work out identical.
%

%!
( 5 * (1/3) ) == 5/3

%%%
% Because MATLAB uses |double| precision, there is a rounding error that is
% exascerbated by the multiple steps in the lefthand side. If we were to cast the
% values to single, the rounding error is mitigated (in this example, not always
% though).
% 

%!
single( 5 * (1/3) ) == single(5/3)

%%%
% Because of this, care must be taken when analyzing data and often we have to find a
% slightly more agnostic approach with our data wrangling techniques. Sometimes this
% means finding the first value that exceeds a threshold rather than one the exactly
% matches it, for example.
%
%%%
% *Integers*
% 
% The use of integers often facilitates more efficient use of memory, but can also
% cause issues when being used to represent low-precision values that get operated on
% with high-precision values. It is often useful to use integers as indexing values
% as their use will keep the program's memory foot print lower, and may also impact
% performance positively. The table below shows the different integer types and their
% range of possible values. Integers come in 2 flavors, signed and unsigned. Signed
% integers may be negative, and thus allocate a bit for the sign in memory which
% impacts their total range. Unsigned integers are allowed to be zero or positive.
% Casting a negative integer to an unsigned class will convert the value to 0.
%
% <<lib/img/integerTypes.png>>
%
%% Logical (Boolean)
% MATLAB represents the boolean values, |true| and |false|, as the |logical| data
% type. Boolean data are used in conditional programming and indexing. Most often, we
% will use booleans to find the index of some value within an array. But there are
% many uses for booleans that we will encounter from time to time. We will discuss
% boolean operations extensively in the Conditionals live script. 
%
% <<lib/img/logicalOperations.png>>
%
%%%
% The functions |true| and |false| can be used to create logical arrays or without 
% any inputs to create a single boolean.
%

%!
true(1,5,2) % a 3D array!
false

%%%
% The function |logical| can be used to cast values into logical. Note that any
% nonzero number is casted to |true| and any zero is casted to |false|.
%

%!
logical('a') % from char
logical(-10) % negative number
logical([1,0,-1]) % from array


%%%
% When comparing arrays, there are a few things to be aware of. The Short-circuit
% operators will only work with scalar comparisons and in cases where the
% short-circuit |&&| (AND) is used, the second condition is only tested if the first
% condition evaluates to |true|. For example, the below code block would throw an
% error because the variable |fu| does not exist. Note, I'm using a |try| block
% because the live script will fail to run completely if an error exists.
%

%!
try
  fu
catch ME
  disp("Error was caught with message: '" + string(ME.message) + "'.");
end

%%%
% Below, the first argument evaluates to |false| and so the error from above would
% not be thrown:
%

%!
if exist('foo','var') && foo
  disp("Foo exists!");
else
  disp("Foo does not exist! Notice I didn't error??");
end

%%%
% But below, an error is thrown (which we catch) because the first argument is |true| :
%

%!
try
  if true && foo
    disp("Foo exists!");
  else
    disp("Foo does not exist! Notice I didn't error??");
  end
catch ME
  disp("Error was caught with message: '" + string(ME.message) + "'.");
  disp("The error has an identifier code: " + string(ME.identifier));
end

%%%
% MATLAB will evaluate the lefthand side first in order to
% determine whether the righthand side needs to be evaluated at all. This means that
% an implied order of operations exists, which can be overrided by grouping with
% parenthesis, just like mathematical operations. For example, |a & b > c| evaluates
% as |a & (b > c)|. It is *always* advised to use parentheses to group multiple
% logical operations to increase the readability and stability of your code.
%
%%%
% *Logical Arrays*
%
% Just like with mathematical operators, logical operators also have an element-wise
% syntax. We can see this in action below:
%

%!
rng(1000);
randomMatrix = randn(10); %10x10 square
logicalMatrix = randomMatrix > 0

%%%
% The greater-than symbol, |>|, is an element-wise operation. Let's say we have some
% data and we want only the values that are within a defined interval. We can use two
% separate logical operations to test a lower bounds and an upper bounds. This would
% give use two separate logical vectors. To find the elements in the array that
% satisfy both conditions, we can use the element-wise |&| (AND) operator. The
% mathematical notation is:
%
%
% $$L_{\mathrm{low}}\lt x_i\lt L_{\mathrm{high}},$$
%
% for all $x \in X$.
%

%!
testInterval = [-1,1];
isAboveLow = randomMatrix(:,3) > testInterval(1);
isBelowHigh = randomMatrix(:,3) < testInterval(2);
% display as matrix
disp([isAboveLow,isBelowHigh])
% test for values that match both low and high conditions
isInInterval = isAboveLow & isBelowHigh

%%%
% We can test whether this logical test worked by indexing back into the original
% data:
%

%!
dataInInterval = randomMatrix(isInInterval,3)

%%%
% We can shorthand this a little by using parentheses to group the logical operations
% like so:
%

%!
isInInterval_shorthand = ...
  ( randomMatrix(:,3) > testInterval(1) ) & ...
  ( randomMatrix(:,3) < testInterval(2) )

%%%
% Note that we must explicitly make both comparisons. Can you think of why the code
% below does not produce the correct result?
%

%!
isInInterval_wrong = testInterval(1) < randomMatrix(:,3) < testInterval(2)

%%%
% What would you expect from |randomMatrix(isInInterval_wrong,3)|?
% 
%% Strings And Characters
% MATLAB has two data types for non-numeric values, such as letters. The more
% low-level data type is the |char|, which occupies 16 bits, 2 bytes, of memory per
% character. A character array, or |char array|, is a sequence of characters just as
% a numeric array is a sequence of numbers. In fact, character arrays can be
% constructed from numeric arrays. Most printable characters are between numeric
% values 33 and 126. 
% 

%!
char(33:126)
double( char(33:126) )

%%%
% We create |char| arrays by surrounding the text in single quotation marks, |''|.
% For example: 
%

%!
aLetter = 'a';
aWord = 'big';
aSentence = [aLetter, ' ', aWord, ', bad bunny!']


class(aSentence)
whos('aLetter','aWord','aSentence')

%%%
% Since |char| arrays are fundamental arrays, we can use indexing to access elements
% within the array just like with numeric arrays.
%

%!
firstLetter = aSentence(1)
% make firstLetter up and assign to aSentence(1)
aSentence(1) = upper(firstLetter);
disp(aSentence)

%%%
% We can create |2D| |char| arrays as well. The number of characters in each row must
% match. 
%

%!
char(97 + zeros(3))
['abc';'abc']

%%%
% *Casting Characters*
%
% We can convert values into |char| s according to the rules outlined in the table
% below:
%
% <<lib/img/charConversions.png>>
%
%%%
% *Strings*
%
%%%
% The |string| datatype is a fancier version of |char| arrays. With the added
% functionality, comes added complexity and memory footprint. For most cases, |string|
% variables behave similar to |char| arrays with a few exceptions. First, we denote a
% |string| by enclosing the text in double quotation marks, |""|. 

%!
aString = "a";
whos('aString','aLetter')

%%%
% Second, a |string| acts like an encapsulated |char| array in that we can actually 
% access the |char| array directly by indexing with the curly-brace notation, |{}|. 
%

%!
stringContents = aString{1}
whos('aString','stringContents')


%%%
% With the added size of the memory footprint comes a number of other features as 
% well. Strings are well suited for making arrays of distinct |char| arrays. Where
% concatenating |char| s creates a |char| array, concatenating |string| s creates an
% array of |string| containers. Again, the underlying |char| data can be retrieved
% using the curly-brace notation.
%

%!
['Concatenating chars ', 'makes one', ' long char array.', ' see?']
s = ["Concatenating strings", "makes", "an array of", "different strings."]

s{3}

%%%
% We typically don't use the curly-brace indexing method since |string| and |char|
% are acceptable as-is in most MATLAB operations with strings (see Conditionals).
% Instead, we are typically interested in searching through |string| arrays for
% specific |string| s that meet some criteria. This isn't possible with |char| arrays
% alone, and requires a container and special functions to achieve the same result.
% For example:
%

%!
try
  ['char','array'] == 'array'
catch ME
  disp(ME.message);
end
["string", "array"] == "array"

%%%
% In the |string| example, the whole contents of the righthand |string| are compared
% against each |string| in the lefthand side. In the |char| example, we get an error
% because MATLAB is trying to compare two |char| vectors in an element-wise manner.
% If the two |char| arrays were the same size and shape, what do you think the output
% would be? For example, what would the result be of:
%
%   'array' == 'array'
%
%%%
% We will cover more about |string| s in the conditional programming lesson, but one
% last important differnce between |char| s and |string| s is how they are
% concatenated. For |char| s, using the concatenation operators, |[]|, will simply
% append letters together into a |char| array. We don't get this behavior with
% |string| s, instead we get a new isolated element concatenated onto the array. To
% append letters to individual |string| s, we can use the plus (|+|) operator. 
%

%!
['a','b','c'] % merge letters into char array
["a","b","c"] % store words
"a" + "b" + "c" % merge letters into single string
"A" + "String" + "Value" % same

% we cannot use + for chars:
'a' + 'b' + 'c'
try
  'a' + 'Char' + 'Value'
catch ME
  disp("Error: '" + ME.message + "'")
end

%%%
% Can you think of why the last example caused an error?
%
%
%% Casting (Converting between types)
% Sometimes, either on purpose or inadvertantly, we will encounter the case where
% different data types are combined. Unlike most other languages, MATLAB will attempt
% to automatically convert values of one type to another, and it won't even tell you
% that it did. Usually, MATLAB will convert high-precision values to the lowest
% precision values in the combination. Generally speaking, valid combinations of
% differnt data types, such as concatenating a |char| and a |double|, will follow the
% rules in the table below:
%
% <<lib/img/combiningDatatypes.png>>
%
%%%
% There are some more specific rules than are listed above,
% for example, when combining integers with other numeric classes, matlab will use
% the first, from left to right, integer class it encounters. For example, in the 
% first statement below, all values will be converted to the int32 type, and in the 
% second statement, all values will be converted to the uint8 type:
%

%!
A = [true pi int32(1000000) single(17.32) uint8(250)];
B = [true pi uint8(250) int32(1000000) single(17.32)];

class(A)
class(B)

%%%
% For integers, it is always true that the left-most type is used as the target class
% for casting the rest of the variables. So one must be careful when combining
% integer types as each class has a different range of possible values.
%
%   [int8(50), int16(1000)]
%   ans =
%     1x2 int8 row vector
%     50  127
%
%%%
% Notice |int16(1000)| was reduced to the maximum |int8| value when is was casted.
%
%% Containers
% As |numeric|, |logical|, |string|, and |char| data types can be made into arrays,
% it is often useful to organize these arrays in such a way as to produce tidy,
% accessible data. This is where the other data types come in. Recall that an array
% is simply the collection of multiple "things" in a single variable. Until now, we
% have mostly worked with numeric arrays, which is primarily where we will store
% physiological data.
%
%%%
% Now, we will introduce the data types that function as containers for the
% previously defined data types. These data types come in a few flavors and their use
% depends on the goal of the task at hand. We will cover these data classes with
% increasing order of complexity, (from my, Khris, perspective). It should be noted
% that usage of each of these data classes is up to you, but we will point out why
% certain classes are better for some tasks.
%
%%%
% The container classes we will cover are:
%
% 
% * |cell|
% * |table|
% * |struct|
% * |function_handle|
% * |containers.Map| (Map Containers)
% 
%
%% Cells
% Cells are an extension of the numeric array and offer the ability to array-ify
% anything. Like every array in MATLAB, cells can be any size or dimension and cell
% arrays can be indexed just as any other array through subscripted referencing and
% linear indexing. A cell may hold any value, or array, or another container class.
% That is, a cell array contains indexed data containers. We can construct a cell
% array with curly-braces |{}| or by creating an empty array with the |cell()|
% function and populate each cell by indexing with |{}|. For instance:
%

%!
% create using {}
c = { ...
  42; ...
  rand(5); ...
  "a sring"; ...
  {'another cell with chars'}; ...
  @()disp("And a function handle!") ...
  };
% index using {}
c{1}
c{end}() %<- use parentheses after to call the internal function
c{end-1}
c{4}{1} %<- access nested cell's contents

% create empty cell array with cell()
cArray = cell(2,2,3);
cArray{1,2,2} = "Random string in 1st row, second column, second page"

whos('c','cArray')

%%%
% Cells are great for organizing data which may or may not be the same type, shape,
% or size. However, note that cells are organized by position. If you had many
% differnt items stored in cells, you may also have to keep a lot of positional
% information in your mind. If a reader encounters a cell array, from looking at the
% variable alone, they may not know precisely the importance of each cell.
%
% Note, we can index cell arrays with |()|, however it will return a cell. For
% example:
%

%!
c(3) % returns cell
c{3} % returns cell's contents

%%%
% Sometimes |cell| arrays are returned from a function, such as |arrayfun()|, but the
% contents of each cell are the same type. We can easily convert the data in the
% array to an array of the content type. For example, if we perform an iterative
% function using |arrayfun()| to generate sine waves, the resulting numeric arrays
% are contained in cells. We use a few approaches to convert the cell contents into a
% matrix.
%

%!
rng(120)
time = (0:1/1000:1.2).';
amps = randi([1,5],10,1);
freqs = linspace(0.5,5.0,10).';
sineWaves = arrayfun( ...
  @(a,f) a.*sin(2*pi*f .* time), ...
  amps, freqs, ...
  'UniformOutput',false ...
  ) %-> 10 by 1 cell array

%%%
% The first approach is to simply concatenate the contents of all cells in the array
% by curly-brace indexing and enclosing the contents in square-brackets |[]|. This
% will perform horizontal concatenation by default. If we wanted to vertically
% concatenate, we could use the |cat()| function. Note: this method only works if the
% contents of all the cells are compatible dimensions for the desired concatenation.
% That is, we cannot horizontally concatenate two vectors with differing numbers of
% rows.
%

%!
% concat horizontally
sineWaves_h = [sineWaves{:}];
% concat vertically
sineWaves_v = cat(1,sineWaves{:});
% concat in 3d
sineWaves_z = cat(3,sineWaves{:});

disp("        r             c           z")
disp(size(sineWaves_h))
disp(size(sineWaves_v))
disp(size(sineWaves_z))

%%%
% Another approach is to use one the |cell2~~~| functions shown below.
%
%%%
%
% * <https://www.mathworks.com/help/matlab/ref/cell2mat.html |cell2mat|>
% * <https://www.mathworks.com/help/matlab/ref/cell2struct.html |cell2struct|>
% * <https://www.mathworks.com/help/matlab/ref/cell2table.html |cell2table|>
%

%!
sineVec = cell2mat(sineWaves); %-> 12010 by 1 vector
sineMat = cell2mat(sineWaves.'); %-> 1201 by 10 matrix
sineStruct = cell2struct(sineWaves,sprintfc('sine%02d',1:10));
sineTable = cell2table(sineWaves.','variablenames',sprintfc('sine%02d',1:10));

%%%
% For |cell2table|, the result is not formatted in the way we would use a table. In
% order to put the data in a table format, given the input value, we would have to
% operate again on the cell array, or change the function output of |arrayfun|. For
% example:
%

%!
% convert each numeric array to a cell array
sineCells = cellfun(@num2cell,sineWaves,'UniformOutput',false);
% now horizontally concatenate the cell arrays and produce the table
sineTable = cell2table([sineCells{:}],'variablenames',sprintfc('sine%02d',1:10));

%%%
% There are many uses for cells that we will explore as we go along, and the examples
% above are the most common we encounter. See the table of functions for working 
% with cells below.
%
% <<lib/img/cellOperations.png>>
%
%%%
% One last note about cells that makes them so useful. When we access the contents of
% multiple cells, they are returned as separate outputs, much a like a function
% returns multiple outputs, e.g., |[mValue,mIndex] = max(A);|. So if we wanted to use
% cell contents as different inputs to functions, we can use curly-brace indexing. We
% can also extract multiple cell's contents to multiple variables.
%

%!
rng(1001);
args = {2,'omitnan'};
d = randn(10,5) + randi([10,30],1,5);
testMean = mean(d,args{:}) % expanding args -> mean(d, 2,'omitnan')

% or:
[dim,nanflag] = args{:}
mean(d,dim,nanflag)

%% Tables
% Tables are organized much like a spreadsheet in Excel (R) but have some specific
% rules. In MATLAB, |table| objects have both row and column names (though row names
% are optional while column names are not). We access data in a |table| by
% subscripted referencing with column names instead of column numbers. We can also
% use a form of indexing called dot-indexing. This is a shorthand referencing style
% that allows for easy access to nested variables. More on nesting when we discuss
% |struct| objects.
%
% MATLAB considers the columns of a table as individual variables and thus each
% column must contain the same data type, but adjacent columns can contain different
% data types. This allows us to put different data types together that are linked
% row-wise. For example, we can construct a table with grouping, independent, and
% dependent vectors as variables.

%!
rng(12345);
groupTable = table( ...
  repelem(["a";"b"],3), ...
  repmat((1:3)',2,1), ...
  reshape(sort(randn(3,2) + [10,20],1),[],1), ...
  VariableNames= {'Groups','X','Y'} ...
  )

%%%
% Alternatively, we could dot-indexing to construct the table:
%
%   groupTable = table();
%   groupTable.Groups = repelem(["a";"b"],3);
%   groupTable.X = repmat((1:3)',2,1);
%   groupTable.Y = reshape(sort(randn(3,2) + [10,20],1),[],1);
%   disp(groupTable)
%
%%%
% We can then access data in the table by subscripted referencing or dot-indexing:
%

%!
groupTable(1:3,'Y')
groupTable.Y(1:3)

%%%
% If we use subscripted referencing to gather multiple columns, the method with
% return a subset of the table. This is useful if you're looking for data that
% corresponse to certain conditions of a single row. In our example table, if we
% wanted to extract all data corresponding to the |b| group, we could do the
% following:
%

%!
bData = groupTable( groupTable.Groups == "b", : )

%%%
% Tables have a very extensive set of methods (functions) associated with them. See
% the documentation at <https://www.mathworks.com/help/matlab/tables.html> for more
% information. We use |table| objects quite a bit, but not to their fullest extent.
% Generally, we will use tables for storing data of different types, as described 
% above. 
%
%% Structs
% The |struct| object is one of the most versatile data class in MATLAB and has the
% added benefit of being a good introduction to object oriented programming (OOP).
% Like |table| objects, structs store data in internal variables, called |fields|.
% The key difference from |table| objects is that |struct| objects don't link values
% across variables. If tables are like spreadsheets, structs are like backpacks where
% each compartment is labeled and possibly even has internal compartments. We can
% build arrays of |struct| objects, and we use this quite often. Let's first look at
% an example of a scalar struct with nested structs.
%

%!
rng(3210);
S = struct();
S.data = struct(X= linspace(0,1,100).',Y= randn(100,5)+randi([10,40],1,5));
S.label = "Random Data";
S.date = datestr(now);

% show S structure
disp(S)

%%%
% We often use fields of structs to hold summary data, metatdata, and other
% information about the actual data stored. A |struct| field may hold any data type
% and each field is independent of any other field, thus size and shape are also
% arbitrary. We can add fields to the |struct| object, though field names must adhere
% to MATLAB's variable naming rules.
%

%!
S.summary = struct( ...
  columnMeans= mean(S.data.Y,1), ...
  rowMeans= mean(S.data.Y,2), ...
  columnDomain= [min(S.data.Y);max(S.data.Y)] ...
  );

disp(S.summary)

%%%
% Arrays of |struct| objects have only the stipulation that every struct in the array
% has the same field names. This is useful when containing information about multple
% devices. For example:
%

%!
amp = struct( ...
  name= "Axopatch200B", ...
  setting= struct(Gain=1,Mode="CC",Filter=5000) ...
  );
led1 = struct( ...
  name= "LED 505nm", ...
  setting= struct(Amplitude=0.1,Units="V",Duration=10) ...
  );
led2 = struct( ...
  name= "LED 405nm", ...
  setting= struct(Amplitude=0,Units="V",Duration=0) ...
  );
devices = [amp;led1;led2];
% save devices, or store devices in another struct for saving....
devices
devices(2)
devices(2).setting

%%%
% If we call a field on a |struct| array without indexing into the array first, the
% values from each element in the array are returned as if the were the contents of
% multiple cells, that is as separate outputs:
%

%!
devices.name % show all 3
[devices.name] % capture as array
[aName,l1name,l2name] = devices.name % capture in multiple variables

%%%
% Useful functions for working with structs are shown in the table below:
%
% <<lib/img/structOperations.png>>
%
%% Function Handles
% The term, Handle, in MATLAB refers to an object with a pointer. That is, |handle|
% class objects are persisted in a single place in memory, when copied through
% assignment, these objects are actually not copied, just a pointer with a new name
% is created. This sounds complicated, but in the case of function handles, it just
% means we can give functions new names, or create anonymous functions that modify
% other functions.  Indirectly calling a function enables you to invoke the function 
% regardless of where you call it from. Typical uses of function handles include:
%
%%%
%
% * Passing a function to another function (often called function functions).
% * Specifying callback functions (for example, a callback that responds to a UI 
% event or interacts with data acquisition hardware).
% * Constructing handles to functions defined inline instead of stored in a program 
% file (anonymous functions).
% * Calling local functions from outside the main function.
% 
% You can see if a variable, |h|, is a function handle using 
% |isa(h,'function_handle')|.
%
% Consider the |cellfun| and |arrayfun| functions we have used 
% previously. These functions accept a |function_handle| as a first input argument.
% We have both used an anonymous function and provided a builtin function for this
% argument. In both cases we preceded the name or signature with the |@| sign. 
%

%!
o = @ones; % assign o the function ones
o(2) % use o like ones()

isa(o,'function_handle')

% make new reference
o2 = o
o2(1,2) % use like ones()

% compare handles
isequal(o2,o)

%%%
% Below is a list of functions for creating and working with the |function_handle|
% class.
%
% <<lib/img/functionhandles.png>>
% 
%% Final Remarks
% The data types above are not the only classes or containers that are available in
% MATLAB. The ones we've discussed are the basic classes that we will encounter most
% often. Note that a number of other data and contianer classes exist that we will
% encounter and at that time we will describe them better. For the most part we will
% not use data classes like |sparse| matrices, but we will use the |containers.Map|
% storage container, but first need to understand some OOP principles. So, at this
% point, we should be considering the usefulness of a particular class for a
% particular task.
%
