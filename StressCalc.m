function Strnod = StressCalc(D_matm,D_matb,D_mats,xg,yg,u,coordinates, elements)

%求解应力，进行应力磨平等
% 模型基本信息
  npnod  = size(coordinates,1);        % 节点数量
  nelem  = size(elements,1);           % 单元数量
  eqnum  = size(15);
  Strnod = zeros(npnod,9);             % 节点应力
    
% 全局坐标
  Sx  = zeros( nelem , 3 );      
  Sy  = zeros( nelem , 3 );      
  Sxy = zeros( nelem , 3 );      
  Qx  = zeros( nelem , 3 );      
  Qy  = zeros( nelem , 3 );      
  Tx  = zeros( nelem , 3 );      
  Ty  = zeros( nelem , 3 );      
  Txy = zeros( nelem , 3 );      

% 循环每个单元
  for ielem = 1 : nelem
      
    lnods(1:3) = elements(ielem,1:3);
  
    cxyz(1:3,1:3) = coordinates(lnods(1:3),1:3);      % 单元坐标

    Te = shellRotation(cxyz);
    
    ctxy = cxyz*transpose(Te);    % 旋转坐标
    x = ctxy(1:3,1);              % 局部坐标x
    y = ctxy(1:3,2);              % 局部坐标y
    
% 组装单元所用的索引
    for i = 1 : 3
      ii = (i-1)*5;
      eqnum(ii+1) = (lnods(i)-1)*5 + 1 ;   % 单元索引序列
      eqnum(ii+2) = (lnods(i)-1)*5 + 2 ;
      eqnum(ii+3) = (lnods(i)-1)*5 + 3 ;
      eqnum(ii+4) = (lnods(i)-1)*5 + 4 ;
      eqnum(ii+5) = (lnods(i)-1)*5 + 5 ;
    end
    
    u_elem(1:15) = u(eqnum(1:15));

    for igs = 1 : 3
      [bmat_b,bmat_s,bmat_m,area] = B_mat(x,y,xg(igs),yg(igs),Te); 
         
      Str1 = D_matb*bmat_b*transpose(u_elem);
      Str2 = D_mats*bmat_s*transpose(u_elem);
      Str3 = D_matm*bmat_m*transpose(u_elem);

      Sx(ielem,igs)  = Str1(1);
      Sy(ielem,igs)  = Str1(2);
      Sxy(ielem,igs) = Str1(3);
      Qx(ielem,igs)  = Str2(1);
      Qy(ielem,igs)  = Str2(2);
      Tx(ielem,igs)  = Str3(1);
      Ty(ielem,igs)  = Str3(2);
      Txy(ielem,igs) = Str3(3);

    end
    
  end
  
%
% 应力磨平
%
  for ielem = 1 : nelem
 
    lnods(1:3) = elements(ielem,1:3);
 
    for inod = 1 : 3
      igs = inod;
      Strnod(lnods(inod),1) = Strnod(lnods(inod),1) + Sx(ielem,igs);
      Strnod(lnods(inod),2) = Strnod(lnods(inod),2) + Sy(ielem,igs);
      Strnod(lnods(inod),3) = Strnod(lnods(inod),3) + Sxy(ielem,igs);
      Strnod(lnods(inod),4) = Strnod(lnods(inod),4) + Qx(ielem,igs);
      Strnod(lnods(inod),5) = Strnod(lnods(inod),5) + Qy(ielem,igs);
      Strnod(lnods(inod),6) = Strnod(lnods(inod),6) + Tx(ielem,igs);
      Strnod(lnods(inod),7) = Strnod(lnods(inod),7) + Ty(ielem,igs);
      Strnod(lnods(inod),8) = Strnod(lnods(inod),8) + Txy(ielem,igs);
      Strnod(lnods(inod),9) = Strnod(lnods(inod),9) + 1;
    end
  end
  for i = 1 : npnod
    Strnod(i,1:8) = Strnod(i,1:8)/Strnod(i,9);
  end

