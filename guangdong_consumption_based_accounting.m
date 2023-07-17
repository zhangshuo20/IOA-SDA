clear
global k
% nn=42;%��ҵ��,n>2
% m=7;%��������������m>3��������������������зֱ�������EX������IM��
k=0;%����Ͷ������,ʵ����ֻ��k������ȫ�ֱ���

%% ��ȡ���������ݣ��������ݽ��н��
load guangdong_data.mat guangdong
% guangdong_data�еı���guangdongΪԪ�����飬��12��Ԫ�أ���Ϊ43*50�����н���+�����У���EEIO����
% guangdong{i},i=1-12�ֱ��Ӧ���Ϊ1987,1990,1992,1995,1997,2000,2002,2005,2007,2010,2012,2015
for i=1:length(guangdong)
    CEEIO=guangdong{i};

    % %����checkdata������У�������Ƿ���ȷ
    % checkdata(CEEIO,n,m,k); 

    %��Ͷ������������е����루�����˽��ں͵��룬IM�����д�������֮��Ͷ���������������������1��
    CEEIO=data_process_im(CEEIO,3); %���õ�3�ַ�ʽ����Ͷ��������е�IM����3��Ϊ1��3Ϊ��1��2�ַ�ʽ����IM

    %����unpackdata��������CEEIO�������ݽ��
    [Z,V,F,EP,pop]=unpackdata(CEEIO); %ZΪ�м�Ͷ�룬VΪ����Ͷ�룬FΪ��������EPΪ����ѹ����popΪ�˿�
    
    %����Ͷ�����ģ�͵ı�������ѹ��EPI���а���������L
    X=(sum(Z'))'+(sum(F'))';% �������ҵ���ܲ��� X (n*1)
    X(find(X==0))=0.1; %���ܲ���X��Ϊ0����ҵ������һ����С����ֵ0.1���������EPI=EP./X�������
    EPI=EP./X'; %����ҵ����ѹ������ (1*n)
    A=Z*inv(diag(X)); %Ͷ��������м�����ϵ������ (n*n)
    L=eye(length(A))/(eye(length(A))-A); % Leontief�������������ϵ�� (n*n)
    
    %����������������consumption-based�Ļ���ѹ��
    %��������F�ĵ�1:6�зֱ��Ӧũ�����ѡ��������ѡ��������ѡ��̶��ʲ�Ͷ�ʡ�����仯������������+������
    
    C_rural_consumption{i}=EPI*L*diag(F(:,1));%ũ�����ѵĻ���ѹ��������ҵ��
    C_urban_consumption{i}=EPI*L*diag(F(:,2));%�������ѵĻ���ѹ��������ҵ��
    C_government_consumption{i}=EPI*L*diag(F(:,3));%�������ѵĻ���ѹ��������ҵ��
    C_fixed_investment{i}=EPI*L*diag(F(:,4));%�̶��ʲ�Ͷ�ʵĻ���ѹ��������ҵ��
    C_inventory_changes{i}=EPI*L*diag(F(:,5));%����仯�Ļ���ѹ��������ҵ��
    C_outflow{i}=EPI*L*diag(F(:,6));%����仯�Ļ���ѹ��������ҵ��
    
    C_all{i}=EPI*L*diag(sum(F'));%consumption-based ����ѹ�����������������Ļ���ѹ��������ҵ��
    P{i}=EP; %production-based ����ѹ��
end

% ����洢���洢��Ҫ���result(6�������������ҵ�Ļ���ѹ��,�������������Ļ���ѹ���ͻ��������Ļ���ѹ����
sheetname={'1987','1990','1992','1995','1997','2000','2002','2005','2007','2010','2012','2015'};%����������ݱ�ǩ����guangdong���ݶ�Ӧ

for i=1:length(guangdong)    
    
    data=[C_rural_consumption{i}',C_urban_consumption{i}',C_government_consumption{i}',C_fixed_investment{i}',C_inventory_changes{i}',C_outflow{i}',C_all{i}',P{i}']; % �������鼯��data;
    [mm, nn]=size(data);            
    data_cell=mat2cell(data, ones(mm,1), ones(nn,1));    % ��data�и��m*n��cell����
    title={'C_rural_consumption','C_urban_consumption','C_government_consumption','C_fixed_investment','C_inventory_changes','C_outflow','C_all','Production-based'};              % ��ӱ�������
    result= [title; data_cell];                         % ���������ƺ���ֵ�鼯��result
    s1=xlswrite('C:\Users\yuyd\Desktop\�㶫CO2-SDA\results.xlsx',result,sheetname{i},'C3:J45');% ��resultд�뵽�ļ���
    
end


