close all
clear all
clc
%
% [file path]=uigetfile('*.*','Select image');
% filename=strcat(path,file);
% img=(imread(filename));
%  figure,imshow(img);
%     title('Input Image');
% dim=ndims(img);
% 
% if(dim==3)
%     img=rgb2gray(img);
%     figure,imshow(img);
%     title('Gray Image'); 
% end
% wresize=256;
% wsize=3;
% img_data=(imresize(img,[wresize wresize]));
% figure,imshow(uint8(img_data));
%  title('Resized Image');


 fileid=fopen('image_textfilex.txt','w');


[file path]=uigetfile('*.*','Select image');
filename=strcat(path,file);
b=(imread(filename));
imshow(b);
k=1;
w=256;
h=256;
for i=1:h % height  
for j=1:w %width
a(k)=b(i,j);
k=k+1;
end
end
fid = fopen('image_textfilex.txt', 'wt');
fprintf(fid, '%x\n', a); %writes in hexadecimal

fclose(fid);
% %%
% [file path]=uigetfile('*.*','Select image');
% filename=strcat(path,file);
% img=(imread(filename));
%  figure,imshow(img);
%     title('Input Image');
% dim=ndims(img);
% 
% if(dim==3)
%     img=rgb2gray(img);
%     figure,imshow(img);
%     title('Gray Image'); 
% end
% 
% wresize=256;
% wsize=3;
% img_data=(imresize(img,[wresize wresize]));
% figure,imshow(uint8(img_data));
%  title('Resized Image');

 fileid=fopen('image_textfiley.txt','w');


[file path]=uigetfile('*.*','Select image');
filename=strcat(path,file);
b=(imread(filename));
imshow(b);
k=1;
w=256;
h=256;
for i=1:h % height  
for j=1:w %width
a(k)=b(i,j);
k=k+1;
end
end
fid = fopen('image_textfiley.txt', 'wt');
fprintf(fid, '%x\n', a); %writes in hexadecimal

fclose(fid);


%

con_fid=fopen('para.h','wt');
fprintf(con_fid,'%s \t %s \t %s','`define','MAX_LEN');
fprintf(con_fid,'\n');
fclose(con_fid);


hdldaemon('socket',4999)
cmd={'vlib work', 'vlog dctm.v mod.v',...
    'vsim test',...
    'view wave',...
    'add wave -r /*','run -all','exit'};

vsim('tclstart',cmd);
% hdldaemon('kill')
pause;
% h=256;
% w=256;
% fid= fopen('clk.txt','r');
% img= fscanf(fid,'%d',[h w]);
% fclose(fid);
% ap=imresize(img,[h w]);
% ap=ap';
% figure,imshow(ap,[]);
%%
  % Pauses execution to allow for debugging or visualization
h = 256;
w = 256;

% Open the file for reading
fid = fopen('clk.txt', 'r');

% Read the image data as integers (assuming 16-bit)
img = fscanf(fid, '%d', [w h]);  % Read the data in [w h] format
fclose(fid);

% Check if the data was read successfully
if isempty(img)
    error('Image data could not be read from clk.txt. Please check the file content.');
end

% Convert the data to 16-bit unsigned integers
img = uint16(img);  % Convert to 16-bit

% Reshape the data if it's not in the correct format (optional)
if size(img, 1) ~= w || size(img, 2) ~= h
    error('The data dimensions do not match the expected 256x256 size.');
end

% Resizing is not needed if dimensions are correct; skip imresize
ap = img;

% Transpose the image for correct orientation
ap = ap';

% Display the image with appropriate scaling for 16-bit data
figure, imshow(ap, []);  % Use [] to scale the display based on min/max values of the 16-bit image
