%% Working With The IrisData Class
% Overview of the IrisData class and methods.
%%% 
% The first input argument of an analysis function must contain the incoming data object
% from Iris. This object is a custom class defined in the IrisData.m class file. While developing
% analyses, one should make sure that Iris is on the MATLAB path, either by installing the
% CLI and importing Iris libraries or by running Iris in your MATLAB session. The IrisData
% object has a number of useful methods for accessing and working with data. All of the
% methods can be viewed by using the doc IrisData command in the MATLAB command
% window, a list of Properties is show in the table below.
%
% <<lib/img/irisdata.png>>
%
%% Methods
% An IrisData object is a value type class, which means that the class cannot modify itself
% and so all methods which make calculations with the data, or attempt to modify the
% data will produce a new instance of the class. One should avoid overwriting variables, even
% though it is often tempting to recycle variable names, e.g., do |newData =
% Data.Filter();| and instead of |Data = Data.Filter();|. Because a new instance is created each time
% a method is called, methods may be chained together to reduce creating intermediate
% variables. For example, one can apply a digital low-pass filter to the data and perform
% baseline corrections by chaining the |.Filter()| and |.Baseline()| methods together, i.e.,
% |CleanData = Data.Filter().Baseline();|. Methods capable of chaining are as follows:
% |.Baseline()|, |.Aggregate()|, |.Filter()|, and |.Scale()|. These methods operate identically
% to how the data toggle switches operate in the Iris main view.
%
% The IrisData class also contains a number of static methods which are replicates of
% the Iris utilities, which are included for portability. Other methods exist to aid in quick
% processing of contained data, such as the |.plot()|, which simply creates a new figure and
% plots the contained data. The plot method may be called in function or method form, i.e.,
% |plot(Data,parameters);| or |Data.plot(parameters)|, where parameters are name-value
% arguments common to MATLAB|s |line()| function.
%
% <<lib/img/irisdata_utils.png>>
%
%% Accessing Metadata
% It is often useful to know information about how each datum was recorded and use that
% information to make decisions about how to proceed with an analysis. For example, assume
% we would like to average the traces into groups which correspond to the stimulus intensity
% of an experiment. During acquisition of these data, the only parameter that changed from
% datum to datum was the voltage delivered to the light-emitting diode (LED) stimulus. This
% property is stored with each datum and we can access it in a number of ways. The most convenient
% method is to use the specifications table for the data, which can be access through the
% IrisData object|s Specs property like this: |Data.Specs.Table|. This approach will convert
% any values from the original properties cell array into a string for display in the MATLAB
% table class. To retrieve the original form of the metadata, use: |Data.Specs.Datums|, which
% will return a |nx2| cell array for each datum.
%
%% Analysis Example
% The following anlaysis function accepts inputs for grouping, baselining and
% plotting. 
% 
% <<lib/img/anlysisExample_avg.png>>
%

