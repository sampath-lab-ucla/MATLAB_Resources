%% Introduction To Iterations And Vectorization
% In this document we will cover the basics of iterative coding.
%%% 
% Often, it is desirable to recycle a piece of code, or apply some operation 
% to each element of an array. As we saw in the introductory materials for <X:\My 
% Drive\Sampath\_Shared\Teaching\MATLAB\Introduction_Arrays.mlx Array Creation> 
% and <X:\My Drive\Sampath\_Shared\Teaching\MATLAB\Introduction_ArrayMath.mlx 
% Array Mathematics>, there are a number of built-in ways MATLAB provides for 
% achieving even complex cases of iterative coding. These built-in methods are 
% examples of how MATLAB is a vectorized language, that is you can simply call 
% the function or operator on the array it will perform it along a specified dimension. 
% In other programming languages, vectorization is a task for the coder. For the 
% Python aficionado, you would know this from the iconic list expansion or list 
% comprehension, which is just a for loop wrapped in  syntactic sugar. I digress.
% 
% Although most of the vectorization is handled by MATLAB, there are cases where 
% vectorization is simply not possible or optimal. So it is important to understand 
% how to iterate an operation and produce an organized looping algorithm. Let's 
% get to it.
%% 
%