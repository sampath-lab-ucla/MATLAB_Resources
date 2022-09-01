%% Object Oriented Programming in MATLAB
% A short walkthrough of object oriented concepts related to Symphony and Iris 
%%% 
% Note: Run this section first to load the required files. This document uses 
% audio, it is recommended to turn the volume up or use headphones.
% 

%!
addpath(genpath('.\lib'));

%% Introduction
% Object oriented programming (OOP) is a script-writing paradigm wherein we 
% define "objects" as pertaining to a particular _class_, or _class system_, use 
% these objects to perform subroutines and _communicate_ to other objects. OOP 
% was originally conceptualized as a mimicry of cells in a tissue, performing 
% local tasks, hidden from the outside, and then packaging and sending messages 
% to other cells. In the context of a computer program, we can imagine that a 
% component of that program, an _object_, will have some characteristics, _properties_, 
% and perform some tasks, _methods_, that only that component, and other components 
% of that type, need. In Symphony v2+, that is precisely how a protocol _behaves_, 
% and so it makes sense that it was developed with a OOP style.
% 
% A way I like to think of OOP is, sort of, in the context of a phylogeny: where 
% objects are like species that belong to a phylum which _inherit_ properties 
% from their ancestors, but have novel characteristics that separate them from 
% their ancestors.
%
% 
% <<lib/img/birdTree.jpg>> 
% 
%
%% OOP Concepts
%
% <<lib/img/oopConcepts.png>> 
%
%%%
%
% # Object: The instantiation of a component which behaves as described by its 
% class definition.
% # Class: A class is a collection of methods and properties that make up the 
% "operating manual" of the object being defined.
% # Polymorphism: The ability of a class to modify its behavior from an ancestor.
% # Encapsulation: The ability of a class to hide methods and properties from 
% public view.
% # Inheritance: The properties and behaviors an object is "born" with, gained 
% from an ancestral class.
% # Abstraction: An idea of hiding the mechanism to allow complex behaviors 
% to be performed without requiring knowledge about their underlying mechanism. 
% A good example of abstraction is a calculator. You do not need to know how the 
% hardware computes a logarithm to use the |log10| button.
%
%% OOP Example
% In programming, the coder is God, so we get to define the evolutionary starting 
% point for anything. In this case, I'm going to use the California Quail (our 
% state bird) as an example. 
% 
% If we wanted to create an ecosystem we might start with a few classes, like 
% Animalia, Fungi, Plantae, Protozoa, etc.. but our purpose here is not to belabor 
% the point of inheritance. So while we could separate class definitions like 
% this:
% 
%  californiaQuail < Callipepla < Phasianidae < Galliformes < Aves < Sauropsida 
%  < Tetrapoda < Gnathostomata < Vertebrata < Olfactores < Chordate < Animalia
% 
% |...| or something similar, let's not. You can imagine what properties each 
% of the taxa would have and how they would be different from descendant to descendant. 
% It's at this point that you might ask, "why? Wouldn't it just be easier to create 
% a single function for each entity in the ecosystem?"
% 
% The short answer is: no. The long answer is: at worst, the OOP appraoch is the same
% amount of work but is typically much less work. The key is in the properties.
% 
% A quick comparision of the standard vs functional vs OOP approaches:
%
%   %%% Task: Create some data with a name, x, y, date, and length
%   
%   % standard approach
%   data1_name = 'data1';
%   data1_x = 1:10;
%   data1_y = randn(1,10);
%   data1_date = datestr(now);
%   data1_length = length(data1_x);
%   
%   % functional approach
%   % define function
%   function [name,x,y,date,len] = makeData(name,x,y,date)
%     name = name;
%     x = x;
%     y = y;
%     date = date;
%     len = length(x);
%   end
%   % use function
%   [data1_name, data1_x, data1_y, data1_date, data1_length] = makeData('data1',1:10,randn(1,10),datestr(now));
%   
%   % Classdef approach:
%   % define class first
%   classdef dataObj
%     properties
%       name
%       x
%       y
%       date
%       length
%     end
%     methods
%       function obj = dataObj(name,x,y,date)
%         obj.name = name;
%         obj.x = x;
%         obj.y = y;
%         obj.date = date;
%         obj.length = length(x);
%       end
%     end
%   end
%   % create our data1
%   data1 = dataObj('data1',1:10,randn(1,10),datestr(now));
%
%%% 
% Now, I know you're looking at that and thinking, "wait, that is way more code 
% to make one datum with some information... what gives?!" And I would say, you're 
% right, that is a lot of code for 1 data set. Now what about creating 2? 10? 
% 20? what about the hundreds of epochs we produce during data acquisition?
%
%%%
% 
%   % standard approach:
%   data1_name = 'data1';
%   data1_x = 1:10;
%   data1_y = randn(1,10);
%   data1_date = datestr(now);
%   data1_length = length(data1_x);
%   data2_name = 'data2';
%   data2_x = 1:10;
%   data2_y = randn(1,10);
%   data2_date = datestr(now);
%   data2_length = length(data2_x);
%   ...
%   dataN_name = 'dataN';
%   dataN_x = 1:10;
%   dataN_y = randn(1,10);
%   dataN_date = datestr(now);
%   dataN_length = length(dataN_x);
%   
%   % functional approach:
%   [data1_name, data1_x, data1_y, data1_date, data1_length] = makeData('data1',1:10,randn(1,10),datestr(now));
%   [data2_name, data2_x, data2_y, data2_date, data2_length] = makeData('data2',1:10,randn(1,10),datestr(now));
%   ...
%   [dataN_name, dataN_x, dataN_y, dataN_date, dataN_length] = makeData('dataN',1:10,randn(1,10),datestr(now));
%   
%   % classdef approach
%   data1 = dataObj('data1',1:10,randn(1,10),datestr(now));
%   data2 = dataObj('data2',1:10,randn(1,10),datestr(now));
%   ...
%   dataN = dataObj('dataN',1:10,randn(1,10),datestr(now));
%
%%% 
% So by being able to set properties during creation, _instantiation_, of the 
% object, we can keep everything neat and collected without have to perform any 
% copy-paste or manually typing many lines of code. In MATLAB, we can use builtin 
% data types to make objects, or object-containers, by using |struct()|, |cell()|, 
% |containers.Map()|, |table()|, |etc.|. There are some advantages and some drawbacks 
% of using those objects in place of making your own class definitions, but that 
% is a topic for another day.
% Back to quails...
% 
% So let's start at a common entry point for our California Quail and, say, 
% a Scaled Quail. These both belong to the class, Aves. More specifically, a little 
% ways down the phylogenetic tree, they are both Quails. We can go about creating 
% these quails in our virtual world a number of  ways. The following is one.
% 
% We define some classes to show our OOP concepts in action. 
% 
% First, let's define our Aves ancestral class, called a _superclass_. Here 
% we collect some properties as shown below.
%
%% |Aves| Definition
% 
%   classdef Aves
%     
%     properties (Constant)
%       % conserved features from ancestors we aren't defining a class for
%       pneumaticBones = true % have hollow bones
%       isEndothermic = true % are warm-blooded
%     end
%     
%     properties
%       % properties that we expect to be different for different members of the Aves superclass
%       canFly
%       prefersFlight
%       song % the bird's call
%       length
%       weight
%       wingspan
%       bodyColor
%       headColor
%       wingColor
%     end
%   
%   ...
%
%%%
% As can be seen,  we have a collection of properties specific to birds with 
% some being values we expect are inherited from a superclass that we aren't going 
% to define (Constant) and some left without any value assigned to them. We could 
% instantiate this object and it would exist, but it would have a bunch of empty 
% properties and wouldn't be able to DO anything. Let's fix that.
% 
% So we know that birds, in general, can fly. Though we also know that there 
% are some birds that can't fly, or can fly but prefer not to. Class definitions 
% also contain behaviors, called _methods_, that control how the Aves object is 
% going to interact with the world, i.e.  how the object sends and receives messages. 
% Let's give our Aves a mechanism for flying and calling by defining the aptly 
% named methods:
%% |Aves| Methods
% 
%   ...
%     methods
%       
%       function call(self)
%         if isempty(self.song)
%           disp('No call defined.'); 
%         else
%           disp('Listen to my call...');
%           [y,fs] = audioread(self.song);
%           sound(y,fs,16);
%         end
%       end
%       
%       function fly(self)
%         if isempty(self.canFly)
%           disp('My flight behavior isn''t defined.'); 
%         elseif self.canFly
%           disp('I can fly!');
%         else
%           disp('I can''t fly.');
%         end
%       end
%       
%     end % endMethods
%     
%   end % endClassdef
%
%%% 
% When we define a method, the first input argument to the method function will 
% be a reference to the object itself, so I've given it the name, |self|. Other 
% names you'll see, especially for MATLAB, are |obj| and |this|. As you can see, 
% each method uses the self reference to determine if a song exists, or if the 
% Aves member is able to fly. That is, the method may have access to the object
% properties.
% 
% Creating a member of this class would look like this (run this section):

