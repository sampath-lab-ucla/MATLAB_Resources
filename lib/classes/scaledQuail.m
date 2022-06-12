classdef scaledQuail < Quails
  
  methods
    
    function self = scaledQuail(length,weight,wingspan)
      if nargin < 3, wingspan = []; end
      if nargin < 2, weight = []; end
      if nargin < 1, length = []; end
      
      self.prefersFlight = false;
      self.song = 'ScQuailSong.mp3';
      self.bodyColor = 'rich grey, brown, chestnut';
      self.headColor = 'black and white';
      self.wingColor = 'brown';
      self.length = length;
      self.weight = weight;
      self.wingspan = wingspan;
      self.headMarkings = 'comma-shaped topknot';
    end
    
  end
end

