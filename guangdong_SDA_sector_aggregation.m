clear
global k
n=42;%��ҵ��,n>2
% m=6;%��������������m>3��������������������зֱ�������EX������IM��
k=0;%����Ͷ������,ʵ����ֻ��k������ȫ�ֱ���

%% ��ȡ���������ݣ��������ݽ��н��
load guangdong_data.mat
% guangdong_dataΪԪ�����飬��12��Ԫ�أ���Ϊ43*50�����н���+�����У���EEIO����
% guangdong_data{i},i=1-12�ֱ��Ӧ���Ϊ1987,1990,1992,1995,1997,2000,2002,2005,2007,2010,2012,2015
MIOT_0=guangdong{1};
MIOT_1=guangdong{12};
% MIOT_1=abs(rand(n+k+1,n+m)*10); %����������� MIOT����ʾͶ�������n*(n+m)
% MIOT_0=abs(rand(n+k+1,n+m)*10); %����������� MIOT����ʾͶ�������n*(n+m)

% %% ��������Ƿ���ȷ
% %����checkdata������У�������Ƿ���ȷ
% checkdata(MIOT_1,n,m,k); 
% checkdata(MIOT_0,n,m,k);

%% ��Ͷ������������е����루�����˽��ں͵��룬IM�����д�������֮��Ͷ���������������������1��
MIOT_0=data_process_im(MIOT_0,3); 
MIOT_1=data_process_im(MIOT_1,3); %���õ�3�ַ�ʽ����Ͷ��������е�IM����3��Ϊ1��3Ϊ��1��2�ַ�ʽ����IM

%% ����Ԫ������CMIOT
CMIOT_1{n-(n-1)}=MIOT_1; 
CMIOT_0{n-(n-1)}=MIOT_0; 
%����Ԫ������CMIOT�����1��Ԫ���Ǿ���MIOT����Ӧ��n����ҵ��
%Ԫ������CMIOT�ĵ�2��Ԫ���Ǿ���MIOT����ϲ�2����ҵ��ľ��󣬶�Ӧ��n-1����ҵ��
%Ԫ������CMIOT�ĵ�i��Ԫ���Ǿ���MIOT����ϲ�i����ҵ��ľ��󣬶�Ӧ��n-(i-1)����ҵ��
%Ԫ������CMIOT�ĵ�n-1��Ԫ���Ǿ���MIOT����ϲ�n-1����ҵ��ľ��󣬶�Ӧ��n-(n-1-1)=2����ҵ��

NM=1000; % �������ؿ���ģ��Ĵ���
for j=1:NM

    for i=2:n-1 % �ӵ�2��Ԫ�أ��ϲ�2����ҵ��ʣ��n-1����ҵ����ʼ������n-1��Ԫ�أ��ϲ�n-1����ҵ��ʣ��2����ҵ������

        %����randnumber2���������ѡ��CMIOT{i-1}����Ҫ�ϲ���2����ҵn1��n2
        [n1,n2]=randnumber2(CMIOT_1{i-1});

        %����merge��������CMIOT{i-1}�����n1��n2������ҵ���кϲ�����Ӧ������ֱ����ӣ�
        CMIOT_1{i}=merge(CMIOT_1{i-1},n1,n2);  % CMIOT�ĵ�i��Ԫ���ǶԵ�i-1��Ԫ�ؽ��кϲ��õ���
        CMIOT_0{i}=merge(CMIOT_0{i-1},n1,n2); 
    end

    for i=1:n-1  % �ӵ�1��Ԫ�أ�n����ҵ����ʼ������n-1��Ԫ�أ�2����ҵ������
        %����unpackdata��������CMIOT{i}�������ݽ��
        [Z1,V1,F1,EP1,pop1]=unpackdata(CMIOT_1{i}) ;
        [Z0,V0,F0,EP0,pop0]=unpackdata(CMIOT_0{i});

        %����variable_calc��������SDA�����6���������м��㡣�ڶ����޵���Ϣ���а����ģ��
        [EPI1,L1,ys1,yc1,pg1,pop1]=variable_calc(Z1,V1,F1,EP1,pop1);
        [EPI0,L0,ys0,yc0,pg0,pop0]=variable_calc(Z0,V0,F0,EP0,pop0);

        % ����SDA�������Ա����ı仯���нṹ�ֽ⣬��¼�ֽ�Ľ�����ӷ��ֽ⣬D&L�㷨
        % SDA�������������a1��a2
        a1{1}=EPI1;
        a1{2}=L1;
        a1{3}=ys1;
        a1{4}=yc1;
        a1{5}=pg1;
        a1{6}=pop1;

        a0{1}=EPI0;
        a0{2}=L0;
        a0{3}=ys0;
        a0{4}=yc0;
        a0{5}=pg0;
        a0{6}=pop0;

        %����SDA�������Ա����ı仯���нṹ�ֽ⣬��¼�ֽ�Ľ������ѡ��SDA_DL����SDA_LMDI����
        % Ea{j,i}=SDA_DL(a0,a1) % Ea{j,i}Ϊ�ϲ�i����ҵ��ʣ��n+1-i����ҵ��ʱ�Ľṹ�ֽ���,�Ѳ���
          % Ea{j,i}��ȻΪ�ṹ���������ÿһ��Ԫ�ض�Ӧa1{l}-a0{l}�ı仯��a1-a0��Ӱ��
          % Ea{i}=SDA_DL(a0,a1) %����SDA_DL�������нṹ�ֽ⣬�ӷ��ֽ⣬D&L�㷨
        
         [Ea{j,i},tEa{j,i}]=SDA_LMDI(a0,a1); %����SDA_LMDI�������нṹ�ֽ⣬�ӷ��ֽ⣬LMDI�㷨;EaΪ����ҵ�Ĺ���,tEaΪ����Ĺ���
        % 

        for h=1:length(a0)
            % temp(j,i,h)=Ea{j,i}{h};%��j�����ؿ���ģ�⣬�ϲ�i����ҵ��2:n-1������h�����ض�a1-a0�仯�����ã��Ѳ���,����SDA_DL
             temp(j,i,h)=tEa{j,i}(h); %�Ѳ���,����SDA_LMDI
        end


    end

end

temp1=0;
for i=1:n-1 
    for h=1:length(a0)
        for j=1:NM
            %temp1=temp1+Ea{j,i}{h}; %�Ѳ���,����SDA_DL
            temp1=temp1+tEa{j,i}(h); %�Ѳ���,����SDA_LMDI
        end        
        aver(i,h)=temp1/NM; %�ϲ�i����ҵ����h�����ض�a1-a0�仯������ͨ�����ؿ���ģ��õ���ƽ��ֵ
        temp1=0;
    end
end

%% ��ͼ
figure(1)
bar(aver(1,:));%������sector aggregationʱ��SDA���


figure(2)
for h=1:length(a0)
    plot((1:n-1)',aver(:,h),'or',(1:n-1)',aver(:,h));    
    hold on
end
hold off
legend('','EPI','','L','','ys','','yc','','pg','','pop')


%�ظ����Ϲ���10000�Σ���ƽ��ֵ����ΪSDA��sector aggreagtion�Ĳ�ȷ����


