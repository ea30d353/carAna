%%%%%%%%%%%  ��ȡinp�ļ�ģ����Ϣ %%%%%%%%%%%%
% Դ������ַ��https://www.mathworks.com/matlabcentral/answers/307258-extract-nodes-and-elements-from-abaqus-input-file-to-matlab
%�ó���ɶ�ȡ�������͵�Ԫ(�����Ρ��ı��Ρ���������������)�Ľڵ㼰��Ԫ��Ϣ
%����˵��
%nodes��n��a�еľ���(nΪģ�ͽڵ�������aΪģ��ά��+1(��һ�����ڴ���ڵ���))������άΪ����ÿһ�д���һ���ڵ�ı�ţ�X��Y��Z����(���磺��n�д����n���ڵ�ı�ż�����)
%ele  ��m��b�еľ���(mΪģ�͵�Ԫ������bΪ��Ԫ�ڵ�����+1(��һ�����ڴ��浥Ԫ���))��ÿһ�д���������ɵ�Ԫ�Ľڵ���(���˳��Ϊ�Ȳ�Ԫ�ڵ�˳��)
%fname���ַ������͡������ȡ�ļ�������(���磺sanjiao.inp)����Ҫ������չ����.inp��
%������ֻ�ܶ�ȡģ����Ϣ(�ڵ�λ��nodes����ͨ����ele),�޷���ȡԼ����������Ϣ��Լ����������Ϣ��Ҫ���Լ��������ֶ�����
function [nodes, ele] = readMesh( fname )
fid = fopen(fname,'rt');  %fname�ļ���   r��ȡ  t��txt��ʽ��
S = textscan(fid,'%s','Delimiter','\n'); %�Ѿ��򿪵��ļ�  �ַ�������ʽ��ȡ   'Delimiter','\n'�ָ���Ϊ���з�  Ĭ�Ϸָ���Ϊ�ո�
S = S{1};
%�ҵ�Node�ؼ������ڵ�λ��
idxS = strfind(S, 'NODE');  %����Ԫ������ ��������û����ӦԪ�أ��򷵻ؿ�
idx1 = find(not(cellfun(@isempty, idxS))); %cellfun(fun,A) ��Ԫ������A�ֱ�ʹ�ú���fun   isempty(A) AΪ�շ����߼�ֵ1   find Ѱ�ҷ�0Ԫ�ص�����
%�ҵ�Element�ؼ������ڵ�λ��
idxS = strfind(S, 'ELEMENT');
idx2 = find(not(cellfun(@isempty, idxS)));

% ȡ���ڵ���Ϣ(Ԫ������)
nodes = S(idx1(1)+1:idx2(1)-2);  %��Ԫ��������ʽȡ��
%��Ԫ������ת��Ϊ����
nodes = cell2mat(cellfun(@str2num,nodes,'UniformOutput',false));  %'UniformOutput',false  ��Ԫ����ʽ�������ֵ

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
% ȡ����Ԫ(Ԫ������)
% elements = S(idx2+1:idx3(1)-1) ;

% ��Ԫ������ת��Ϊ����
% ele = cell2mat(cellfun(@str2num,elements,'UniformOutput',false));
nodes=nodes(:,2:end);
ele=ele(:,2:end);
end