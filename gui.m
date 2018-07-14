function varargout =gui(varargin) 
gui_Singleton = 1;
%����һ��fig����������Ľṹ�庯��
%gui_State��һ���ṹ ���ƶ���figure�򿪺�����ĺ��� 
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton', gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end
if nargout
    [varargout{1:nargout}] =gui_mainfcn(gui_State, varargin{:});
else
   gui_mainfcn(gui_State, varargin{:});
end
%���϶����Զ����ɵ�

%��������������ʼ��
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
%�����ﶨ���Լ������ݽṹ
%������������������������
%����handles�����ݽṹ,�ǳ���Ҫ��

guidata(hObject, handles);

%�����������ֵ�Ķ���
%ע�⣺matlab�� ��function��Ӧ��end����û�У��������Ű汾�ĸ��£�end�ᱻҪ��

function varargout =gui_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
%�������ݣ�
%��MATLAB GUI�����н���ֵ���ݣ�
%1.������������handles���ݽṹ��ֵ
%2.���ÿؼ�UserData�����д�ֵ



%����ͼ��
function pushbutton1_Callback(hObject, eventdata, handles)
[filename, pathname]=uigetfile({'*.jpg';'*.bmp'}, 'File Selector');%ͨ������·�����ҵ���ͼƬ
I=imread([pathname '\' filename]);%��ȡ��ͼƬ������ʾ
handles.I=I;%���þ������I��Դ ������ʾͼƬ
%��������
guidata(hObject, handles);
%��������ʽ��ͼ��ͼƬ ��ʾ �ڴ�����ʽ��ͼ��
axes(handles.axes1);
imshow(I);title('ԭͼ');





%����ͼ����
function pushbutton2_Callback(hObject, eventdata, handles)
I=handles.I;%������ ������ ��ȡ ��Դ 
%rgb2gray�Ǵ���ͼ��ĺ�����ͨ������ͼ��ɫ���ͱ��Ͷ���Ϣͬ�±�����������ʵ��
%����RGBͼ����Ų�ɫͼת����ɫͼ�񣬻ҶȻ�����
I1=rgb2gray(I);
%edge����������ָ����������ֵthresh��0.16��������ָ���ķ�������ָ��both ��ˮƽ�ʹ�ֱ��������
%��Sobel���ӽ��б�Ե��⡣
I2=edge(I1,'roberts',0.16,'both');

axes(handles.axes2);
imshow(I1);title('�Ҷ�ͼ');

%axes��������ϵͼ��ϵͼ�ζ���
axes(handles.axes3);

imshow(I2);title('��Ե���');
se=[1;1;1];

I3=imerode(I2,se);%��ʴ����

se=strel('rectangle',[25,25]);%������ָ��ͼ�ζ�Ӧ�Ľṹ��Ԫ�� ����ṹԪ��



I4=imclose(I3,se);%ͼ����࣬���ͼ��

I5=bwareaopen(I4,2000); %ȥ�����ŻҶ�ֵС��2000�Ĳ���

[y,x,z]=size(I5);%����15��ά�ĳߴ磬�洢��x,y,z��
%%
myI=double(I5);
tic      %tic��ʱ��ʼ��toc����
Blue_y=zeros(y,1);%����һ��y*1������

for i=1:y
    for j=1:x
        if(myI(i,j,1)==1)%���myIͼ������Ϊ��i��j����ֵΪ1����������ɫΪ��ɫ��blue��һ
            Blue_y(i,1)=Blue_y(i,1)+1;%��ɫ���ص�ͳ��
        end
    end
end

[temp, MaxY]=max(Blue_y);
%������������������������������������������������������������������������
%Y����������ȷ��
%tempΪ����yellow_y��Ԫ���е����ֵ��MaxYΪ��ֵ������
PY1=MaxY;

while((Blue_y(PY1,1)>=5)&&(PY1>1))
    PY1=PY1-1;
end
PY1 = PY1 - 5;
PY2=MaxY;
while((Blue_y(PY2,1)>=5)&&(PY2<y))
    PY2=PY2+1;
end
PY2 = PY2 + 5 ;
IY=I(PY1:PY2,:,:);

%������������������������������������������������������������������������
%X����������ȷ��
Blue_x=zeros(1,x);%��һ��ȷ��x����ĳ�������
for j=1:x
    for i=PY1:PY2
        if(myI(i,j,1)==1)
            Blue_x(1,j)=Blue_x(1,j)+1;
        end
    end
end
PX1=1;
while((Blue_x(1,PX1)<3)&&(PX1<x))
    PX1=PX1+1;
end
PX2=x;
while((Blue_x(1,PX2)<3)&&(PX2>PX1))
    PX2=PX2-1;
end
%������������������������������������������������������������������������������������
PX1=PX1-3;%�Գ�������Ľ���

PX2=PX2+3;


dw=I(PY1:PY2-8,PX1:PX2,:);
t=toc;

axes(handles.axes4);imshow(dw),title('��λ����');


%------------------------------------------------------------------------------

imwrite(dw,'dw.jpg');%����ɫ����д��dw�ļ���
a=imread('dw.jpg');%��ȡ����
b=rgb2gray(a);%������ͼ��ת��Ϊ�Ҷ�ͼ
imwrite(b,'�Ҷȳ���.jpg');%���Ҷ�ͼд���ļ�
g_max=double(max(max(b)));
g_min=double(min(min(b)));
T=round(g_max-(g_max-g_min)/3);%TΪ��ֵ������ֵ
[m,n]=size(b);

%d =imb2w(b,T/256);
d=(double(b)>=T);%d:��ֵͼ��
imwrite(d,'��ֵ��.jpg');
%________________________________
[r,s]=size(d);
YuJingDingWei=double(d);
X2=zeros(1,s);%����1��s��ȫ������
for i=1:r
    for j=1:s
        if(YuJingDingWei(i,j)==1)
            X2(1,j)= X2(1,j)+1;%��ɫ���ص�ͳ��
        end
    end
end
[g,h]=size(YuJingDingWei);
ZuoKuanDu=0;YouKuanDu=0;KuanDuYuZhi=5;
while sum(YuJingDingWei(:,ZuoKuanDu+1))~=0
    ZuoKuanDu=ZuoKuanDu+1;
end
if ZuoKuanDu<KuanDuYuZhi   % ��Ϊ��������
    YuJingDingWei(:,[1:ZuoKuanDu])=0;%��ͼ��d��1��KuanDu��ȼ�ĵ㸳ֵΪ��
    YuJingDingWei=cut_license(YuJingDingWei); % ֵΪ��ĵ�ᱻ�и�
end
[e,f]=size(YuJingDingWei);%��һ���ü���һ�Σ�������Ҫ�ٴλ�ȡͼ���С
k=f;
while sum(YuJingDingWei(:,k-1))~=0
    YouKuanDu=YouKuanDu+1;
    k=k-1;
end
if YouKuanDu<KuanDuYuZhi   % ��Ϊ���Ҳ����
    YuJingDingWei(:,[(f-YouKuanDu):f])=0;%
    YuJingDingWei=cut_license(YuJingDingWei); %ֵΪ��ĵ�ᱻ�и�
end


h = YuJingDingWei;
g = bwareaopen(h,20);
e = double(g);


%_____________


[p,q]=size(e);
X3=zeros(1,q);%����1��q��ȫ������
for j=1:q
    for i=1:p
       if(e(i,j)==1) 
           X3(1,j)=X3(1,j)+1;
       end
    end
end
%subplot(1,2,2),plot(0:q-1,X3),title('�з������ص�Ҷ�ֵ�ۼƺ�'),xlabel('��ֵ'),ylabel('�ۼ�������');

Px0 = q;%�ַ��Ҳ���
Px1 = p;%�ַ������
for i=1:6
    while((X3(1,Px0)<3)&&(Px0>0))
       Px0=Px0-1;
    end
    Px1=Px0;
    while(((X3(1,Px1)>=3))&&(Px1>0)||((Px0-Px1)<15))
        Px1=Px1-1;
    end
    ChePaiFenGe=g(:,Px1:Px0,:);
    %��ֵ��
    
    imwrite(ChePaiFenGe,strcat('pic_',num2str(i),'.jpg')); 
  %  figure(6);subplot(1,7,8-i);imshow(Ch��ePaiFenGe);
    ii1=int2str(8-i);
    imwrite(ChePaiFenGe,strcat(ii1,'.jpg'));%strcat�����ַ����������ַ�ͼ��
    Px0=Px1;
end
%%%%%%%%%%�Ե�һ���ַ������ر���%%%%%%%%%%%


PX3=Px1;%�ַ�1�Ҳ���

while((X3(1,PX3)<3)&&(PX3>0))
       PX3=PX3-1;
end

ZiFu1DingWei=e(:,1:PX3,:);

%�Զ�Ѱ�� ��ֵ�����ʺϵ���ֵ

thresh = graythresh(ZiFu1DingWei);
ZiFu1DingWei = im2bw(ZiFu1DingWei,thresh);
ZiFu1DingWei=imcomplement(ZiFu1DingWei);
%figure(11);
%imshow(ZiFu1DingWei);
imwrite(ZiFu1DingWei,'head.jpg');

%-------------------------------


%��ֵ�˲�ǰ
%�˲�

h=fspecial('average',3);
%����Ԥ������˲����ӣ�averageΪ��ֵ�˲���ģ��ߴ�Ϊ3*3
d=im2bw(round(filter2(h,d)));%ʹ��ָ�����˲���h��h����d����ֵ�˲�
imwrite(d,'��ֵ�˲�.jpg');
%ĳЩͼ����в���
%���ͻ�ʴ
se=eye(4);%��λ����
[m,n]=size(d);  %������Ϣ����
if bwarea(d)/m/n>=0.365 %�����ֵͼ���ж�������������������ı��Ƿ����0.365
    d=imerode(d,se); %�������0.365����и�ʴ
elseif bwarea(d)/m/n<=0.235%�����ֵͼ���ж�ֵ�Ƿ�С��0.235
    d=imdilate(d,se); %%���С����ʵ�����Ͳ���������������������ı�
end
d=bwareaopen(d,100); 
imwrite(d,'����.jpg');

%Ѱ�����������ֵĿ飬�����ȴ���ĳ��ֵ������Ϊ�ÿ��������ַ���ɣ���Ҫ�ָ�
d = cut_license(d);
[m,n]=size(d);
k1=1;
k2=1;
s=sum(d);
j=1;

while j~=n
    while s(j)==0
        j=j+1;
    end
    k1=j;
    while s(j)~=0 && j<=n-1
        j=j+1;
    end
    k2=j-1;
    if k2-k1>=round(n/6.5)
        [val,num]=min(sum(d(:,[k1+5:k2-5])));
        d(:,k1+num + 5)=0;%�ָ�
    end
end
%���и�
d=cut_license(d);
%�и��7���ַ�
y1=10;
y2=0.25;
flag=0;
word1=[];
while flag==0
    [m,n]=size(d);
    left=1;
    wide=0;
    while sum(d(:,wide+1))~=0&&wide <= n-2
        wide=wide+1;
    end
    if wide<y1 %��Ϊ������� f
        d(:,[1:wide])=0;
        d=cut_license(d);
    else
        temp=cut_license(imcrop(d,[1 1 wide m]));
        [m,n]=size(temp);
        all=sum(sum(temp));
        two_thirds=sum(sum(temp([round(m/3):2*round(m/3)],:)));
          if two_thirds/all>y2
              flag=1;word1=temp;%word1
          end
        d(:,[1:wide])=0;d=cut_license(d);
    end
end

%%
pic_1 = imread('pic_6.jpg');
thresh = graythresh(pic_1);
pic_1 = im2bw(pic_1,thresh);
pic_1=imcomplement(pic_1);
pic_2 = imread('pic_5.jpg');
thresh = graythresh(pic_2);
pic_2 = im2bw(pic_2,thresh);
pic_2=imcomplement(pic_2);
pic_3 = imread('pic_4.jpg');
thresh = graythresh(pic_3);
pic_3 = im2bw(pic_3,thresh);
pic_3=imcomplement(pic_3);
pic_4 = imread('pic_3.jpg');
thresh = graythresh(pic_4);
pic_4 = im2bw(pic_4,thresh);
pic_4=imcomplement(pic_4);
pic_5 = imread('pic_2.jpg');
thresh = graythresh(pic_5);
pic_5 = im2bw(pic_5,thresh); 
pic_5=imcomplement(pic_5);
pic_6 = imread('pic_1.jpg');
thresh = graythresh(pic_6);
pic_6 = im2bw(pic_6,thresh); 
pic_6=imcomplement(pic_6);

%����ϵͳ�����й�һ����СΪ40*20
ZiFu1DingWei=imresize(ZiFu1DingWei,[110 55],'bilinear');
word1=imresize(pic_1,[110 55],'bilinear');
word2=imresize(pic_2,[110 55],'bilinear');
word3=imresize(pic_3,[110 55],'bilinear');
word4=imresize(pic_4,[110 55],'bilinear');
word5=imresize(pic_5,[110 55],'bilinear');
word6=imresize(pic_6,[110 55],'bilinear');


axes(handles.axes5);imshow(ZiFu1DingWei),title('1');
axes(handles.axes6);imshow(word1),title('2');
axes(handles.axes7);imshow(word2),title('3');
axes(handles.axes8);imshow(word3),title('4');
axes(handles.axes9);imshow(word4),title('5');
axes(handles.axes10);imshow(word5),title('6');
axes(handles.axes11);imshow(word6),title('7');
%%
%����ʶ��
HanZi=DuQuHanZi(imread('MuBanKu\sichuan.bmp'),imread('MuBanKu\guizhou.bmp'),imread('MuBanKu\beijing.bmp'),imread('MuBanKu\chongqing.bmp'),...
                imread('MuBanKu\guangdong.bmp'),imread('MuBanKu\shandong.bmp'),imread('MuBanKu\zhejiang.bmp'));
ShuZiZiMu=DuQuSZZM(imread('MuBanKu\0.bmp'),imread('MuBanKu\1.bmp'),imread('MuBanKu\2.bmp'),imread('MuBanKu\3.bmp'),imread('MuBanKu\4.bmp'),...
                   imread('MuBanKu\5.bmp'),imread('MuBanKu\6.bmp'),imread('MuBanKu\7.bmp'),imread('MuBanKu\8.bmp'),imread('MuBanKu\9.bmp'),...
                   imread('MuBanKu\10.bmp'),imread('MuBanKu\11.bmp'),imread('MuBanKu\12.bmp'),imread('MuBanKu\13.bmp'),imread('MuBanKu\14.bmp'),...
                   imread('MuBanKu\15.bmp'),imread('MuBanKu\16.bmp'),imread('MuBanKu\17.bmp'),imread('MuBanKu\18.bmp'),imread('MuBanKu\19.bmp'),...
                   imread('MuBanKu\20.bmp'),imread('MuBanKu\21.bmp'),imread('MuBanKu\22.bmp'),imread('MuBanKu\23.bmp'),imread('MuBanKu\24.bmp'),...
                   imread('MuBanKu\25.bmp'),imread('MuBanKu\26.bmp'),imread('MuBanKu\27.bmp'),imread('MuBanKu\28.bmp'),imread('MuBanKu\29.bmp'),...
                   imread('MuBanKu\30.bmp'),imread('MuBanKu\31.bmp'),imread('MuBanKu\32.bmp'),imread('MuBanKu\33.bmp'));
ZiMu=DuQuZiMu(imread('MuBanKu\10.bmp'),imread('MuBanKu\11.bmp'),imread('MuBanKu\12.bmp'),imread('MuBanKu\13.bmp'),imread('MuBanKu\14.bmp'),...
              imread('MuBanKu\15.bmp'),imread('MuBanKu\16.bmp'),imread('MuBanKu\17.bmp'),imread('MuBanKu\18.bmp'),imread('MuBanKu\19.bmp'),...
              imread('MuBanKu\20.bmp'),imread('MuBanKu\21.bmp'),imread('MuBanKu\22.bmp'),imread('MuBanKu\23.bmp'),imread('MuBanKu\24.bmp'),...
              imread('MuBanKu\25.bmp'),imread('MuBanKu\26.bmp'),imread('MuBanKu\27.bmp'),imread('MuBanKu\28.bmp'),imread('MuBanKu\29.bmp'),...
              imread('MuBanKu\30.bmp'),imread('MuBanKu\31.bmp'),imread('MuBanKu\32.bmp'),imread('MuBanKu\33.bmp'));
ShuZi=DuQuShuZi(imread('MuBanKu\0.bmp'),imread('MuBanKu\1.bmp'),imread('MuBanKu\2.bmp'),imread('MuBanKu\3.bmp'),imread('MuBanKu\4.bmp'),...
                imread('MuBanKu\5.bmp'),imread('MuBanKu\6.bmp'),imread('MuBanKu\7.bmp'),imread('MuBanKu\8.bmp'),imread('MuBanKu\9.bmp')); 
%%%%%%%%%%%4.3�������ַ�ʶ��%%%%%%%%%%%
t=1;
ZiFu1JieGuo=ShiBieHanZi(HanZi,ZiFu1DingWei);   ShiBieJieGuo(1,t)=ZiFu1JieGuo;t=t+1;
ZiFu2JieGuo=ShiBieZiMu (ZiMu, word1);   ShiBieJieGuo(1,t)=ZiFu2JieGuo;t=t+1;

businessCard = imread('����.jpg'); 
ocrResults = ocr(businessCard); 
recognizedText = ocrResults.Text; 
text(600,150,recognizedText,'BackgroundColor',[1,1,1]); 
%title('ʶ��Ӣ�������'); 
u = strfind(recognizedText,' ');
smap_name = recognizedText(u+1:u+5);
PlateNum = [ShiBieJieGuo,smap_name];
msgbox(PlateNum,'���');
% ==========================�˳�ϵͳ============================
function pushbutton3_Callback(hObject, eventdata, handles)
close(gcf);