%!
AvesMember = Aves()

%%%
%% And if we try to make this AvesMember fly:

AvesMember.fly()

%% Extending The |Aves| Class
% But what about quails?
% 
% You can imagine, and this is by design, that many, possibly all, birds have 
% these properties, and so we could make thousands of birds that start with the 
% base properties and behaviors. So let's make one: the quail.
% 
% There are probably lots of properties specific to all quails, but the first 
% that comes to mind is the head markings. Some have tuffs others have topknots 
% and so on. So we can, by creating a subclass of |Aves|, called |Quails|, extend 
% our list of properties, and we can set default values for our blank properties. 
% To do this, we need to create a special method referred to as the _constructor 
% method_. This method is simply a "function" that defines the |self| object and has
% the name of the class. 
%
%   classdef Quails < Aves
%     
%     properties
%       headMarkings
%     end
%     
%     methods
%       
%       function self = Quails()
%         self.canFly = true;
%         self.prefersFlight = false;
%       end
%       
%       function fly(self)
%         fly@Aves(self)
%         if self.prefersFlight
%           disp('Watch me take off!');
%         else
%           disp('But I''d rather walk.');
%         end
%       end
%           
%     end
%     
%   end    
%
%%% 
% Here, we gave Quails an empty |headMarkings| property, defined that 
% all quails |canFly = true| but |preferFlight = false|. In order to incorporate 
% these changes into our quail, we needed to extend the |fly| method. The first line 
% of the fly method tells MATLAB that you first want to call the method of the 
% superclass and then run the code below. Using this object would look like:

