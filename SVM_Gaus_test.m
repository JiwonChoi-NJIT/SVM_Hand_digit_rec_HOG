
% 
clear all
close all
clc
% 
% rng(0)
% load('trainingset_66.mat')

load('TestingSet_gauss_01.mat')
% Training_set(790*9+1:end,end) = 9;


% load('snpHOG_66.mat')

load('weight_66_G_w.mat')
% Training_set = snphog(1:1000,:,1);
% [B,I] = sort(Training_set(:,end));
% Training_set = Training_set(I,:);

X = TestingSet(:,1:end-1);
class_true = TestingSet(:,end);
index = (1:size(X,1))';
class = [];

N = size(X,1);
x_test = [ones(N,1) 1/sqrt(2*pi)*exp((X.^2)/2)];

for i = 1:9
    w = weight(:,i);
    a = x_test*w;

    classified = index(a>0);
    class = [class; [ones(length(classified),1)*(i-1) classified]];
    if i == 9
        class = [class; [ones(length(index(a<0)),1)*9 index(a<0)]];
    end
    x_test = x_test(a<0,:);
    index = index(a<0);
end

[B,I] = sort(class(:,2),'ascend');
class_ordered = class(I,:);
check = class_true == class_ordered;
correct_percent = sum(check)/N

%% for confusion matrix
c_result = [];
for i = 0:9
    for j = 0:9
        c_result(i+1,j+1) = sum(class_ordered(class_true==i)==j);
    end
end
c_result

filename = '6x6_G_G01.xlsx';
xlswrite(filename,c_result)