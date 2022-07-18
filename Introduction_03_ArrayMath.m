%% Mathematical Operations On Arrays
% In this document we will focus on mathematical and statistical operations on arrays. 
% 
%% Array Operations
% There are many operators that behave in element-wise manner, i.e., the operation 
% is performed on each element of the array individually. _In future sections we 
% will discuss how to perform these actions using a low-level approach._  MATLAB (R) 
% is a language designed around the principals of a Matrix Calculator, hence 
% MATRIX LABORATORY. In fact, before 1984, MATLAB was simply a wrapper for some 
% Fortran subroutines from matrix operations. MATLAB became a language in 1984 (and 
% a commercial product) but the principals of matrix operations remained at the 
% core. In the following sections, we will cover a number features stemming from 
% these principals.
% 
%% Mathematical Functions
% Among the vast number of functions that come pre-packaged with MATLAB are 
% functions which have a sole purpose of performing mathematical operations. Such as 
% taking $sine(\theta)$, or computing some statistical summary like $\bar{X}$. The 
% major advantage the MATLAB has over other languages is the automatic vectorization 
% of these functions. That is, if the input to the mathematical function is a 
% matrix, then the result is a matrix of the same size with the function applied to 
% each element. For example, 
% 
% <<lib/img/mathMatrix.png>>
% 
% To understand how this works, let's make a sine wave using the 
% <https://www.mathworks.com/help/matlab/ref/sin.html |sin|> function and plot it as 
% a function of time.
% 
% To make a sine wave, we use the following mathematical formula, 
% 
% $$y(t)=A\sin(2\pi f t+\varphi)$$
% 
% Where $A$ is the amplitude, $f$ is the frequency in Hertz, $t$ is the timepoint 
% and $\varphi$ is the phase angle in radians.
% 
% Let's make a sine with an amplitude of 2, a frequency of 1Hz, and 0 phase shift, 
% which lasts for a duration of 2 seconds and is sampled at a frequency of 100Hz.
% 


%!
f = 1; % Hz
duration = 2; % seconds
dt = 1/100; % 100Hz
shiftAngle = 0; % rad
amplitude = 2;

%%% Task 1 Create a time vector column, |t|, and use it to produce the desired sine 
% wave, |y|.
% 

%@
t = (0:dt:duration)';
y = amplitude * sin( 2 * pi * f * t + shiftAngle );

%%% Task 2 Plot the sine wave against the time vector. Label the X and Y axes 
% accordingly.
% 


figure;
axes("NextPlot",'add');

%@
plot(t,y);
ylabel("Y");
xlabel("Time (sec)");

%% Matrix Scalar Expansion
% In the above example, we were able to simply use the multiplication operator, |*|, 
% and multiply the $2\pi$ to the frequency and the time vector and then add the 
% shiftAngle. What is left invisible is the implicit expansion of each of those 
% operations against the time vector. If MATLAB didn't make this invisible, the only 
% way to perform that above action would be to manually apply the multiplication and 
% addition operations to each of the time vector elements, and then apply the |sin()|
% function in the manner similar to what is shown below:
% 
%   y(1) = amplitude * sin( 2*pi * f * t(1) + shiftAngle);
%   y(2) = amplitude * sin( 2*pi * f * t(2) + shiftAngle);
%   % and so on...
% 
% Thankfully, MATLAB takes care the implicit expansion for us. In the case of one 
% variable being an array and the other being scalar, this is called *Scalar 
% Expansion*, and the operations takes the following form:
% 
% <<lib/img/scalarExpansion.png>>
% 
% For example, we could produce the internal vector for the sine wave like so:
% 


%!
ft = 2 * pi * f * t + shiftAngle;
figure;
axes("NextPlot",'add');

plot(t, amplitude * sin(ft) );
ylabel("Y");
xlabel("Time (sec)");

%%% Task 3 
% Create and plot a second sine wave (like the example above) that is $90^{\circ}$ out of phase with the one above.
%

%@
hold on;
ft2 = ft + pi;
plot(t, amplitude * sin(ft2), 'r');

%% Element-Wise Operations
% MATLAB has a special operator which forces it to perform an element-wise 
% operation. Generally speaking, MATLAB will try to automagically figure out your 
% intent and produce a warning or error when you've used the wrong operator. 
% Nevertheless, it is important to avoid errors and simply practice the correct 
% technique.
% 
% <<lib/img/elementWiseOperation.png>>
% 
% To demonstrate this principal, if we wanted to create a chirp-like sinusoid, we 
% can create our sine with a squared time vector:
% 


