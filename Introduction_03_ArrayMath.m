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
% taking $sine(\theta)$, or computing some statistical summary like |$\bar{X}|. The 
% major advantage the MATLAB has over other languages is the automatic vectorization 
% of these functions. That is, if the input to the mathimatical function is a 
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
% $$y(t)=A\sin(2\pi f t+\theta)$$
% 
% Where $A$ is the amplitude, $f$ is the frequency in Hertz, $t$ is the timepoint 
% and $\theta$ is the phase angle in radians.
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
plot(t, amplitude * sin(ft) );
ylabel("Y");
xlabel("Time (sec)");

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
% *Task* Let's create a sine and cosine using the |tSquared| variable as we made |y| 
% earlier. Let's call the new variables |ySquared| and |zSquared|.
% 

%@
ysquared = amplitude * sin( 2 * pi * f * t.^2 + shiftAngle );
zsquared = amplitude * cos( 2 * pi * f * t.^2 + shiftAngle );

%!
% Now plot:
plot(t,ysquared.*zsquared);
ylabel("Y");
xlabel("Time (sec)");

%% Implicit Expansion
% Another form of implicit expansion occurs when two arrays with a shared 
% dimensional size are operated on.
% 
% <<lib/img/implicitExpansion.png>>
% 


%!
sequence = reshape(1:20,10,2)
dualSequence = sequence ./ [1,10]


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
% 


%!
A = randn(100,2);
A(:,1) = A(:,1) * 2 + 20; % sd==2, mean==20
A(:,2) = A(:,2) * 5; % sd==5, mean==0
% calculate the mean of each column
meanA = mean(A,1);

% Plot
fig = figure;
ax = axes(fig);
h1 = histogram(ax,A(:,1)); % blue
hold('on');
h2 = histogram(ax,A(:,2)); % orange
line(ax,meanA([1,1]),ax.YLim, 'linewidth',2,'color',ax.ColorOrder(1,:));
line(ax,meanA([2,2]),ax.YLim, 'linewidth',2,'color',ax.ColorOrder(2,:));


%% Matrix Multiplication
% Matrix multiplication requires that the inner dimensions agree. The resultant 
% matrix has the outer dimensions.
% 
% <<lib/img/matrixMult.png>>
% 
%
%    X = [1 2; 3 4; 5 6];
%    Y = [7; 8; 9];
%    Y * X
%
% *Gives an error:*
%
%    Error using  * 
%    Incorrect dimensions for matrix multiplication. Check
%    that the number of columns in the first matrix
%    matches the number of rows in the second matrix. To
%    operate on each element of the matrix individually,
%    use TIMES (.*) for elementwise multiplication.
%
%    Y' * X
%
% *Works!* Because we transposed (|'|) the |Y| variable.
%
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
% Then we can get the Least Squares solution to |c*T=R| by creating the matrix R 
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
ax2 = axes(fig2);
%@
plot(ax2,t,R,'.k','markersize',22);
line(tSuper,R_Super,'color','r');
