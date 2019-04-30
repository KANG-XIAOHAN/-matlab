clc;
clear;
close all;

path = '/Volumes/sweetdreams/video/';

fileName = dir([path,'*.mp4']);

for a = 1 : length(fileName)
y
%     fileName = '/Users/karen/Desktop/1e_q.mp4'; 
    obj = VideoReader([path,fileName(a).name]);
    numFrames = obj.NumberOfFrames;
    k = 0;
    for i = 1:2:numFrames
         frame = read(obj,i);
        frame = imcrop(frame,[1920*0.23,1080*0.17,1920*0.51,1080*1.0]);
%      frame = imresize(frame,[720 720]);
   %  imshow(frame);%
        k = k+1;
        path1=strcat('/Volumes/sweetdreams/fenzen/',fileName(a).name,'/');
        mkdir(path1);
        imwrite(frame,strcat(path1,num2str(k),'.jpg'));% ����ÿһ֡
    % imwrite(frame,strcat('F:\����\��·��\lane-detection-master\data\360\',num2str(k),'.jpg'),'tif');
    end
end