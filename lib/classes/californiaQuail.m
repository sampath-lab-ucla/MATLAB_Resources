classdef californiaQuail < Quails
  
  methods
    
    function self = californiaQuail(length,weight,wingspan)
      if nargin < 3, wingspan = []; end
      if nargin < 2, weight = []; end
      if nargin < 1, length = []; end
      
      self.prefersFlight = true;
      self.song = 'CaQuailSong.mp3';
      self.bodyColor = 'white/black/bluish with scales';
      self.headColor = 'brown';
      self.wingColor = 'brown';
      self.length = length;
      self.weight = weight;
      self.wingspan = wingspan;
      self.headMarkings = 'buffy crest accent';
    end
    
  end
  
end

