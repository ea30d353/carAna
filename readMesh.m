%%%%%%%%%%%  读取inp文件模型信息 %%%%%%%%%%%%
% 源代码网址：https://www.mathworks.com/matlabcentral/answers/307258-extract-nodes-and-elements-from-abaqus-input-file-to-matlab
%该程序可读取多种类型单元(三角形、四边形、三棱柱、六面体)的节点及单元信息
%变量说明
%nodes：n行a列的矩阵(n为模型节点总数，a为模型维度+1(第一列用于储存节点编号))。以三维为例，每一行代表一个节点的编号，X，Y，Z坐标(例如：第n行代表第n个节点的编号及坐标)
%ele  ：m行b列的矩阵(m为模型单元总数，b为单元节点数量+1(第一列用于储存单元编号))。每一行代表用于组成单元的节点编号(编号顺序为等参元节点顺序)
%fname：字符串类型。代表读取文件的名称(例如：sanjiao.inp)，不要丢掉扩展名（.inp）
%本程序只能读取模型信息(节点位置nodes及连通矩阵ele),无法读取约束及外载信息，约束及外载信息需要在自己程序中手动加入
function [nodes, ele] = readMesh( fname )
fid = fopen(fname,'rt');  %fname文件名   r读取  t以txt格式打开
S = textscan(fid,'%s','Delimiter','\n'); %已经打开的文件  字符向量形式读取   'Delimiter','\n'分隔符为换行符  默认分隔符为空格
S = S{1};
%找到Node关键字所在的位置
idxS = strfind(S, 'NODE');  %返回元胞数组 若数组中没有相应元素，则返回空
idx1 = find(not(cellfun(@isempty, idxS))); %cellfun(fun,A) 对元胞数组A分别使用函数fun   isempty(A) A为空返回逻辑值1   find 寻找非0元素的索引
%找到Element关键字所在的位置
idxS = strfind(S, 'ELEMENT');
idx2 = find(not(cellfun(@isempty, idxS)));

% 取出节点信息(元胞数组)
nodes = S(idx1(1)+1:idx2(1)-2);  %以元胞数组形式取出
%将元胞数组转换为矩阵
nodes = cell2mat(cellfun(@str2num,nodes,'UniformOutput',false));  %'UniformOutput',false  以元胞形式返回输出值

ele=[];
for i=1:1:size(idx2,1)
    if i == size(idx2, 1)
        eval(['element_', num2str(i), ' = S(idx2(i)+1:size(S, 1)) ;']);
    else
        eval(['element_', num2str(i), ' = S(idx2(i)+1:idx2(i+1)-1) ;']);
    end
    eval(['ele_', num2str(i), ' = cell2mat(cellfun(@str2num,element_', num2str(i),',''UniformOutput'',false));']);
    eval(['if size(ele_', num2str(i), ', 2) == 4', ' ele = [ele; ele_', num2str(i), '];, end']);
%     eval(['ele = [ele; ele_', num2str(i), '];']);
%     eval('end');
end
% 取出单元(元胞数组)
% elements = S(idx2+1:idx3(1)-1) ;

% 将元胞数组转换为矩阵
% ele = cell2mat(cellfun(@str2num,elements,'UniformOutput',false));
nodes=nodes(:,2:end);
ele=ele(:,2:end);
end