classdef Quails < Aves
  
  properties
    headMarkings
  end
  
  methods
    
    function self = Quails()
      self.canFly = true;
      self.prefersFlight = false;
    end
    
    function fly(self)
      fly@Aves(self)
      if self.prefersFlight
        disp('Watch me take off!');
      else
        disp('But I''d rather walk.');
      end
    end
        
  end
  
end    