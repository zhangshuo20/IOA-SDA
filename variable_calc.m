function [EPI, L, ys, yc, pg, pop]=variable_calc(Z,V,F,EP,pop)
% variable_calc函数用于计算结构分解的6个变量，环境压力计算公式为 EP=EPI*L*ys*yc*pg*pop; 
% variable_calc函数还可以计算生产视角的环境压力P和消费视角的环境压力C，需要打开最后几行的注释,并且把C, tC加入到函数的输出中
% 目前用的是列昂惕夫模型，数据为投入产出表的第1和2象限。V暂时不用，但也作为输入，方便后续进行扩展
% Z,V,F分别为投入产出表的中间流量矩阵(n*n)、最终投入矩阵(k*n)、最终需求矩阵(n*m)；EP为分行业的环境压力(1*n)，pop为人口数(1*1)

%% 计算结构分解的6个变量EP=EPI*L*ys*yg*g*pop;

% 计算分行业的总产出 X (n*1)
X=(sum(Z'))'+(sum(F'))';
X(find(X==0))=0.1; %产出为0的行业的产出设置为0.1，否则X的元素作为分母，后续会有NAN的情况

EPI=EP./X'; %分行业环境压力计算 (1*n)
A=Z*inv(diag(X)); %投入产出表中间流量系数计算 (n*n)
L=eye(length(A))/(eye(length(A))-A); % Leontief逆矩阵，最终需求系数 (n*n)

ys=F*inv(diag(sum(F)));%最终需求结构(n*m)
yc=sum(F)/sum(sum(F));%最终需求构成(1*m)
yc=yc';%最终需求转置为(m*1)向量

pg=sum(sum(F))/pop; %人均最终需求，注意，此处将投入产出表得到的GDP即sum(sum(F))代替实际发布的数据gdp，从而统一了两类数据的差异
pop=pop;

%% 以下代码的功能与上述计算的功能相同，但效率较低 
% % 计算分行业的环境压力强度指标EPI(1*n)
% for i=1:length(Z)
%     EPI(i)=EP(i)/X(i);
% end
% 
% % 计算中间流量系数 A (n*n)
% for i=1:length(Z)
%     for j=1:length(Z)
%         A(i,j)=Z(i,j)/X(j);
%     end
% end
% 
% % 计算Leontief逆矩阵 L
% % b/a=b*inv(a)
% L=eye(length(A))/(eye(length(A))-A); % Leontief逆矩阵，最终需求系数
% 
% 
% % 计算ys,yg和g，在数学关系上 F=ys*yc*g; gdp=pg*pop （矩阵运算）
% [n,m]=size(F); % F的行数n（行业数量）和列数m（最终需求的种类）
% sf=sum(F); %各类最终需求的分行业流量总和（如总的农村居民消费等）,sum函数对矩阵F(n*m) 的行进行求和，得到sf(1*m)
% ssf=sum(sf); %计算各类最终需求流量总和，即支出法GDP，该数据与实际发布的GDP数据（输入的gdp变了）有一定的差异（国家层面亦有差异），如需统一两类数据，可利用发布的GDP数据和计算出来的投入产出表的各流量系数对投入产出表的流量进行等比例缩放）
% yc=sf/ssf; % 最终需求构成 (1*m)
% yc=yc'; % 转置 (m*1)
% for i=1:n
%     for j=1:m
%         ys(i,j)=F(i,j)/sf(j); %最终需求结构系数 ys
%     end
% end
% pg=ssf/pop; %人均最终需求，注意，此处将投入产出表得到的GDP即ssf代替实际发布的数据gdp，从而统一了两类数据的差异

%% 计算生产视角的环境压力P和消费视角的环境压力C 
% % 生产视角的环境压力P
% P=EPI*diag(X); % P与EP相等，分行业的环境压力

% % 消费视角的环境压力C
% for i=1:m % b为最终需求的种类
%     C{i}=EPI*L*diag(F(:,i)); %第i种最终需求（如消费）所诱导的环境压力（分行业）
% end
% tC=EPI*L*diag(sum(F')); %所有最终需求所诱导的环境压力（分行业）

end

