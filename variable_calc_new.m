function [EPI, L, pf, G, pv, pop]=variable_calc_new(Z,V,F,EP,pop)
% variable_calc_new函数用于计算结构分解的4个变量，环境压力计算公式为 EP=EPI*L*pf*pop; 
% 注意：F的列大于1，V的行大于1。否则计算出错
% variable_calc_new函数还可以计算生产视角的环境压力EP_P、消费视角的环境压力EP_C 、收入视角的环境压力EP_I，需要打开最后几行的注释,并且把EP_C, EP_tC,EP_I,EP_tI加入到函数的输出中
% 目前用的是Leontief模型和Gosh模型
% Z,V,F分别为投入产出表的中间流量矩阵(n*n)、最终投入矩阵(k*n)、最终需求矩阵(n*m)；EP为分行业的环境压力(1*n)，pop为人口数(1*1)

%% 计算结构分解的4个变量
% 基于Leontief模型的环境投入产出模型 EP=EPI*L*pf*pop;
% 基于Gosh模型的环境投入产出模型     EP=pop*pv*G*EPI';

% 计算分行业的总产出 X (n*1)
X=(sum(Z'))'+(sum(F'))';
X(find(X==0))=0.1; %产出为0的行业的产出设置为0.1，否则X的元素作为分母，后续会有NAN的情况

EPI=EP./X'; %分行业环境压力计算 (1*n)
A=Z*inv(diag(X)); %投入产出表直接投入（消耗）系数计算 (n*n)
L=eye(length(A))/(eye(length(A))-A); % Leontief逆矩阵，完全需求（投入）系数 (n*n)

% ys=F*inv(diag(sum(F)));%最终需求结构(n*m)
% yc=sum(F)/sum(sum(F));%最终需求构成(1*m)
% yc=yc';%最终需求转置为(m*1)向量
% pg=sum(sum(F))/pop; %人均最终需求，注意，此处将投入产出表得到的GDP即sum(sum(F))代替实际发布的数据gdp，从而统一了两类数据的差异
% py=ys*yc*pg;

pf=(sum(F'))'/pop; %最终需求的列向量（n*1）
pop=pop;

B=inv(diag(X))*Z; %投入产出表直接产出（分配）系数计算 (n*n)
G=eye(length(B))/(eye(length(B))-B); % Gosh逆矩阵，完全分配系数 (n*n)
pv=sum(V)/pop; %最终投入的行向量（1*n）

end

