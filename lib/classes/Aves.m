classdef Aves
  
  properties (Constant)
    % conserved features from ancestors we aren't defining a class for
    pneumaticBones = true
    isEndothermic = true
  end
  
  properties
    % properties that we expect to be different.
    canFly
    prefersFlight
    song
    length
    weight
    wingspan
    bodyColor
    headColor
    wingColor
  end
  
  methods
    
    function call(self)
      if isempty(self.song)
        disp('No call defined.'); 
      else
        disp('Listen to my call...');
        [y,fs] = audioread(self.song);
        sound(y,fs,16);
      end
    end
    
    function fly(self)
      if isempty(self.canFly)
        disp('My flight behavior isn''t defined.'); 
      else
        if self.canFly
          disp('I can fly!');
        else
          disp('I can''t fly.');
        end
      end
    end
    
  end
  
end

