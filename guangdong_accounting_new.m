%% ��������������ӽǵĻ���ѹ��EP_P�������ӽǵĻ���ѹ��EP_C �������ӽǵĻ���ѹ��EP_I

clear
global k
% nn=41;%��ҵ��,n>2
% m=7;%��������������m>3��������������������зֱ�������EX������IM��
k=4;%����Ͷ������,ʵ����ֻ��k������ȫ�ֱ�����1987��1990��,k=5;1992-2015��,k=4

%% ��ȡ���������ݣ��������ݽ��н��
load guangdong_data_SDA.mat guangdong
% guangdong_data_accounting�еı���guangdongΪԪ�����飬��12��Ԫ�أ���Ϊ43*50�����н���+�����У���EEIO����
% guangdong{i},i=1-12�ֱ��Ӧ���Ϊ1987,1990,1992,1995,1997,2000,2002,2005,2007,2010,2012,2015
for i=3:length(guangdong)
    CEEIO=guangdong{i};

    % %����checkdata������У�������Ƿ���ȷ
    % checkdata(CEEIO,n,m,k); 

    %��Ͷ������������е����루�����˽��ں͵��룬IM�����д�������֮��Ͷ���������������������1��
    %CEEIO=data_process_im(CEEIO,3); %���õ�3�ַ�ʽ����Ͷ��������е�IM����3��Ϊ1��3Ϊ��1��2�ַ�ʽ����IM

    %����unpackdata��������CEEIO�������ݽ��
    [Z,V,F,EP,pop]=unpackdata(CEEIO); %ZΪ�м�Ͷ�룬VΪ����Ͷ�룬FΪ��������EPΪ����ѹ����popΪ�˿�
    
    %����Leontiefģ�ͺ�Goshģ�͵ĸ��ֱ���
    X=(sum(Z'))'+(sum(F'))';% �������ҵ���ܲ��� X (n*1)
    X(find(X==0))=0.1; %���ܲ���X��Ϊ0����ҵ������һ����С����ֵ0.1���������EPI=EP./X�������
    EPI=EP./X'; %����ҵ����ѹ������ (1*n)
    A=Z*inv(diag(X)); %Leontiefģ�ͣ�Ͷ��������м�����ϵ������ (n*n)
    L=eye(length(A))/(eye(length(A))-A); % Leontief�������ȫ����Ͷ�룩ϵ�� (n*n)
    B=inv(diag(X))*Z; %Goshģ�ͣ�Ͷ�������ֱ�Ӳ��������䣩ϵ������ (n*n)
    G=eye(length(B))/(eye(length(B))-B); % Gosh�������ȫ����ϵ�� (n*n)
    
    
    %%������������ӽ��µĻ���ѹ��
    % �����ӽǵĻ���ѹ��EP_P
    EP_P{i}=EPI*diag(X); % EP_P��EP��ȣ�����ҵ�Ļ���ѹ��

    % �����ӽǵĻ���ѹ��EP_C
    [n,mm]=size(F);
    for j=1:mm % mmΪ�������������,mm=6
        EP_C{i,j}=EPI*L*diag(F(:,j)); %��j���������������ѣ����յ��Ļ���ѹ��������ҵ��
    end
    %mm=6,F���ݵ�1:6�зֱ��Ӧũ�����ѡ��������ѡ��������ѡ��̶��ʲ�Ͷ�ʡ�����仯������������+������
    EP_tC{i}=EPI*L*diag(sum(F')); %���������������յ��Ļ���ѹ��������ҵ��

    % �����ӽǵĻ���ѹ��EP_I
    [kk,n]=size(V);
    for j=1:kk % kkΪ����Ͷ�������,kk=5��4
        EP_I{i,j}=diag(V(j,:))*G*EPI'; %��j������Ͷ�루��̶��ʲ��۾ɣ����յ��Ļ���ѹ��������ҵ��
    end
    %kk=5,1987-1990��V���ݵĵ�1:5�зֱ�Ϊ�̶��ʲ��۾ɡ��Ͷ������롢�������������˰��������
    %kk=4,1992-2015��V���ݵĵ�1:4�зֱ��Ӧ�̶��ʲ��۾ɡ���ҵ��Ա���ꡢ����˰���Ӫҵӯ��
    EP_tI{i}=diag(sum(V))*G*EPI'; %���������������յ��Ļ���ѹ��������ҵ��
    
end

%% ����洢���洢��Ҫ���result(6�������������ҵ�Ļ���ѹ��,�������������Ļ���ѹ���ͻ��������Ļ���ѹ����
sheetname={'1987','1990','1992','1995','1997','2000','2002','2005','2007','2010','2012','2015'};%����������ݱ�ǩ����guangdong���ݶ�Ӧ

%%1987��1990�꣬income-based������Ͷ����5�����������
% for i=1:2    
%     
%     data=[EP_P{i}',EP_C{i,1}',EP_C{i,2}',EP_C{i,3}',EP_C{i,4}',EP_C{i,5}',EP_C{i,6}',EP_tC{i}',...
%         EP_I{i,1},EP_I{i,2},EP_I{i,3},EP_I{i,4},EP_I{i,5},EP_tI{i}]; % �������鼯��data;
%     [mm, nn]=size(data);            
%     data_cell=mat2cell(data, ones(mm,1), ones(nn,1));    % ��data�и��m*n��cell����
%     title={'Production-based','C_rural_consumption','C_urban_consumption','C_government_consumption','C_fixed_investment','C_inventory_changes','C_outflow','C_all','I_fixed assets depreciation', 'I_income of workers', 'I_welfare funds', 'I_profits and taxes','I_others','I_all'};              % ��ӱ�������
%     result= [title; data_cell];                         % ���������ƺ���ֵ�鼯��result
%     s1=xlswrite('C:\Users\yuyd\Desktop\�㶫CO2-SDA\results_new.xlsx',result,sheetname{i},'C3:P44');% ��resultд�뵽�ļ���
%     
% end

%1992-2015�꣬income-based������Ͷ��Ϊ4������׼�����
for i=3:length(guangdong)    
    
    data=[EP_P{i}',EP_C{i,1}',EP_C{i,2}',EP_C{i,3}',EP_C{i,4}',EP_C{i,5}',EP_C{i,6}',EP_tC{i}',...
        EP_I{i,1},EP_I{i,2},EP_I{i,3},EP_I{i,4},EP_tI{i}]; % �������鼯��data;
    [mm, nn]=size(data);            
    data_cell=mat2cell(data, ones(mm,1), ones(nn,1));    % ��data�и��m*n��cell����
    title={'Production-based','C_rural_consumption','C_urban_consumption','C_government_consumption','C_fixed_investment','C_inventory_changes','C_outflow','C_all','I_fixed assets depreciation', 'I_remuneration for employees', 'I_net production tax', 'I_operating surplus','I_all'};              % ��ӱ�������
    result= [title; data_cell];                         % ���������ƺ���ֵ�鼯��result
    s1=xlswrite('C:\Users\yuyd\Desktop\�㶫CO2-SDA\results_new.xlsx',result,sheetname{i},'C3:O44');% ��resultд�뵽�ļ���
    
end


