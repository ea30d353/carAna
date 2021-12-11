### 申明：本软件使用了多项开源或非开源代码，包括但不限于gmsh（ http://gmsh.info ），MAT-Fem（ http://www.cimne.com/mat-fem/ ），若公开代码损害了这些作者的权益，请联系作者删除。
### Statement: This software uses a number of open source or non-open source codes, including but not limited to gmsh ( http://gmsh.info ), MAT-Fem ( http://www.cimne.com/mat-fem/ ), if The public code damages the rights of you, please contact the authors to delete.
### 汽车外壳设计及分析软件

Writen by MATLAB R2020b

使用python调用gmsh开源库绘制网格

python安装gmsh:
pip install --upgrade gmsh 
可能安装不上，请设置pypi源为清华源

matlab调用python:
指定python可执行文件路径：pyversion('f:\Anaconda3\python.exe')

注意：使用matlab调用python，修改了python代码，MATLAB不会立即使用新的代码，需要重载Python模块
## Note: 重载Python模块
clear classes
obj = py.importlib.import_module('myfun'); %myfun是调用的py文件名
py.importlib.reload(obj);
