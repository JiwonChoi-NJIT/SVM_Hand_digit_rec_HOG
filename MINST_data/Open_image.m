close all
clear all

% Change the filenames if you've saved the files under different names
% On some platforms, the files might be saved as 
% train-images.idx3-ubyte / train-labels.idx1-ubyte
images = loadMNISTImages('train-images.idx3-ubyte');
labels = loadMNISTLabels('train-labels.idx1-ubyte');
images_t = loadMNISTImages('t10k-images.idx3-ubyte');
labels_t = loadMNISTLabels('t10k-labels.idx1-ubyte');
% We are using display_network from the autoencoder code
display_network(images_t(:,1:1600)); % Show the first 100 images
disp(labels(1:10));

%% take first image

A = reshape(images(:,1),[28 28]);
figure;imshow(A);
figure;imhist(A);

% Zero is completely black, One is pure white
T = graythresh(A);
A2 = imbinarize(A,T);
figure;imshowpair(A,A2,'montage')
A3 = imfill(A2,'holes');
d_A = sum(A3-A2,'all')

B = reshape(images(:,2),[28 28]);
figure;imshow(B);
figure;imhist(B);

% Zero is completely black, One is pure white
T_B = graythresh(B);
B2 = imbinarize(B,T_B);
figure;subplot(1,2,1);imshowpair(B,B2,'montage')
B3 = imfill(B2,'holes');
subplot(1,2,2);imshowpair(B2,B3,'montage')
d_B = sum(B3-B2,'all')