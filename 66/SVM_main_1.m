

clear all
close all
clc

rng(0)

% Digit identification
% load('HOG_zero.mat')
% load('HOG_one.mat')
% load('HOG_two.mat')
% load('HOG_three.mat')
% load('HOG_four.mat')
% load('HOG_five.mat')
% load('HOG_six.mat')
% load('HOG_seven.mat')
% load('HOG_eight.mat')
% load('HOG_nine.mat')
% 
% gaus_0=[HOG_zero(:,1:100)' ones(100,1)*0];
% gaus_1=[HOG_one' ones(100,1)*1];
% gaus_2=[HOG_two' ones(100,1)*2];
% gaus_3=[HOG_three' ones(100,1)*3];
% gaus_4=[HOG_four' ones(100,1)*4];
% gaus_5=[HOG_five' ones(100,1)*5];
% gaus_6=[HOG_six' ones(100,1)*6];
% gaus_7=[HOG_seven' ones(100,1)*7];
% gaus_8=[HOG_eight' ones(100,1)*8];
% gaus_9=[HOG_nine' ones(100,1)*9];
% 
% index_0 = randperm(size(gaus_0,1));
% index_1 = randperm(size(gaus_1,1));
% index_2 = randperm(size(gaus_2,1));
% index_3 = randperm(size(gaus_3,1));
% index_4 = randperm(size(gaus_4,1));
% index_5 = randperm(size(gaus_5,1));
% index_6 = randperm(size(gaus_6,1));
% index_7 = randperm(size(gaus_7,1));
% index_8 = randperm(size(gaus_8,1));
% index_9 = randperm(size(gaus_9,1));
% 
% N = 100;
% 
% train_0 = gaus_0(index_0(1:N),:);
% train_1 = gaus_1(index_1(1:N),:);
% train_2 = gaus_2(index_2(1:N),:);
% train_3 = gaus_3(index_3(1:N),:);
% train_4 = gaus_4(index_4(1:N),:);
% train_5 = gaus_5(index_5(1:N),:);
% train_6 = gaus_6(index_6(1:N),:);
% train_7 = gaus_7(index_7(1:N),:);
% train_8 = gaus_8(index_8(1:N),:);
% train_9 = gaus_9(index_9(1:N),:);
% 
% save('train_100.mat')
% 

load('train_100.mat')

Training_set = [train_0;train_1;train_2;train_3;train_4;train_5;train_6;train_7;train_8;train_9];
weight = [];
M = 1;
    
for i = 1:9
    X = Training_set(1+100*(i-1):end,1:end-1);
    t = 2*(Training_set(1+100*(i-1):end,end)==(i-1))-1;
%     weight = [weight; SVM_ABC_v1(X,t,M)];
    weight = [weight SVM_ABC_Gaus_v1(X,t)];
end
save('weight_66_G.mat');


