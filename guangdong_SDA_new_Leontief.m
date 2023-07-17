clear
global k
% n=42;%��ҵ��,n>2
% m=6;%��������������m>3��������������������зֱ�������EX������IM��
k=1;%����Ͷ������,ʵ����ֻ��k������ȫ�ֱ���

%% ��ȡ���������ݣ��������ݽ��н��
load guangdong_data_SDA.mat guangdong
% guangdong_data_SDA�еı���guangdongΪԪ�����飬��12��Ԫ�أ���Ϊ43*50�����н���+�����У���EEIO����
% guangdong{i},i=1-12�ֱ��Ӧ���Ϊ1987,1990,1992,1995,1997,2000,2002,2005,2007,2010,2012,2015

%% ԭʼ���ݴ���(�ѳ�ʼͶ��Ӻ�Ϊ1�У�����������Ӻ�Ϊ1��)Ϊguangdong_new
for i=1:2
    temp1{i}=[guangdong{i}(1:41,:);sum(guangdong{i}(42:46,:));guangdong{i}(47,:)];
end
for i=3:length(guangdong)
    temp1{i}=[guangdong{i}(1:41,:);sum(guangdong{i}(42:45,:));guangdong{i}(46,:)];
end

for i=1:length(guangdong)
    temp2{i}=[temp1{i}(:,1:41),(sum((temp1{i}(:,42:47))'))'];
end
guangdong_new=temp2; %����õ�����
clear temp1 temp2

%% ��ʼ�ṹ�ֽ�
for i=1:length(guangdong_new)-1
    MIOT_0=guangdong_new{i};
    MIOT_1=guangdong_new{i+1};

% %% ��������Ƿ���ȷ
% %����checkdata������У�������Ƿ���ȷ
% checkdata(MIOT_1,n,m,k); 
% checkdata(MIOT_0,n,m,k);

% %% ��Ͷ������������е����루�����˽��ں͵��룬IM�����д�������֮��Ͷ���������������������1��
% MIOT_0=data_process_im(MIOT_0,3); 
% MIOT_1=data_process_im(MIOT_1,3); %���õ�3�ַ�ʽ����Ͷ��������е�IM����3��Ϊ1��3Ϊ��1��2�ַ�ʽ����IM

 %����unpackdata��������MIOT�������ݽ��
 [Z1,V1,F1,EP1,pop1]=unpackdata(MIOT_1) ;
 [Z0,V0,F0,EP0,pop0]=unpackdata(MIOT_0);

 %����variable_calc_new2��������SDA�����4���������м��㡣�ڶ����޵���Ϣ���а����ģ��
 [EPI1,L1,pf1,G1,pv1,pop1]=variable_calc_new2(Z1,V1,F1,EP1,pop1);
 [EPI0,L0,pf0,G0,pv0,pop0]=variable_calc_new2(Z0,V0,F0,EP0,pop0);

 %% ����SDA��������Leontiefģ��4�������ı仯���нṹ�ֽ⣬��¼�ֽ�Ľ�����ӷ��ֽ�
    %Leontiefģ�ͣ�SDA�������������a1��a2
    a1={EPI1,L1,pf1,pop1};
    a0={EPI0,L0,pf0,pop0};

    %Leontiefģ��,����SDA�������Ա����ı仯���нṹ�ֽ⣬��¼�ֽ�Ľ������ѡ��SDA_DL����SDA_LMDI_new_Leontief����
    temp_Leontief=SDA_DL(a0,a1); % ����SDA_DL�������нṹ�ֽ⣬�ӷ��ֽ⣬D&L�㷨��tempΪ�ṹ���������ÿһ��Ԫ�ض�Ӧa1{l}-a0{l}�ı仯��a1-a0��Ӱ��
    for j=1:length(a0)
        Ea_DL_Leontief(i,j)=temp_Leontief{j};
    end
      
    %����SDA_LMDI�������нṹ�ֽ⣬�ӷ��ֽ⣬LMDI�㷨;
   [temp_sEa_Leotief{i},temp_Ea_Leontief]=SDA_LMDI_new_Leontief(a0,a1); %temp_sEaΪ����ҵ�Ĺ���,temp_EaΪ����Ĺ���
   for j=1:length(a0)
        Ea_LMDI_Leontief(i,j)=temp_Ea_Leontief(j);
   end

end

%% ������D&L��LMDI�㷨�ķֽ���ת��ΪChaining analysis�Ľ��
%����D&L�㷨�ķֽ�����chaining analysis��Ea_DL_chaining(i,k)Ϊ��i���k�����������µ�̼�ŷű仯
%i=1-12�ֱ��Ӧ���Ϊ1987,1990,1992,1995,1997,2000,2002,2005,2007,2010,2012,2015;
%k=1,2,3,4�ֱ��Ӧ����ѹ��ǿ��EPI���а���������L������ṹF���˿�pop
Ea_DL_Leontief=[zeros(1,length(a0));Ea_DL_Leontief];
Ea_DL_chaining_Leontief(1,:)=Ea_DL_Leontief(1,:);
for i=2:length(guangdong)
    Ea_DL_chaining_Leontief(i,:)=sum(Ea_DL_Leontief(1:i,:));    
end

%����LMDI�㷨�ķֽ�����chaining analysis��Ea_LMDI_chaining(i,k)Ϊ��i���k�����������µ�̼�ŷű仯
%i=1-12�ֱ��Ӧ���Ϊ1987,1990,1992,1995,1997,2000,2002,2005,2007,2010,2012,2015;
%k=1,2,3,4,5,6�ֱ��Ӧ����ѹ��ǿ�ȡ��а�������������ṹ�����󹹳ɡ��˾������˿�
Ea_LMDI_Leontief=[zeros(1,length(a0));Ea_LMDI_Leontief];
Ea_LMDI_chaining_Leontief(1,:)=Ea_LMDI_Leontief(1,:);
for i=2:length(guangdong)
    Ea_LMDI_chaining_Leontief(i,:)=sum(Ea_LMDI_Leontief(1:i,:));    
end

%% Chaining analysis�Ľ����ͼ
year=[1987,1990,1992,1995,1997,2000,2002,2005,2007,2010,2012,2015];
year=year';

figure(1)
plot(year,Ea_DL_chaining_Leontief(:,1),year,Ea_DL_chaining_Leontief(:,2),year,Ea_DL_chaining_Leontief(:,3),year,Ea_DL_chaining_Leontief(:,4))
legend('dEPI','dL','dpf','dpop')
xlabel('year')
ylabel('changes of CO2 (Mt)')
title('D&L decomposition agrithom')

figure(2)
plot(year,Ea_LMDI_chaining_Leontief(:,1),year,Ea_LMDI_chaining_Leontief(:,2),year,Ea_LMDI_chaining_Leontief(:,3),year,Ea_LMDI_chaining_Leontief(:,4))
legend('dEPI','dL','dpf','dpop')
xlabel('year')
ylabel('changes of CO2 (Mt)')
title('LMDI decomposition agrithom')

%% ����LMDI�㷨�����������ķ���ҵ���ף���sectoral contribution 
[mm,nn]=size(temp_sEa_Leotief{1});
sEa_chaining_Leontief{1}=zeros(mm,nn);
% sEa_chaining{2}=sEa_chaining{1}+temp_sEa{1};
% sEa_chaining{3}=sEa_chaining{2}+temp_sEa{2};
for i=1:length(guangdong)-1
    sEa_chaining_Leontief{i+1}=sEa_chaining_Leontief{i}+temp_sEa_Leotief{i};
end
% Ԫ������sEa_chaining��Ԫ������guangdong�ĳ�����ͬ��i=1-12�ֱ��Ӧ���Ϊ1987,1990,1992,1995,1997,2000,2002,2005,2007,2010,2012,2015
% sEa_chaining{i}(j,k)��ʾ��i����ݣ���k���������ڵ�j����ҵ��ֵ
% ��ģ���зֽ�õ�������������4�֣���k=1,2,3,4�ֱ��Ӧ����ѹ��ǿ�ȡ��а�������������ṹ���˿�
% ��ҵ�ķ����������ȷ��

%% ����洢���洢��Ҫ���result(6�������������ҵ�Ļ���ѹ��,�������������Ļ���ѹ���ͻ��������Ļ���ѹ����

sheetname={'1987','1990','1992','1995','1997','2000','2002','2005','2007','2010','2012','2015'};%����������ݱ�ǩ����guangdong���ݶ�Ӧ

for i=1:length(guangdong)       
    data=[sEa_chaining_Leontief{i}(:,1),sEa_chaining_Leontief{i}(:,2),sEa_chaining_Leontief{i}(:,3),sEa_chaining_Leontief{i}(:,4)]; % �������鼯��data;
    [mm, nn]=size(data);            
    data_cell=mat2cell(data, ones(mm,1), ones(nn,1));    % ��data�и��m*n��cell����
    title={'CO2 intensity','Leontief inverse','final demand structure','population'};% ��ӱ�������
    result= [title; data_cell];                         % ���������ƺ���ֵ�鼯��result
    s1=xlswrite('C:\Users\yuyd\Desktop\�㶫CO2-SDA\results_new.xlsx',result,sheetname{i},'R3:U44');% ��sEa_chaining�Ľ��д�뵽�ļ���Ӧλ��   
end

s2=xlswrite('C:\Users\yuyd\Desktop\�㶫CO2-SDA\results_new.xlsx',Ea_DL_Leontief,'SDA-LMDI&DL','D4:G15');% ��Ea_DL�Ľ��д�뵽�ļ���Ӧλ�� 
s3=xlswrite('C:\Users\yuyd\Desktop\�㶫CO2-SDA\results_new.xlsx',Ea_DL_chaining_Leontief,'SDA-LMDI&DL','L4:O15');% ��Ea_DL_chaining�Ľ��д�뵽�ļ���Ӧλ��
s2=xlswrite('C:\Users\yuyd\Desktop\�㶫CO2-SDA\results_new.xlsx',Ea_LMDI_Leontief,'SDA-LMDI&DL','D20:G31');% ��Ea_LMDI�Ľ��д�뵽�ļ���Ӧλ��
s3=xlswrite('C:\Users\yuyd\Desktop\�㶫CO2-SDA\results_new.xlsx',Ea_LMDI_chaining_Leontief,'SDA-LMDI&DL','L20:O31');% ��Ea_LMDI_chaining�Ľ��д�뵽�ļ���Ӧλ��
