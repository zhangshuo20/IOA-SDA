function [EPI, L, pf, G, pv, pop]=variable_calc_new(Z,V,F,EP,pop)
% variable_calc_new�������ڼ���ṹ�ֽ��4������������ѹ�����㹫ʽΪ EP=EPI*L*pf*pop; 
% ע�⣺F���д���1��V���д���1������������
% variable_calc_new���������Լ��������ӽǵĻ���ѹ��EP_P�������ӽǵĻ���ѹ��EP_C �������ӽǵĻ���ѹ��EP_I����Ҫ������е�ע��,���Ұ�EP_C, EP_tC,EP_I,EP_tI���뵽�����������
% Ŀǰ�õ���Leontiefģ�ͺ�Goshģ��
% Z,V,F�ֱ�ΪͶ���������м���������(n*n)������Ͷ�����(k*n)�������������(n*m)��EPΪ����ҵ�Ļ���ѹ��(1*n)��popΪ�˿���(1*1)

%% ����ṹ�ֽ��4������
% ����Leontiefģ�͵Ļ���Ͷ�����ģ�� EP=EPI*L*pf*pop;
% ����Goshģ�͵Ļ���Ͷ�����ģ��     EP=pop*pv*G*EPI';

% �������ҵ���ܲ��� X (n*1)
X=(sum(Z'))'+(sum(F'))';
X(find(X==0))=0.1; %����Ϊ0����ҵ�Ĳ�������Ϊ0.1������X��Ԫ����Ϊ��ĸ����������NAN�����

EPI=EP./X'; %����ҵ����ѹ������ (1*n)
A=Z*inv(diag(X)); %Ͷ�������ֱ��Ͷ�루���ģ�ϵ������ (n*n)
L=eye(length(A))/(eye(length(A))-A); % Leontief�������ȫ����Ͷ�룩ϵ�� (n*n)

% ys=F*inv(diag(sum(F)));%��������ṹ(n*m)
% yc=sum(F)/sum(sum(F));%�������󹹳�(1*m)
% yc=yc';%��������ת��Ϊ(m*1)����
% pg=sum(sum(F))/pop; %�˾���������ע�⣬�˴���Ͷ�������õ���GDP��sum(sum(F))����ʵ�ʷ���������gdp���Ӷ�ͳһ���������ݵĲ���
% py=ys*yc*pg;

pf=(sum(F'))'/pop; %�����������������n*1��
pop=pop;

B=inv(diag(X))*Z; %Ͷ�������ֱ�Ӳ��������䣩ϵ������ (n*n)
G=eye(length(B))/(eye(length(B))-B); % Gosh�������ȫ����ϵ�� (n*n)
pv=sum(V)/pop; %����Ͷ�����������1*n��

end

