function [fixnodes, pointload, young, poiss, denss, thick] = preprocessing1()
  young  =   2.1e5 ;
  poiss  =  0.3e0 ;
  denss  =   0.0e0 ;
  thick   =   1.2e0 ;
  shapePoint=load('./DataFiles/shapePoint.dat');
  shapePoint=shapePoint';
  fixnodes = [shapePoint,1*ones(length(shapePoint),1),zeros(length(shapePoint),1);
              shapePoint,2*ones(length(shapePoint),1),zeros(length(shapePoint),1);
              shapePoint,3*ones(length(shapePoint),1),zeros(length(shapePoint),1);
              shapePoint,4*ones(length(shapePoint),1),zeros(length(shapePoint),1);
              shapePoint,5*ones(length(shapePoint),1),zeros(length(shapePoint),1);];
  symmetryFace = [63, 62, 218, 46, 184, 183, 182, 181, 180, 179, 45, 213, 212, ...
                  60, 254, 253, 252, 251, 250, 72]; %对称面
  symmetryFace = symmetryFace';
  fixnodes = [fixnodes; symmetryFace, ones(length(symmetryFace), 1), zeros(length(symmetryFace), 1)];
  TailLine = [63, 226. 227, 228, 229, 230, 231, 232, 48, 195, 196, 197, 26, ...
              131, 132, 25, 27]; %引擎盖尾部固定约束点
  TailLine = TailLine';
  fixnodes = [TailLine,1*ones(length(TailLine),1),zeros(length(TailLine),1);
              TailLine,2*ones(length(TailLine),1),zeros(length(TailLine),1);
              TailLine,3*ones(length(TailLine),1),zeros(length(TailLine),1);
              TailLine,4*ones(length(TailLine),1),zeros(length(TailLine),1);
              TailLine,5*ones(length(TailLine),1),zeros(length(TailLine),1);];
  pointload = [72, 1, 100;249, 1, 100;71, 1, 100;];
end