%!
QuailsMember = Quails()
QuailsMember.fly()

%%% 
% As you can see, Quails can fly but prefer to walk. But what if we asked for their 
% call?

%!
QuailsMember.call()

%%% 
% We don't have a generic quail call, mostly because quail species have very 
% different calls from each other. Two examples of this would be the California 
% Quail and Scaled Quail. They have descriptions that can be coded into new classes 
% like so:
%
% 
%   classdef californiaQuail < Quails
%     
%     methods
%       
%       function self = californiaQuail()
%         self.prefersFlight = true;
%         self.song = 'CaQuailSong.mp3';
%         self.bodyColor = 'white/black/bluish with scales';
%         self.headColor = 'brown';
%         self.wingColor = 'brown';
%         self.headMarkings = 'buffy crest accent';
%       end
%       
%     end
%     
%   end
%   
%   
%%% 
% and...
%
% 
%   classdef scaledQuail < Quails
%     
%     methods
%       
%       function self = scaledQuail()
%         self.prefersFlight = false;
%         self.song = 'ScQuailSong.mp3';
%         self.bodyColor = 'rich grey, brown, chestnut';
%         self.headColor = 'black and white';
%         self.wingColor = 'brown';
%         self.headMarkings = 'comma-shaped topknot';
%       end
%       
%     end
%   end
%
%%% 
% 
% ... and thus we can have the two birds in our world:

