function [visited,numvis]=dfs(e,root)

if( size(e,1)~=size(e,2))
  error('Adjacency matrix must be square.');
end

if( e~=e')
  error('Adjacency matrix must be symmetric.');
end

V = size(e,1);

tree = zeros(size(e));

visited = zeros(1,V);
numvis = 0;
stack1 = zeros(1,V);
stack2 = zeros(1,V);
top =  0;

top=top+1;
stack1(top) = root+1;
stack2(top) = root+1;

cur = 0;

k=0;
plot_graph(e,tree,visited-1,stack1-1);
title('dfs');
print(sprintf('dfs%04d.png',k),'-dpng','-r128');
while( top > 0)
  disp('####################################################################');

  % record visited node and pop stack
  numvis=numvis+1;
  visited(numvis) = stack1(top);
  stack1(top) = 0;
  top=top-1;
  stack1 = stack1-1, stack1 = stack1+1; % fiddle for display

  if( cur > 0)
    tree(stack2(top+1),visited(numvis)) = 1;
    tree(visited(numvis),stack2(top+1)) = 1;
    plot_graph(e,tree,visited-1,stack1-1);
    k=k+1;
    title('dfs');
    print(sprintf('dfs%04d.png',k),'-dpng','-r128');
  end

  cur = visited(numvis);

  for i=1:V
    if( e(cur,i)>0) % for edges incident to cur

      disp(sprintf('find(visited==%d)=%d\n',i-1,find(visited==i)));
      disp(sprintf('find(stack1==%d)=%d\n',i-1,find(stack1==i)));

      % push them onto the stack if
      % they are not already on the stack and
      % they haven't already by visited
      if( numel(find(stack1==i))==0 && numel(find(visited==i))==0)
        top=top+1;
        stack1(top) = i;
        stack2(top) = cur;

        if( cur > 0)
          plot_graph(e,tree,visited-1,stack1-1);
          k=k+1;
          title('dfs');
          print(sprintf('dfs%04d.png',k),'-dpng','-r128');
        end

        stack1 = stack1-1, stack1 = stack1+1; % fiddle for display
      end
    end
  end
  visited = visited-1 % fiddle for display
  visited = visited+1;
end

end
