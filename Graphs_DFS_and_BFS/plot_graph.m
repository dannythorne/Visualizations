%--
% function []=plot_graph(e,eprime,vprime,vseen)
%  Plot the graph represented by adjacency matrix e.
%  e.g.,
%
%        e =
%             1     1     9     1     0     0
%             0     1     1     0     0     0
%             0     0     1     0     1     0
%             0     0     0     1     0     1
%             0     0     0     0     1     1
%             0     0     0     0     0     1
%
%  Darken the edges in adjacency matrix eprime.
%
%  Circle the vertices in vprime.
%
function []=plot_graph(e,eprime,vprime,vseen)

plot_background_circle = 0;
label_edges = 0;

if( size(e,1)~=size(e,2))
  error('Adjacency matrix must be square.');
end

num_nodes = size(e,1);
disp(sprintf('%d nodes',num_nodes));

figure;
%set(gcf,'position',[ 140 362 560 560]);
set(gcf,'position',[ 214 141 560 560]);
hold on;

dtheta = pi/128;

if plot_background_circle
  for theta=0:dtheta:2*pi
    hnd=plot( [ cos(theta) cos(theta+dtheta)], [ sin(theta) sin(theta+dtheta)]);
    set(hnd,'color',.9*[ 1 1 1]);
  end
end

% plot edges
edge_label_color = 0.7*[ 1 1 1];
edge_color = (4/5)*edge_label_color;
heavy_edge_color = (3/5)*edge_label_color;
for j=1:num_nodes
  for i=1:j
    if( e(i,j))
      theta1 = 2*pi*((i-1)/(num_nodes));
      theta2 = 2*pi*((j-1)/(num_nodes));
      x1=cos(theta1);
      x2=cos(theta2);
      y1=sin(theta1);
      y2=sin(theta2);
      hnd = plot( [ x1 x2], [ y1 y2]);
      set(hnd,'linewidth', 2);
      set(hnd,'color', edge_color);
      if( label_edges && i~=j)
        hnd=plot( (x1+x2)/2, (y1+y2)/2, '.');
        set(hnd,'color',[ 1 1 1]);
        set(hnd,'markersize',40);
        hnd=text( (x1+x2)/2, (y1+y2)/2, sprintf('%d',e(i,j)));
        set(hnd,'interpreter','latex');
        set(hnd,'horizontalalignment','center');
        set(hnd,'verticalalignment','middle');
        set(hnd,'color', edge_label_color);
      end
    end

    if( numel(eprime) && eprime(i,j))
      theta1 = 2*pi*((i-1)/(num_nodes));
      theta2 = 2*pi*((j-1)/(num_nodes));
      x1=cos(theta1);
      x2=cos(theta2);
      y1=sin(theta1);
      y2=sin(theta2);
      hnd = plot( [ x1 x2], [ y1 y2]);
      set(hnd,'color', heavy_edge_color);
      set(hnd,'linewidth', 4);
      if( label_edges && i~=j)
        hnd=plot( (x1+x2)/2, (y1+y2)/2, '.');
        set(hnd,'color',[ 1 1 1]);
        set(hnd,'markersize',40);
        hnd=text( (x1+x2)/2, (y1+y2)/2, sprintf('%d',e(i,j)));
        set(hnd,'interpreter','latex');
        set(hnd,'horizontalalignment','center');
        set(hnd,'verticalalignment','middle');
        set(hnd,'color', edge_label_color);
      end
    end
  end
end

% plot nodes
node_label_color = 0.5*[ 1 1 1];
node_color = (3/5)*node_label_color;
for n=1:num_nodes
  theta = 2*pi*((n-1)/(num_nodes));
  hnd=plot( cos(theta), sin(theta), '.');
  set(hnd,'markersize',20);
  set(hnd,'color',node_color);
  hnd=text( 1.1*cos(theta), 1.1*sin(theta), sprintf('$%d$',n-1));
  set(hnd,'interpreter','latex');
  set(hnd,'horizontalalignment','center');
  set(hnd,'verticalalignment','middle');
  set(hnd,'color',node_label_color);
  set(hnd,'fontsize',14);
  set(hnd,'fontweight','bold');
  set(hnd,'linewidth',1);
  if( find(vprime==n-1))
    hnd=plot( cos(theta), sin(theta), 'o');
    set(hnd,'markersize',10);
    set(hnd,'linewidth',2);
    set(hnd,'color',[ 0 0 1]);%node_color);
  end
  if( find(vseen==n-1))
    hnd=plot( cos(theta), sin(theta), '*');
    set(hnd,'markersize',10);
    set(hnd,'linewidth',2);
    set(hnd,'color',[ 1 0 0]);%node_color);
  end
end

axis off;
axis image;
set(gcf,'color',[1 1 1]);
set(gcf,'toolbar','none');
set(gcf,'menubar','none');
print('graph.png','-dpng','-r128');

end
