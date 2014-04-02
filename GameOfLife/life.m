% function []=life(filename)
%   Process data in filename which is assumed to be coordinates of living cells
%   listed in pairs of columns, one set per generation prepended with label
%   "Generation N" on separate line with N indexed from 0 where 0 is the
%   initial configuration.
function []=life(filename)

figure;

fid = fopen(filename);

tline = fgetl(fid);
while( ~feof(fid))
  if( tline(1)=='G')
    z = sscanf( tline(11:end), '%d'); % which generation
    disp(sprintf('Generation %d',z));
    tline = fgetl(fid);
  else
    while( ~feof(fid) && tline(1)~='G')
      xy = sscanf( tline, '%d');
      x = xy(1);
      y = xy(2);
      disp(sprintf('%d %d',x,y));
      plot_cube(x, y, z);
      tline = fgetl(fid);
    end
  end
end

fclose(fid);

axis equal;

end

function []=plot_cube( x, y, z)
  patch( [ x+.5; x-.5; x-.5; x+.5], [ y+.5; y+.5; y-.5; y-.5], [z-.5; z-.5; z-.5; z-.5], ['b']);
  patch( [ x+.5; x-.5; x-.5; x+.5], [ y+.5; y+.5; y-.5; y-.5], [z+.5; z+.5; z+.5; z+.5], ['b']);
  patch( [ x+.5; x-.5; x-.5; x+.5], [y-.5; y-.5; y-.5; y-.5], [ z+.5; z+.5; z-.5; z-.5], ['b']);
  patch( [ x+.5; x-.5; x-.5; x+.5], [y+.5; y+.5; y+.5; y+.5], [ z+.5; z+.5; z-.5; z-.5], ['b']);
  patch( [x-.5; x-.5; x-.5; x-.5], [ y+.5; y-.5; y-.5; y+.5], [ z+.5; z+.5; z-.5; z-.5], ['b']);
  patch( [x+.5; x+.5; x+.5; x+.5], [ y+.5; y-.5; y-.5; y+.5], [ z+.5; z+.5; z-.5; z-.5], ['b']);
end
