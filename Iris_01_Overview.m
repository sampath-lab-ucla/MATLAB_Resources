%% Iris Overview
% Introduction to the Iris DVA application.
%%% 
% Iris Data Visualization and Analysis (Iris) is a MATLAB (MathWorks, 2021) application
% graphical user interface and a framework for visualizing, managing and analyzing physiological
% data. Electrophysiological data are often large, numerous, and comprise comprehensive
% metadata which are difficult to maintain and process for analysis. Experimenters often rely
% on extensive sets of physical and digital notes, complex folder structures and proprietary
% software to parse raw data for publication. As a result, many intermediate and temporary
% files get created, which may obfuscate the analytical process. In today’s publication environment,
% sharing analysis code and data have become more common-place and there is an
% ever-growing necessity for transparency and control over collected data. Iris was created for
% the purpose of abstracting data-processing mechanisms to simplify and standardize analysis
% workflow across broad-ranging sources of data. As a benefit, data acquired from different
% systems and experiments can be grouped together into single, comprehensive files allowing
% for streamlined and straight-forward analysis, easy sharing, thorough process tracking and
% reproducibility.
%% User-Interface
% Iris is an offline interface between the user and their data that enables access to the data and
% associated metadata, and provides a framework for data wrangling and analysis. The user
% interface (UI) is a collection of MATLAB figure windows where the primary UI is presented
% through the Iris primary view window.
%
% <<lib/img/ui.jpg>>
% 
%% Preferences
% Experimental data come in many formats, Iris was designed to be flexible to accommodate
% simultaneous viewing and processing the data. To achieve this flexibility, Iris is tunable
% through the preferences window where navigation controls, workspace variables and data
% processing settings are found.
%
% <<lib/img/Preferences_animation.gif>>
% 
%% Data Overview
% A detailed view for all data loaded into Iris. The data tree allows an
% alternate form of navigating data while loading available metadata for 
% selected data indices directly into the view. Optional processing of the data is 
% available through this advanced data controller. Optionally modify inclusion status,
% or remove data altogether, of multiple data indices at once by selected the desired
% action in the drop-down menu and clicking on the “Apply” button.
%
% <<lib/img/dataoverview.jpg>>
%
%% Metadata Viewers
% Physiological experiments, particularly those conducted in our laboratory, have many
% configurable pieces unique to a particular experimenter or rig, which must be tracked and
% documented accordingly. Data acquisition software, whether open-source or proprietary,
% generate databases of these metadata, information about the specific experiments performed,
% which can get lost in the data analysis process as early as at the importation step. Iris
% mitigates this issue by providing a data class which tracks and indexes metadata at the file
% level and the individual datum level. Most acquisition software available also allows usercreated
% metadata, such as notes (Fig. A.3). Iris offers viewers for these metadata, which
% may be accessed through the View menu.
%
%%%
% _File Information._ Information from the open files are displayed in the document tree.
% Details are populated from the metadata structures stored or loaded with the opened data files.
%
% <<lib/img/fileinfo.jpg>>
% 
%%%
% Data Properties._ Properties are populated from the selected data indices in the Iris
% primary view. Multiple fields from the data structure are combined into a single table. If multiple indices are
% selected, unique values for a given property are shown, separated by a semi-colon (|;|). See Application Development
% for a complete breakdown of the input data structure.
%   
% <<lib/img/protocols.jpg>>
% 
%%%
% _Notes._ Digital notes stored or loaded with the imported data are viewable through the
% |Iris > View > Notes| menu.
%
% <<lib/img/notes.jpg>>
% 
%% Data Analysis
% A key goal of Iris is to make parsing and managing recorded data simple, straightforward
% and accessible. To achieve this, Iris provides utilities to perform a complete analysis, to
% extract data as Iris’s custom IrisData format to work with outside of the Iris interface, to
% build custom modules for working with data directly as an extension of the Iris interface,
% or to export data in standard formats for use outside of the Iris framework altogether. Iris
% was designed with an import-view-process-export strategy in mind to allow for a clean,
% generalized pipeline for data analysis.
%
% Analysis files are simply MATLAB function files with some extra syntactical sugar
% around the file header. An anlysis may be created using the *New Analysis*
% interface, found in the |Analyze| menu. In this way, Iris provides a simple 
% interface to produce a new analysis function for use with the Analysis Export 
% interface. Analysis functions are required to have at least 1 input, for the data 
% object sent from Iris to the function, and 1 output, for the storage of any results.
%
% <<lib/img/newanalysis.jpg>>
%
%%%
% The analysis function works as would a normal MATLAB function with an added syntactical
% scope only parsed by Iris, and thus the function may be called directly from the
% command line or a script should the user decide to do so. Upon selecting the analysis
% function from the drop-down in the Analysis Export UI (below), the function header
% is parsed for input argument names and their defaults as denoted by the |:=| operator (an
% operator that has no meaning elsewhere in MATLAB) within a comment block.
%
% <<lib/img/analysisExample.png>>
% 
%%%
% _Analysis Export UI._ This user interface will parse the analysis files placed in
% the Iris Analysis search path into two tables, one for output arguments and one for
% input arguments. Each table is comprised of 2 columns, the definition name on the
% left and the user-configurable value on the right. For output arguments, the
% user-configurable names specify how Iris should name the corresponding output
% variable upon saving. For input arguments, the Value on the right must conform to
% MATLAB data types. If a value placed in the right-hand column evaluates to an
% error, the analysis will not be allowed to proceed. 
%
% To perform an anlysis, select the analysis name from the dropdown, enter the datum
% indices on which to perform the analysis (this is usually prefilled by the
% currently showing data in the Iris main window), set input and output values,
% choose or type in an output file name and location, and, finally, hit Analyze.
% _It is important to note that analysis files are run in a sandbox mode so there
% should not be any user-defined interrupts, such as calls to |input|, or user
% defined dialogs that rely on user input. Any such calls or constructs will render
% the analysis un-usable._
%
% <<lib/img/analysisui.jpg>>
% 
%%%
% We will discuss the interior of an Iris analysis function in the next course.
%
%% Data Export
% Iris provides a few mechanisms by which the user may extract data from a larger dataset.
% Data indices to be exported can be selected and using Export... from the Analysis menu.
% The user will be prompted to make the decision to export the current selection or the whole
% session and then prompted to select a location. When selecting a location, the user may
% choose a file type of *.idata (detailed in the next section), *.csv or *.tsv. Choosing the
% delimited files will only export the x and y data from the chosen data domain. If the data
% toggles for Baseline and Filter are active, the user will also be prompted to apply those
% transformations to the exported data.
%
% <<lib/img/iris_savedata.gif>>
% 