%!
tSquared = t.^2;

%%% 
% Note that if we were to run |t^2| we would get the following error:
% 
% <<lib/img/matrixPowerError.png>>
% 
%%% Task 1 Let's create a sine and cosine using the |tSquared| variable as we made |y| earlier. Let's call the new variables |ySquared| and |zSquared|.
% 

%@
ySquared = amplitude * sin( 2 * pi * f * tSquared + shiftAngle );
zSquared = amplitude * cos( 2 * pi * f * tSquared + shiftAngle );

%!
% Now plot:
fig1 = figure;
ax1 = axes(fig1,"NextPlot",'add');
ax1.YLabel.String = "Y";
ax1.XLabel.String = "Time (sec)";

line(t,ySquared.*zSquared,'color',[0,0,0]);

%%%
% Note: We are using the |line| function instead of |plot|? |line| is the low-level
% version which gives you more control over the plotting mechanisms. Have a look at
% |doc line| for more information.
%
%% Implicit/Explicit Expansion
% Another form of implicit expansion occurs when two arrays with a shared 
% dimensional size are operated on.
% 
% <<lib/img/implicitExpansion.png>>
% 


%!
sequence = reshape(1:20,10,2)
dualSequence = sequence ./ [1,10]

%%% Task 1 
% Using implict expansion, create a 5x3 matrix A, where the 3 columns are filled 
% with the values 1, 2 and 3.
%

%@
A = zeros(5,1) + [1, 2, 3]

%%% Task 2 
% Create another 5x3 matrix B where the first row is like in A, the second 
% row is 1/2 A, the third row is 1/3 A, and so on until the fifth row is 1/5 A.

%@
B = A ./ (1:5)'

%%%
% Explicit expansion is sometimes required by a desired operation. Explicit expansion
% takes the same form as element-wise operations. The difference here is you might
% have a vector and matrix and you might want to perform an operation that is not
% supported by implicit expansion (note: there are very few of these cases in modern
% MATLAB versions). For example, suppose you wanted to take a row vector |A| and repeat
% it 5 times in a columnar orientation.
%


%!
% Get just the first row of A
rowA = A(1,:);

%%%
% Above, we used implicit expansion and asked MATLAB to simply add the row |[1,2,3]|
% to a 5-element column of zeros. MATLAB created the desired |5x3| matrix implicitly.
% What if you already had a matrix of zeros, say |z = zeros(5,3);|? MATLAB would,
% again, automatically imply that the row should be added to each column for every
% row. We can check this in the following way:

%!
z = zeros(5,3); % zeros matrix
matA = z + rowA;

%%%
% If we expand |rowA| into the same sized matrix as |z|, then the |plus| operation
% will continue in an array-like fashion (element-wise) and we have performed
% explicit expansion.
% 

%!
expandedA = repmat(rowA,5,1);
% alternatively, we can use matrix multiplication
matrixMultA1 = ones(5,1) * rowA;
matrixMultA2 = ones(5,1) .* rowA;

% expandedA is the result, we can still add it to z if we want
isequal(        ...
  A,            ... % double implicit
  matA,         ... % single implicit
  expandedA,    ... % repeated matrix
  matrixMultA1, ... % outer product (mtimes)
  matrixMultA2, ... % outer product (times)
  expandedA + z ... % element-wise addition
  )

%%% 
% Can you think of why the matrix and array multiplications are producing the same
% result when used this way?
%
%% Calculating Statistics Of Vectors
% Common Statistical Functions
% 
% <<lib/img/commonStatsFunctions.png>>
% 
% Using |min| and |max|
% 
% <<lib/img/usingMinMax.png>>
% 
%
%   A = [1 2 3; 4 5 6];
%   M = min(A);
%
% Furthermore many of the built in statistical functions will return the index as 
% the second output:
%
%   [M, I] = min(A);
%
% Remember to read the MATLAB help pages for info on the specific functions that you 
% want to use. 
%
% *Ignoring NaNs*
% When using statistical functions, you can ignore NaN values by supplying the 
% |"omitnan"| flag as an input argument.
% 
%   avg = mean(v,"omitnan")
%
%%%
% Some statistical operations seemingly ignore |NaN|s altogether.
% 
%   absValues = abs(values);
% 
% And others cannot work with any |NaN|s.
% 
%   isOddNum = mod(nan(1,1),2);
% 
%% Statistical Operations on Matrices
% Some common mathematical functions which calculate a value for each column 
% in a matrix include:
% 
% <<lib/img/statsOperations.png>>
%
% For example:
%  


