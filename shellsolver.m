function u=shellsolver(coordinates, elements, fixnodes, pointload, young, poiss, denss, thick)


  tic;                   % 计时器
  ttim = 0;              

  npnod = size(coordinates,1);         % 节点数量
  nelem = size(elements,1);            % 单元数量
  nnode = size(elements,2);            % 每个单元的节点数量
  nndof = npnod*5;                     % 总自由度
  eqnum = size(15);
  
  elements = sortrows(elements);

  ttim = timing('读取数据所需时间为：',ttim); %时间报告

  StifMat  = sparse( nndof , nndof );  % 创建刚度矩阵
  force    = sparse( nndof , 1 );      % 创建载荷矩阵
  force1   = sparse( nndof , 1 );      
  reaction = sparse( nndof , 1 );      
  u        = sparse( nndof , 1 );      
  la       = zeros ( nelem , 9 );      
  
% 材料属性
  aux1 = thick*young/(1-poiss^2);
  aux2 = poiss*aux1;
  aux3 = thick*young/2/(1+poiss);
  aux4 = (5/6)*thick*young/2/(1+poiss);
   
  D_matm = [aux1,aux2,   0;
            aux2,aux1,   0;
               0,   0,aux3];
             
  D_mats = [aux4,   0;
               0,aux4];
  
  D_matb = D_matm*(thick^2/12);

  xg(1) = 1.0/6.0;
  xg(2) = 2.0/3.0;
  xg(3) = 1.0/6.0;

  yg(1) = 1.0/6.0;
  yg(2) = 1.0/6.0;
  yg(3) = 2.0/3.0;

  wg(1) = 1.0/6.0;
  wg(2) = 1.0/6.0;
  wg(3) = 1.0/6.0;

  ttim = timing('初始化所用时间为：',ttim); %Reporting time
  
  elements = sortrows(elements,[1 2 3]);

% 循环单元
  for ielem = 1 : nelem
      
    lnods(1:3) = elements(ielem,1:3);
  
    cxyz(1:3,1:3) = coordinates(lnods(1:3),1:3);      % 单元坐标

    Te = shellRotation(cxyz);
    
    la(ielem,1:3) = Te(1,1:3);
    la(ielem,4:6) = Te(2,1:3);
    la(ielem,7:9) = Te(3,1:3);
    
    ctxy = cxyz*transpose(Te);    % 坐标旋转变换
    x = ctxy(1:3,1);              % 仅使用局部x坐标
    y = ctxy(1:3,2);              % 仅使用局部y坐标

    K_elem = zeros(15,15);
    
    for igs = 1 : 3
      [bmat_b,bmat_s,bmat_m,area] = B_mat(x,y,xg(igs),yg(igs),Te); 
      
      K_b = transpose(bmat_b)*D_matb*bmat_b*2*area*wg(igs);
      K_s = transpose(bmat_s)*D_mats*bmat_s*2*area*wg(igs);
      K_m = transpose(bmat_m)*D_matm*bmat_m*2*area*wg(igs);
      
      K_elem = K_elem + K_b + K_s + K_m;
    end
    

% 创建索引用于组装
    for i = 1 : 3
      ii = (i-1)*5;
      eqnum(ii+1) = (lnods(i)-1)*5 + 1 ;   % 构建索引序列
      eqnum(ii+2) = (lnods(i)-1)*5 + 2 ;
      eqnum(ii+3) = (lnods(i)-1)*5 + 3 ;
      eqnum(ii+4) = (lnods(i)-1)*5 + 4 ;
      eqnum(ii+5) = (lnods(i)-1)*5 + 5 ;
    end
  
% 组装力列阵
    for i = 1 : 15
      ipos = eqnum(i);
      for j = 1 : 15
         jpos = eqnum(j);
         StifMat(ipos,jpos) = StifMat (ipos,jpos) + K_elem(i,j);
      end
    end
  
  end  % 结束单元循环
  
  ttim = timing('组装刚度矩阵所用时间为：',ttim); %报告时间
  
% 施加载荷
  for i = 1 : size(pointload,1)
    ieqn = (pointload(i,1)-1)*5 + pointload(i,2);       % 寻找单元序号
    force(ieqn,1) = force(ieqn,1) + pointload(i,3);     % 并施加载荷
  end
  
  ttim = timing('施加载荷所用时间为：',ttim); %报告时间
  
  j = 0;
  for i = 1 : size(fixnodes,1)
    ieqn = (fixnodes(i,1)-1)*5 + fixnodes(i,2);  
    u(ieqn) = fixnodes(i,3);                  
    j = j + 1;
    fix(j) = ieqn;                        
  end
  
  force1 = force - StifMat * u;      

% 求解计算
% 未知变量：位移u
  FreeNodes = setdiff( 1:nndof , fix );           % 找到未约束节点
                                                  % 求解
  u(FreeNodes) = StifMat(FreeNodes,FreeNodes) \ force1(FreeNodes);

  ttim = timing('求解有限元方程所用时间为：',ttim); %报告时间

% 计算固定节点的支反力
  reaction(fix) = StifMat(fix,1:nndof) * u(1:nndof) - force(fix);

  ttim = timing('求解节点的支反力所用时间为：',ttim); %报告时间

% Compute the stresses
  Strnod = StressCalc(D_matm,D_matb,D_mats,xg,yg,u,coordinates, elements);
  
  ttim = timing('求解节点应力应变所用时间为：',ttim); %报告时间
  
% Graphic representation
  outputTXT(u,reaction,la,Strnod,coordinates, elements); 

  ttim = timing('输出运算结果所用时间为：',ttim); %报告时间
  itim = toc;                                               %关闭计时器
  fprintf(1,'\n总运行时长 %12.6f \n\n',ttim); %报告时间
  
