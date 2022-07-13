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
% hold the data.
% 
% We can check a items type by using the |class| function.
%

%!
class(true)
class(10)
class(uint8(32))
% note that MATLAB will cast logicals to double, violating the general rule of
% down-casting, when they are operated on as if they are numeric, e.g. addition
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
% 
%% Logical Type
%
%% Strings And |char| Arrays
%
%% Containers
% As |numeric|, |logical|, |string|, and |char| data types can be made into arrays,
% it is often useful to organize these arrays in such a way as to produce tidy,
% accessible data. This is where the other data types come in. It should be noted
% that the container types can also hold other or nested container types, though we
% will not really cover this practice here. In futures sections, we will show how
% arrays and nests of structs may be useful for storing data.
%
% 

