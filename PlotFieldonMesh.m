function PlotFieldonMesh(coordinates,nodes,component, outputFlag)
if outputFlag ~=4
    component = component(outputFlag:5:end);
else
    component = (component(1:5:end) .^2 + component(2:5:end) .^2 + component(3:5:end) .^2) .^ (0.5);
end

dimension = size(coordinates,2) ;  % 网格维度
nel = length(nodes) ;                  % 单元数量
nnode = length(coordinates) ;          % 节点总数
nnel = size(nodes,2);                % 每单元内节点数量
% 
% 初始化相关矩阵
X = zeros(nnel,nel) ;
Y = zeros(nnel,nel) ;
Z = zeros(nnel,nel) ;
profile = zeros(nnel,nel) ;
%
if dimension == 3   % For 3D plots
    if nnel == 3  % Surface in 3D 
        for iel=1:nel   
            nd=nodes(iel,:);         % 节点连接性
            X(:,iel)=coordinates(nd,1);    % x坐标值
            Y(:,iel)=coordinates(nd,2);    % y坐标值
            Z(:,iel)=coordinates(nd,3) ;   % z坐标值
            profile(:,iel) = component(nd') ; % 每个节点的数值
        end

        fill3(X,Y,Z,profile)
        rotate3d on ;
        axis equal;
        axis off ; 
        % Colorbar Setting
        colorPiece=0:0.05:1;
        colorPieceF=flip(colorPiece);
        colorPiece0=zeros(1,size(colorPiece,2));
        colorPiece1=ones(1,size(colorPiece,2));
        myColor=[colorPiece0,colorPiece,colorPiece1;
            colorPiece,colorPiece1,colorPieceF;
            colorPieceF,colorPiece0,colorPiece0;]';
        colormap(myColor);
        colorbar;
    end
end

              
         
 
   
     
       
       