%!
A = [1 2; 2 3; 4 5; 6 7];
M = median(A);


%%% 
% Many statistical functions accept an optional dimensional argument that specifies 
% whether the operation should be applied to columns independently (the default) 
% or to rows.
% 
% <<lib/img/matrixDimensions.png>>
% 
%%%
% Notice the implicit expansion used below.
%


%!
rng(12345);
A = randn(100,3); % note this overwrites previous definition of A

% set A to have all have std of 1
A = A ./ std(A);

% set A to have std of 2,10,3
A = A .* [2,5,3];

% set A column means to 20,0,10
A = A + [20,0,10];

% calculate mean and std (by default stats are calculated down columns)
meanA = mean(A);
stdA = std(A); 

%%%
% Below is a more advanced way of plotting. We will begin to use advanced plotting
% techniques in examples to give more and more exposure to plotting mechanisms. Take
% notes, inspect the code, play with it and see if you can start making your plots
% nicer and nicer.

%!
% Plot
fig = figure('Color',[1,1,1]);
ax = axes(fig);
ax.NextPlot = 'add'; % like hold(ax,'on')
ax.XLabel.String = "A";
ax.YLabel.String = "Count";
hists = gobjects(1,3);
hists(1) = histogram(ax,A(:,1),'BinMethod','fd'); % blue
hists(2) = histogram(ax,A(:,2),'BinMethod','fd'); % orange
hists(3) = histogram(ax,A(:,3),'BinMethod','fd'); % yellow
% force update of drawing
drawnow();
% get the current range of the y limit
yAxisRange = diff(ax.YLim); % ylim(2) - ylim(1);