%!
caQuail = californiaQuail()
scQuail = scaledQuail()

%%% 
% But since they have difference preferences for flight:
%

%!
% Birds of a feather...
caQuail.fly()
scQuail.fly()

%%% 
% Now, what about those empty properties for length, weight and wingspan? We 
% could set them after the fact by simply using dot notation like so:
%

%!
% for the california quail
caQuail.wingspan = 15.0;
caQuail.weight = 6.7;
caQuail.length = 13;
caQuail

% for the scaled quail
scQuail.wingspan = 13.0;
scQuail.weight = 5.0;
scQuail.length = 9.5;
scQuail

%%% 
% It would be even better if we could provide these data at construction by 
% implementing input agruments to the class constructor like so:
%
% 
%   classdef californiaQuail < Quails
%     
%     methods
%       
%       function self = californiaQuail(length,weight,wingspan)
%         if nargin < 3, wingspan = []; end
%         if nargin < 2, weight = []; end
%         if nargin < 1, length = []; end
%         
%         self.prefersFlight = true;
%         self.song = 'CaQuailSong.mp3';
%         self.bodyColor = 'white/black/bluish with scales';
%         self.headColor = 'brown';
%         self.wingColor = 'brown';
%         self.length = length;
%         self.weight = weight;
%         self.wingspan = wingspan;
%         self.headMarkings = 'buffy crest accent';
%       end
%       
%     end
%     
%   end
%
%%% 
% And ...
%
%%%
% 
%   classdef scaledQuail < Quails
%     
%     methods
%       
%       function self = scaledQuail(length,weight,wingspan)
%         if nargin < 3, wingspan = []; end
%         if nargin < 2, weight = []; end
%         if nargin < 1, length = []; end
%         
%         self.prefersFlight = false;
%         self.song = 'ScQuailSong.mp3';
%         self.bodyColor = 'rich grey, brown, chestnut';
%         self.headColor = 'black and white';
%         self.wingColor = 'brown';
%         self.length = length;
%         self.weight = weight;
%         self.wingspan = wingspan;
%         self.headMarkings = 'comma-shaped topknot';
%       end
%       
%     end
%   end
%
%%% 
% So now we can provide the information we want in the constructor of each bird, 
% minimizing the number of lines of code needed to generate many variations of 
% a particular quail type. So now we can create an array of california quails 
% with different sizes, knowing that all california quails have the same coloring 
% (assuming for the sake of the example).
%

%!
CaliforniaQuailPopulation = [californiaQuail(12.5,6.5,15.2);californiaQuail(13.0,6.7,16)]
% view the first quail
disp(CaliforniaQuailPopulation(1))

%% Quail Calls 
% Because California and Scaled Quails have different calls, but California 
% Quails have similar (or the same for this example) calls, we can also ask the 
% birds to sing (make sure your speakers are on):
% 

%! 
CaliforniaQuailPopulation(1).call()
%%%
% and for the second Ca. Quail:

%!
CaliforniaQuailPopulation(2).call()

%%%
% For the Sc. Quail:
%

%!
scQuail.call();

%% Final Remarks
% We are able to use the fly and call methods from the Aves super, super class 
% due to inheritance the same way we can set values in the species level class 
% constructor for properties which have definitions in the Aves class, two super 
% classes away. Because the Quails class extends the Aves class' fly method,
% and |Quail| is the superclass of our species levels classes, we use the fly method 
% without modifying it.
% 
%%%
% Can you find the in-action examples of the OOP concepts in our exercise?
% 
%%% 
% What about Symphony? The next script in the series is an overview of how Symphony 
% objects work.
% 
%%% 
% All scripts used to make this presentation are available in the |lib| folder. 
% Be sure to check them out and see the help documation at the mathworks site 
% for more information on making your own classes: 
% <https://www.mathworks.com/help/matlab/object-oriented-programming.html OOP in MATLAB>.
%
%% File Cleanup
% Run the following block to return your MATLAB path to how you had it before.
%

%!
rmpath(genpath('.\lib'));
