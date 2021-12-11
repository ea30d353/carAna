### 汽车外壳设计及分析软件

Writen by MATLAB R2020b

使用python调用gmesh开源库绘制网格

python安装gmesh:
pip install --upgrade gmsh 
可能安装不上，请设置pypi源为清华源

matlab调用python:
指定python可执行文件路径：pyversion('f:\Anaconda3\python.exe')

注意：使用matlab调用python，修改了python代码，MATLAB不会立即使用新的代码，需要重载Python模块
# 重载Python模块
clear classes
obj = py.importlib.import_module('myfun'); %myfun是调用的py文件名
py.importlib.reload(obj);