% Draw lines at means of histograms
% note: will talk about for loops next
for idx = 1:size(A,2)
  % Draw |-| at std of each mean and vertical line at mean
  eb = meanA(idx) + [-1,1].*stdA(idx);
  line( ...
    ax, ...
    [eb([1,1,2;1,2,2]),meanA([idx,idx])'], ... % X
    [yAxisRange .* (0.98 + [1,0,1;-1,0,-1] .* 0.02),ax.YLim.'], ... % Y
    'linewidth',1, ...
    'color',ax.ColorOrder(idx,:), ...
    'handlevis', 'off' ... % hides from legend
    );
  % update histogram label
  hists(idx).DisplayName = sprintf("$\\mathcal{N}(%2.0f,%2.0f)$",meanA(idx),stdA(idx));
end
legend(ax,'Location','northwest','Interpreter','latex');

%%%
% What do you notice about the bin sizes of the histograms?
% 
%% Matrix Operators
% Now that we have an understanding of how MATLAB auto-magically vectorizes
% operations for us, the table below gives a list of operators and their purpose for
% *matrix* operations.
%
% <<lib/img/MatrixOperators.png>>
% 
%%%
% *Compatibile sizes*
% 
% Most binary (two-input) operators and functions in MATLAB(R), e.g., |dot(A,B)| or |A * B|, 
% support numeric arrays that have compatible sizes. Two inputs have compatible sizes
% if, for every dimension, the dimension sizes of the inputs are either the same or 
% one of them is 1. In the simplest cases, two array sizes are compatible if they 
% are exactly the same or if one is a scalar. MATLAB implicitly expands arrays with 
% compatible sizes to be the same size during the execution of the element-wise 
% operation or function.
% 
% For 2D arrays, here are some combinations of scalars, vectors, and matrices that
% have compatible sizes:
%
% <<lib/img/compatibleArrays.png>>
%
%%%
% In the case of our inner product example above, we can utilize MATLAB's implicit
% expansion rules and compute a vector of dot products of row vector |A| with matrix
% |B|, given |B| has as many rows as |A| has columns.
%
%%%
% Based on the above diagram of compatible sizes, we can do a number of other
% operations that may not be obvious. In the previous module we discussed implicit
% versus explicit operations. The 
%% Array Operators
% The syntax for element wise operations is slightly different. It is recommended to
% use the correct syntax for the element wise operation even when performing implicit
% expansion operations. Below is a table of array (element-wise) operators.
%
% <<lib/img/ArrayOperators.png>>
%
%% Matrix Multiplication
% Matrix multiplication requires that the inner dimensions agree. The resultant 
% matrix has the outer dimensions.
% 
% <<lib/img/matrixMult.png>>
% 
%%%%
% The following code:
% 
%   X = [1 2; 3 4; 5 6];
%   Y = [7; 8; 9];
%   Y * X
%
%%% 
% *Gives the error:*
%
%   Error using  * 
%   Incorrect dimensions for matrix multiplication. Check
%   that the number of columns in the first matrix
%   matches the number of rows in the second matrix. To
%   operate on each element of the matrix individually,
%   use TIMES (.*) for elementwise multiplication.
%
%%%
% But the following expression _works_ because we transpose (|.'|) the |Y| vector.
%
%   Y.' * X
%
%%%
% We will cover more about matrix operations in the *Vectorization* course.
%
%% Solving Systems of Linear Equations
% Some useful operators are the 
% <https://www.mathworks.com/help/matlab/ref/mrdivide.html |/|> and 
% <https://www.mathworks.com/help/matlab/ref/mldivide.html |\|> 
% operators. With these operators, one can quickly solve linear equations, e.g., fit 
% a line to a dataset. In future handouts, we will use this fast method for a number 
% of applications. 
% 
% <<lib/img/linearEquation.png>>
% 
% Note, the above graphic relates the coefficient matrices, |A| and |B|, to the 
% solution matrix |x| by solving the unidirectional matrix multiplication. The
% directionality depends on the operater used.
% 
% For our purposes, we can consider some independant variable |t|, and some 
% dependent variable |R|, and solve for the linear coefficients 
% $(\beta_0,\, \beta_1)$ of the following equation:
% 
% $$R(t)=\beta_0+\beta_1 t$$
% 
% To calculate the linear estimates by the Least Squares method, we can use the 
% backslash (<https://www.mathworks.com/help/matlab/ref/mldivide.html |mldivide|>) 
% operator.
% 
% First, we construct the |t| and |R| vectors:
% 


%!
t = linspace(0,1,8).'; % transpose into a column
R = [ ...
  0.123; ...
  0.57; ...
  0.847; ...
  1.134; ...
  1.345; ...
  1.443; ...
  1.921; ...
  2.298 ...
  ]; % manually create a column


%%%
% Then we can get the Least Squares solution to |c*T=R| by creating the matrix |T| 
% with two columns, 1 for each of the $\beta$ coefficients:
% 


%!
T = [ones(size(R)), t];


%%%
% From here we calculate the coefficients |c| with the |mldivide| operator:
% 


%!
c = T \ R

%%%
% Note that the above operation is equivalent to calculating the coefficients using
% the Gram and moment matrices:
% 
% $$\hat{\beta}=(X^{\top}X)^{-1}X^{\top}y,$$
%
%%%
% where $\hat{\beta}$ is the vector of coefficients for the least-squares fit.
%
%%%
% Where the linear system is fit as |R = c(1) + c(2)*t| (note: |t| not |T|). We can 
% then create an interpolated, or super-sampled line by creating a new |t| vector 
% with more points, let's call it |tSuper|.
% 


%!
tSuper = linspace(0,1,100)'; %column vector


%%%
% We can then create the estimated line in a few ways. For consistency, let's create 
% it using the matrix system of linear equations first. To do this, we must create a 
% operand matrix |T_Super| and matrix multiply it with out coefficents matrix |c|.
% 


%!
T_Super = [ones(size(tSuper)),tSuper];
R_Super = T_Super * c;


%%%
% Another possibility is to use the coefficients dirctly and utilize MATLAB's array 
% operations for fast creation:
% 
% 
%   R_Super = c(1) + c(2) .* tSuper;
% 
%
% *TASK 1* Plot |t| and |R| as black, filled points, and plot the super-sampled line 
% in red.
% 

%!
fig2 = figure;
ax2 = axes(fig2,"NextPlot",'add');
%@
plot(ax2,t,R,'.k','markersize',22);
line(tSuper,R_Super,'color','r');

%%%
% *Bonus Task* Try to calculate the coefficients using the |/| operator instead of |\|. Name the vector d and compare it to c.
%

%@
d = (R'/T')';
c == d
isequal(c,d)
