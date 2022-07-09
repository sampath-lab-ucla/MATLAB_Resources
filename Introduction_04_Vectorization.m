%% Introduction To Iterations And Vectorization
% In this document we will cover the basics of iterative coding.
%%% 
% Often, it is desirable to recycle a piece of code, or apply some operation 
% to each element of an array. As we saw in the introductory materials for array 
% operations, there are a number of built-in ways MATLAB provides for 
% achieving even complex cases of iterative coding. These built-in methods are 
% examples of how MATLAB is a vectorized language. That means you can simply call 
% the function or operator on the array it will perform it along a specified dimension. 
% In other programming languages, vectorization is a task for the coder. For the 
% Python aficionado, you would know this from the iconic list expansion or list 
% comprehension, which is just a for loop wrapped in syntactic sugar. I digress.
% 
% Although most of the vectorization is handled by MATLAB, there are cases where 
% vectorization is simply not possible or optimal. So it is important to understand 
% how to iterate an operation and produce an organized looping algorithm. Let's 
% get to it.
%% Loops that update a value
% If you were given the task to sum a set of values and you were not allowed to use a
% built-in function to do so, such as |sum|, you might be tempted to simply add all
% the values up with the |+| operator. This would be very tedious for sets with many
% elements and prone to human error (the most common error). Let's say you were given
% 100 random integers in a variable called |values| and you were tasked with summing
% them all and storing the sum in a variable called |summedValues|.
%


%!
rng(1925);
values = randi([1,20],100,1); % column vector

%%% 
% With the principals of indexing you might be tempted to do something like:
%

%!
summedValues = 0; % initialize the variable as 0
summedValues = summedValues + values(1);
summedValues = summedValues + values(2);
summedValues = summedValues + values(3);
summedValues = summedValues + values(4);
summedValues = summedValues + values(5);
summedValues = summedValues + values(6);
% and so on...

%%% 
% In the end you would have 101 lines of code that looked incredibly similar, and
% your hand might be cramped from all the copy-paste actions.
% 
% Enter, *Loop Control Statements*!
%
% Loop control statements allow repeated execution of a block of code. MATLAB (R) has
% 2 types of loops, the for-loop and the while-loop. These loops are designated
% conveniently with the keywords |for| and |while|. As with any other keyword in
% MATLAB, they must be terminated with an |end| keyword. This means any code placed
% between |for| or |while| and the next |end| will be repeatedly run until either the
% number of iterations is reached, or until a watched condition changes. For example,
% we will use each loop type to demonstrate the differences between |for| and |while|
% loops.
%
%%% *FOR*
%
% |for| statements loop a specified number of times, keeping track of an iterator
% varaible with each iteration. Usually we consider this as an incremental iteration,
% but that kind of nomenclature hides the full power of the for loop iterator
% variable.
%
% With the |for| loop, we can set the iterator to just about anything we want. In
% this case, we want the iterator variable, which we'll call |iterator|, to simply
% become the indexing value for each of the indices in our |values| vector.
% 


%!
summedValues = 0; % re-initialize
for iterator = 1:numel(values) % iterator will be 1, then 2, ..., then numel(values)
  summedValues = summedValues + values( iterator );
end

% compare with the builtin function:
isequal(sum(values),summedValues)

%%%
% Notice how we update |summedValues| on each iteration just as we did above but
% stimply used an iterator instead of rewriting the code with only the index changed.
% We can use |for| in another way as well. In MATLAB, the iterator variable is
% defined by a row vector, that is it will only iterate in a row-wise manner. Armed
% with this information let's reduce our code footprint slightly.
% 

%!
summedValues = 0; % re-initialize
for value = values.'
  summedValues = summedValues + value;
end

% compare
isequal(sum(values),summedValues)

%%% 
% Notice how we can transpose |values| into a row vector and then the iterator,
% |value|, simple becomes each value, on after the other, until the last |value| in
% |values| is used.
%
%%% *WHILE*
% 
% |while| statements allow repeated execution of a block of code until the
% while-condition is false. That is, while some condition is |true|, run the code
% block over and over.
% 
% Now, you will see the following |while| loop construction a lot, but it is a stupid
% example of the power of |while| loops.
%

%!
summedValues = 0; % re-initialize
stupidUnnecessaryIterator = 1;
while stupidUnnecessaryIterator <= numel(values)
  % use the stupidUnnecessaryIterator as index to update sum
  summedValues = summedValues + values( stupidUnnecessaryIterator );
  % increment the stupidUnnecessaryIterator by 1
  stupidUnnecessaryIterator = stupidUnnecessaryIterator + 1;
end

% compare
isequal(sum(values),summedValues)


%%% 
% The above example is stupid, it is so much more work and way less readable that
% simply using a |for| loop. A better example is provided below. See if you can tell
% what is going on.
%


%!
valueCopy = values; % make copy of values to perform nondestructive analysis
summedValues = 0; % re-initialize
while ~isempty(valueCopy) % while valueCopy is not empty
  % update with the first index
  summedValues = summedValues + valueCopy(1);
  % drop the first index of values
  valueCopy(1) = [];
end

% compare
isequal(sum(values),summedValues)

%%% *Task 1*
% 
% Using a for loop, update two variables called |sumValues| and |valueCount| with the
% sum and count, respectively, of values. Use these values to then calculate the 
% mean of |values| and store the answer in a variable named |meanValues|. Disply the 
% output using |disp|. Recall that, generally speaking the arithmetic mean is 
% calculated by % $\bar{x}=\frac{1}{N}\sum_{i=1}^{N}x_i$ where $i$ is the index and 
% $N$ is number of elements in $x$.
%


%@
sumValues = 0;
valueCount = 0;
for value = values'
  sumValues = sumValues + value;
  valueCount = valueCount + 1;
end

% calculate the mean
meanValues = sumValues / valueCount;

%!
% compare with builtin function
isequal(mean(values),meanValues)

%% Loops that calculate a new value
% Often we need to perform some operation iteratively and keep track of the result
% generated on each iteration. The best way (at least in terms of readability) is to
% first initialize the storage variable and then populate it iteration by iteration. 
% 




