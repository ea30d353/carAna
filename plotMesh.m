function plotMesh(coordinates,nodes,show)
if nargin == 2
    show = 0 ;
end
dimension = size(coordinates,2) ;  % 网格维度
nel = length(nodes) ;                  % 单元数量
nnode = length(coordinates) ;          % 节点总数
nnel = size(nodes,2);                % 每个单元内节点数量
% 
% 初始化相关矩阵
X = zeros(nnel,nel) ;
Y = zeros(nnel,nel) ;
Z = zeros(nnel,nel) ;

if dimension == 3   
    if nnel==3 
        for iel=1:nel   
            nd = nodes(iel,:) ;
            X(:,iel)=coordinates(nd,1);    % x坐标值
            Y(:,iel)=coordinates(nd,2);    % y坐标值
            Z(:,iel)=coordinates(nd,3) ;   % z坐标值
        end    

        fill3(X,Y,Z,'w')
        rotate3d ;
        axis equal;
        axis off ;
        % 展示节点序号（功能尚未完善）
        if show ~= 0
            k = 1:nel ;
            nd = k' ;
            for i = 1:nel
                text(X(:,i),Y(:,i),Z(:,i),int2str(nd(i)),....
                    'fontsize',8,'color','b');
            end
        end
    end
end