function [visited,numvis]=bfs(e,root)

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
queue1 = zeros(1,V);
queue2 = zeros(1,V);
back =  0;
front = 1;

back=back+1;
queue1(back) = root+1;
queue2(back) = root+1;

cur = 0;

k=0;
plot_graph(e,tree,visited-1,queue1-1);
title('bfs');
print(sprintf('bfs%04d.png',k),'-dpng','-r128');
while( front<=back)
  disp('####################################################################');

  % record visited node and pop queue
  numvis=numvis+1;
  visited(numvis) = queue1(front);
  queue1(front) = 0;
  front=front+1;
  queue1 = queue1-1, queue1 = queue1+1; % fiddle for display

  if( cur > 0)
    tree(queue2(front-1),visited(numvis)) = 1;
    tree(visited(numvis),queue2(front-1)) = 1;
    plot_graph(e,tree,visited-1,queue1-1);
    k=k+1;
    title('bfs');
    print(sprintf('bfs%04d.png',k),'-dpng','-r128');
  end

  cur = visited(numvis);

  for i=1:V
    %disp(sprintf('e(%d,%d)=%d',cur-1,i-1,e(cur,i)));
    if( e(cur,i)>0) % for edges incident to cur

      disp(sprintf('find(visited==%d)=%d\n',i-1,find(visited==i)));
      disp(sprintf('find(queue1==%d)=%d\n',i-1,find(queue1==i)));

      % push them onto the queue if
      % they are not already on the queue and
      % they haven't already by visited
      if( numel(find(queue1==i))==0 && numel(find(visited==i))==0)
        back=back+1;
        queue1(back) = i;
        queue2(back) = cur;

        if( cur > 0)
          plot_graph(e,tree,visited-1,queue1-1);
          k=k+1;
          title('bfs');
          print(sprintf('bfs%04d.png',k),'-dpng','-r128');
        end

        queue1 = queue1-1, queue1 = queue1+1; % fiddle for display
      end
    end
  end
  visited = visited-1 % fiddle for display
  visited = visited+1;
end

end
