clc;
clear;
close all;
nstep = 0;
path = '/Users/karen/Desktop/未命名文件夹\ 2';
filename= dir(path);
position=[];
r=27;
pm=[];
for a = 1:length(filename)
    files = dir([path,'/',filename(a).name,'/', '*.jpg']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%为了比对棋盘的颜色,取了0.1处的图片,取了该图片的上0.3占比的一个方块,获取他的平均rgb.
    first=floor(0.1*length(files));
    second=floor(0.5*length(files));
    third=floor(0.9*length(files));
    img1=imread([path,'/',filename(a).name,'/', files(first).name]);
    img2=imread([path,'/',filename(a).name,'/', files(second).name]);
    img3=imread([path,'/',filename(a).name,'/', files(third).name]);
    top1=img1((0.3*size(img1,1)-r):(0.3*size(img1,1)+r),(0.5*size(img1,2)-r):(0.5*size(img1,2)+r),:);
    bottom1=img1((0.6*size(img1,1)-r):(0.6*size(img1,1)+r),(0.5*size(img1,2)-r):(0.5*size(img1,2)+r),:);
    topR=mean(mean(top1(:,:,1)));
    topG=mean(mean(top1(:,:,2)));
    topB=mean(mean(top1(:,:,3)));
    bottomR=mean(mean(bottom1(:,:,1)));
    bottomG=mean(mean(bottom1(:,:,2)));
    bottomB=mean(mean(bottom1(:,:,3)));
    compareR=(topR+bottomR)/2;
    compareB=(topB+bottomB)/2;
    compareG=(topG+bottomG)/2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    NUM = length(files);

  %%阈值处理以后找到圆的位置
 for i = 1 : NUM
     img = imread([path,'/',filename(a).name,'/', files(i).name]);
 %%find the circles
   I = rgb2gray(img);
   bw = im2bw(I,0.9);%I中数据＞255*0.9就将它变白色，否则变黑色
    figure;imshow(img);%显示原图
   L = bwlabel(bw,8);%8这个位置只有两种选择，4或者8，代表四连通域或者8连通域
   stats = regionprops(L,'all');%函数，找图片中一块一块区域的面积中心点等
   pos=[];
    for kg=1:length(stats)
        if stats(kg).Area<500 & stats(kg).Area>100 %the square
           pos(1,:) = stats(kg).Centroid;
        end
    end
    if isempty(pos)
         continue;
    else
        if isempty(position)
%% 开始画圆
%    position(i,:)=pos;
   m=zeros(size(img,1),size(img,2));%设置一个全零和原图大小一样的矩阵
for ii=1:size(m,1) %遍历所有的位置
    for jj=1:size(m,2)
 if sqrt(((jj-pos(:,1))^2)+((ii-pos(:,2))^2))<= r%判断当前位置否位于r的范围内
     m(ii,jj)=1;
 end
    end
end   
   figure;imshow(m);%显示定位的图  
%% 与原图相乘
   mask(:,:,1)= uint8(m).*img(:,:,1);
   mask(:,:,2)= uint8(m).*img(:,:,2);
   mask(:,:,3)= uint8(m).*img(:,:,3); %每一个通道和原图相乘放入mask 这样一来就只有1的部分了
   %figure;
   %imshow(mask);%于原图相乘之后的图
    [ur1,uc1,uv1]=find(mask(:,:,1));
    [ur2,uc2,uv2]=find(mask(:,:,2));
    [ur3,uc3,uv3]=find(mask(:,:,3)); %把每一个通道的值存起来
    maskR=mean(uv1);
    maskG=mean(uv2);
    maskB=mean(uv3);%平均值
    figure;
    RH=histogram(uv1);
    figure;
    GH=histogram(uv2);
    figure;%显示直方图
    BH=histogram(uv3);
    XR=RH.Values;
    XG=GH.Values;
    XB=BH.Values;%读取直方图的值
    fr=0;
    fg=0;
    fb=0;%峰的个数
    for kr = 2 : length(XR)-1
         if XR(1,kr)>XR(1,kr-1)&&(XR(1,kr)>XR(1,kr+1))
            if XR(1,kr)-XR(1,kr-1)>300||XR(1,kr)-XR(1,kr+1)>300%判断峰的值是否远大于旁边的
                fr=fr+1;
            end
         end
    end
    for kg = 2 : length(XG)-1
         if XG(1,kg)>XG(1,kg-1)&&(XG(1,kg)>XG(1,kg+1))
            if XG(1,kg)-XG(1,kg-1)>300||XG(1,kg)-XG(1,kg+1)>300%判断峰的值是否远大于旁边的
                fg=fg+1;
            end
         end
    end
    for kb = 2 : length(XB)-1
         if XB(1,kb)>XB(1,kb-1)&&(XB(1,kb)>XB(1,kb+1))
            if XB(1,kb)-XB(1,kb-1)>300||XB(1,kb)-XB(1,kb+1)>300%判断峰的值是否远大于旁边的
                fb=fb+1;
            end
         end
    end
    if fr ==1 && fb==1 && fg==1  
       %% 判断当前位置是否为黄色
        if (maskR>(compareR-25)&&maskR<(compareR+25)&&(maskG>(compareG-25)&&maskG<(compareG+25))&&(maskB>(compareB-25)&&maskB<(compareB+25)))
             nstep=nstep+1; 
              position(nstep,:)=pos;%存在position里
        end
    else
    fr=0;
    fg=0;
    fb=0;
    %判断峰的个数来筛选是不是纯色的
     for kr = 3 : length(XR)-2
         if XR(1,kr)>XR(1,kr-1)&&(XR(1,kr)>XR(1,kr+1))
            if XR(1,kr)-XR(1,kr-2)>150||XR(1,kr)-XR(1,kr+2)>150%判断峰的值是否远大于旁边的
                fr=fr+1;
            end
         end
    end
    for kg = 3 : length(XG)-2
         if XG(1,kg)>XG(1,kg-1)&&(XG(1,kg)>XG(1,kg+1))
            if XG(1,kg)-XG(1,kg-2)>150||XG(1,kg)-XG(1,kg+2)>150%判断峰的值是否远大于旁边的
                fg=fg+1;
            end
         end
    end
    for kb = 3 : length(XB)-2
         if XB(1,kb)>XB(1,kb-1)&&(XB(1,kb)>XB(1,kb+1))
            if XB(1,kb)-XB(1,kb-2)>150||XB(1,kb)-XB(1,kb+2)>150%判断峰的值是否远大于旁边的
                fb=fb+1;
            end
         end
    end
    if fr ==1 && fb==1 && fg==1 
     if (maskR>(compareR-25)&&maskR<(compareR+25)&&(maskG>(compareG-25)&&maskG<(compareG+25))&&(maskB>(compareB-25)&&maskB<(compareB+25)))
             nstep=nstep+1; 
              position(nstep,:)=pos;%存在position里
        end
    end
    end
%%如果不是空的话在判断一次位置
    elseif (abs(pos(1,1)-position(nstep,1)))<30 && (abs(pos(1,2)-position(nstep,2)))<30 %判断是和上一个位置是否小于一个半径
        continue;
    else
%%算确定矩阵    
m=zeros(size(img,1),size(img,2));%设置一个全零和原图大小一样的矩阵   
for ii=1:size(m,1) %遍历所有的位置
    for jj=1:size(m,2)
 if sqrt(((jj-pos(:,1))^2)+((ii-pos(:,2))^2))<= r%判断当前位置否位于r的范围内
     m(ii,jj)=1;
 end
    end
end   
%    figure;imshow(m);
%% 与原图相乘
   mask(:,:,1)= uint8(m).*img(:,:,1);
   mask(:,:,2)= uint8(m).*img(:,:,2);
   mask(:,:,3)= uint8(m).*img(:,:,3);
   figure;
   imshow(mask);
   [ur1,uc1,uv1]=find(mask(:,:,1));
   [ur2,uc2,uv2]=find(mask(:,:,2));
   [ur3,uc3,uv3]=find(mask(:,:,3));
    maskR=mean(uv1);
    maskG=mean(uv2);
    maskB=mean(uv3);
   figure;
    RH=histogram(uv1);
   figure;
    GH=histogram(uv2);
   figure;
   BH=histogram(uv3);
    XR=RH.Values;
    XG=GH.Values;
    XB=BH.Values;%读取直方图的值
    fr=0;
    fg=0;
    fb=0;%峰的个数
    for kr = 2 : length(XR)-1
        %%判断峰的个数来筛选是不是纯色的
         if XR(1,kr)>XR(1,kr-1)&&(XR(1,kr)>XR(1,kr+1))
            if XR(1,kr)-XR(1,kr-1)>200||XR(1,kr)-XR(1,kr+1)>300%判断峰的值是否远大于旁边的
                fr=fr+1;
            end
         end
    end
    for kg = 2 : length(XG)-1
         if XG(1,kg)>XG(1,kg-1)&&(XG(1,kg)>XG(1,kg+1))
            if XG(1,kg)-XG(1,kg -1)>300||XG(1,kg)-XG(1,kg+1)>300%判断峰的值是否远大于旁边的
                fg=fg+1;
            end
         end
    end
    for kb = 2 : length(XB)-1
         if XB(1,kb)>XB(1,kb-1)&&(XB(1,kb)>XB(1,kb+1))
            if XB(1,kb)-XB(1,kb-1)>300||XB(1,kb)-XB(1,kb+1)>300%判断峰的值是否远大于旁边的
                fb=fb+1;
            end
         end
    end
    if fr ==1 && fb==1 && fg==1            
       %% 判断当前位置是否为黄色
        if (maskR>(compareR-25)&&maskR<(compareR+25)&&(maskG>(compareG-25)&&maskG<(compareG+25))&&(maskB>(compareB-25)&&maskB<(compareB+25)))
             nstep=nstep+1; 
              position(nstep,:)=pos;%存在position里
        end
         else
    fr=0;
    fg=0;
    fb=0;
     for kr = 3 : length(XR)-2
         if XR(1,kr)>XR(1,kr-1)&&(XR(1,kr)>XR(1,kr+1))
            if XR(1,kr)-XR(1,kr-2)>150||XR(1,kr)-XR(1,kr+2)>150%判断峰的值是否远大于旁边的
                fr=fr+1;
            end
         end
    end
    for kg = 3 : length(XG)-2
         if XG(1,kg)>XG(1,kg-1)&&(XG(1,kg)>XG(1,kg+1))
            if XG(1,kg)-XG(1,kg-2)>150||XG(1,kg)-XG(1,kg+2)>150%判断峰的值是否远大于旁边的
                fg=fg+1;
            end
         end
    end
    for kb = 3 : length(XB)-2
         if XB(1,kb)>XB(1,kb-1)&&(XB(1,kb)>XB(1,kb+1))
            if XB(1,kb)-XB(1,kb-2)>150||XB(1,kb)-XB(1,kb+2)>150%判断峰的值是否远大于旁边的
                fb=fb+1;
            end
         end
    end
    if fr ==1 && fb==1 && fg==1 
     if (maskR>(compareR-25)&&maskR<(compareR+25)&&(maskG>(compareG-25)&&maskG<(compareG+25))&&(maskB>(compareB-25)&&maskB<(compareB+25)))
             nstep=nstep+1; 
              position(nstep,:)=pos;%存在position里
        end
    end
    end
        end
    end
end
 pm(a-3,1)=nstep; %文件夹读取的时候从4开始的,矩阵是从一开始的pm(第几行,第几个数)如果是:就是把这一行所有的数都放进来
end
finalscore=mean(pm);  %所有可能支的平均数