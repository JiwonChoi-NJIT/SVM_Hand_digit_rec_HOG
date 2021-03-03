

clear all
close all
clc

rng(0)
load('TestingSet_SNP_002.mat')
%%
load('weight_66_1_w.mat')

% Training_set(790*9+1:end,end) = 9;

M = 1;

X = TestingSet(:,1:end-1);
class_true = TestingSet(:,end);
index = (1:size(X,1))';
class = [];

N = size(X,1);
x_test = [ones(N,1)];

%Linear Case
for i = 1:M
    x_test = [x_test X.^i];
end

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
class_ordered = class(I);
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

filename = '6x6_M1_snp002.xlsx';
xlswrite(filename,c_result)