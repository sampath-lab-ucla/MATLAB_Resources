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
% sum and count of |values|, respectively. Use these variable to then calculate the 
% mean of |values| and store the answer in a variable named |meanValues|. Disply the 
% output using |disp|. Recall that, generally speaking the arithmetic mean is 
% calculated by:
% 
% $$\bar{x}=\frac{1}{N}\sum_{i=1}^{N}x_i$$
% 
% where $i$ is the index and 
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
% We often need to perform some operation iteratively and keep track of the result
% generated on each iteration. The best way (at least in terms of readability) is to
% first initialize the storage variable and then populate it iteration by iteration.
% Generally speaking, we tend to have some idea how many iterations we will need for
% a process like this and so the |for| loop is usually the best approach.
% 
% To initialize a storage variable we simple create the variable with the appropriate
% type and size. For this example we will assume we have the following data matrix
% and we want to compute an average of each row.
% 

%!
rng(1984)
dataMatrix = randn(5,10) * 2 + ((1:5).^2).';
figure("color",[1,1,1]);
axes("nextplot",'add');
plot(1:5,dataMatrix,'-.o');
xlabel("Index");
ylabel("Value");

%%%
% Now, we can initialize our storage variable which will be a 5 element column
% vector. We can initialize it with any numeric value, it is good to make sure the
% initializing value won't interfere with any operations. In MATLAB, we can simply
% initialize as an empty matrix, i.e., |A = []|, but this doesn't allocate space in
% memory. Instead, since we know we are using numeric values, let's create an array
% of |NaN|, which are double-precision (see Data Types in the next module)
% not-a-number values.
%

%!
nRows = size(dataMatrix,1); % calculate the number of rows we will analyze
rowMeans = nan(nRows,1); % initialize
for row = 1:nRows % iterate of the row indices
  rowMeans(row) = mean(dataMatrix(row,:));
end
% append the line to the plot in thicker red
line(1:5,rowMeans,'color','r','linewidth',2,'marker','x');

% compare to builtin function
isequal(rowMeans,mean(dataMatrix,2))

%%% *Task 2* 
% 
% Use the defined data vector, |datVec|, and grouping variable, |grpInds|, below.
% Produce a |groupMeans| column vector of means from |datVec| based on the |unique| 
% groups in |grpInds|. Store the unique groups in a variable called |groups|.
%

%!
rng(2022); % random seed
% construct random normal data vector
datVec = reshape(randn(10,5) * 2 + ((0:5:20).^2),1,[]); %row vector
% construct ordered grouping
grpInds = reshape(ones(10,1) * (1:5),1,[]);
% shuffle data
shuffleInds = randperm(50);
datVec = datVec(shuffleInds);
grpInds = grpInds(shuffleInds);
% plot the data
figure("color",[1,1,1]);
axes("nextplot",'add');
plot(grpInds,datVec,'ko');

%@
groups = unique(grpInds);
nGroups = numel(groups);
groupMeans = nan(nGroups,1);
for g = 1:nGroups
  group = groups(g);
  grpData = datVec(grpInds == group);
  groupMeans(g) = mean(grpData); %populate storage
end

%!
% use line() to add the group means to plot
line(groups,groupMeans,'linestyle','none','color','r','marker','+','markersize',12);
xlabel("Index");
ylabel("Value");

%% Loop execution control
% *|break|*
% It is often useful to terminate a loop early, or to skip an iteration based on  
% some desired condition. To exit out of a loop entirely, we can use the |break;| 
% statement. Usually we would break a loop when some condition is met. For example, 
% we might setup a while loop to run until we encounter an particular condition
% 
%   while true
%     result = 1/randn(1); % may result in Inf
%     if isinf(result)
%       break;
%     end
%   end % end of while
%
%%% *Task 3*
% 
% Generate a Gaussian random row vector, |A|, of 1000 elements. Iterate over the 
% values of |A| until the value exceeds the interval $\[-2,2\]$. Report the 
% iteration number and the value that first exceeds the interval.
% 

%!
rng(1024)
%@
A = randn(1,1000);
for iter = 1:numel(A)
  value = A(iter);
  if abs(value) > 2
    disp("Iteration:");
    disp(iter);
    disp("Value:");
    disp(value);
    break;
  end
end

%%% 
% *|continue|*
% To force skip to the next iteration of the loop, we can use the 
% |continue;| statement. Typically we would |continue| based on some condition not 
% met by the iteration. A real world example would be selecting files from a folder 
% of data, we may encounter a data file that isn't the correct format or type. We   
% would want to skip that file. It might look something like this:
%
%   fileList = dir("*.mat");
%   for file = fileList'
%     S = load(file.name);
%     % Check for a DATA variable
%     if ~isfield(S,'DATA') % read: if 'DATA' is not a field of S
%       % No DATA varaible so skip this file
%       continue;
%     end
%     % the code below only runs when DATA is detected
%     % plot data
%     figure();
%     % for example, assume the DATA variable contains fields X and Y
%     plot(S.DATA.X, S.DATA.Y,":");
%     % add the file name to the plot title
%     title(regexprep(file.name,"_"," ")); %replace "_" with " "
%   end
% 
%%%
% In the above example, we use a conditional statement to validate the loaded file. 
% In future lectures we will dive into conditional programming much deeper. For now, 
% suffice it to say, you'll need to be able to readily combine tools and develop a 
% habit of testing your code often.
% 
%%% *Task 4*
%
% Create a loop that selective displays whole numbers in a sequence from 1 through 
% 50 that are divisible by 7.
% 

%@
for num = 1:50
  if mod(num,7)
    disp(num)
  end
end

%% Vectorized Operations
% As we saw in the Array Math module, MATLAB(R) has a number of built-in features 
% that allow for easy manipulation of data. So far, we have been talking about 
% looping over vectors and producing either a new value for each iteration, a 
% cumulative value updated at each iteration, or displaying some value. In the 
% following section, we will combine these principals to generate a simple analysis. 
% 
% 