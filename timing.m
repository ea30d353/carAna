function t = timing(text,time)

  itim = toc;                           % 关闭上一次计时
  fprintf(1,[text,' %12.6f \n'],itim);  % 输出计时结果
  t = itim + time;                      % 计算时间
  
  tic                                   % 开始新计时

