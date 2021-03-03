function weight = SVM_ABC_v1(train_input,train_output,order)


%% Calculate Weights
N = length(train_output);                           % Length of inputs determined by looking at mapping 
X = [ones(N,1) train_input];
t = train_output;                                   % Format of correct/incorrect should be -1 (False) or 1 (True)

w_temp = pinv(X)*t; % starting with LS solution weight vectors

x_train = [ones(N,1)];

M = order;

for i = 1:M
    x_train = [x_train X(:,2:end).^i];
end

%% ABC - iterative serach for weight that satisifies the training set
employ = 50;
onlook = 20;
scout  = 10;
total = employ + onlook + scout;

weight_hold = [];
fitness_hold = [];
'start finding'
for j = 1:total
    w = [w_temp;zeros((M*(length(w_temp)-1)-(length(w_temp)-1)),1)] + 1/2000*randn((M*(length(w_temp)-1)+1),1);
    a = x_train*w;
    check = t.*a;
    P_c = sum(check>0)/N;
    weight_hold(:,j) = w;
    fitness_hold(j) = P_c;
end

[B,I] = sort(fitness_hold,'descend');

weight_hold = weight_hold(:,I);
fitness_hold = B;

for iteration = 1:1e4
    %% employ
    weight_temp = [];
    fitness_temp = [];
    for e = 1:employ
        w = weight_hold(:,e) + 1/1000*randn((M*(length(w_temp)-1)+1),1);
        a = x_train*w;
        check = t.*a;
        P_c = sum(check>0)/N;
        weight_temp(:,e) = w;
        fitness_temp(e) = P_c;
    end
    
    weight_hold = [weight_hold weight_temp];
    fitness_hold = [fitness_hold fitness_temp];
    
    [B,I] = sort(fitness_hold,'descend');

    weight_hold = weight_hold(:,I(1:total));
    fitness_hold = B(1:total);
   
    
    %% onlook
    weight_temp = [];
    fitness_temp = [];
    
    pr = cumsum(fitness_hold)/max(cumsum(fitness_hold));

    for o = 1:onlook
       index = sum(pr<rand)+1;
       w = weight_hold(:,o) + 1/1000*randn((M*(length(w_temp)-1)+1),1);
       a = x_train*w;
       check = t.*a;
       P_c = sum(check>0)/N;
       weight_temp(:,o) = w;
       fitness_temp(o) = P_c;
    end
   
    weight_hold = [weight_hold weight_temp];
    fitness_hold = [fitness_hold fitness_temp];
    
    [B,I] = sort(fitness_hold,'descend');

    weight_hold = weight_hold(:,I(1:total));
    fitness_hold = B(1:total);
    
    %% scout
    weight_temp = [];
    fitness_temp = [];
    
    for s = 1:scout
        w = [w_temp;zeros((M*(length(w_temp)-1)-(length(w_temp)-1)),1)] + 1/100*randn((M*(length(w_temp)-1)+1),1);
        a = x_train*w;
        check = t.*a;
        P_c = sum(check>0)/N;
       weight_temp(:,s) = w;
       fitness_temp(s) = P_c;
    end
    
    weight_hold = [weight_hold weight_temp];
    fitness_hold = [fitness_hold fitness_temp];
    
    [B,I] = sort(fitness_hold,'descend');

    weight_hold = weight_hold(:,I(1:total));
    fitness_hold = B(1:total);
    if all(fitness_hold==1)
        fitness_hold
        break  % when the weight that satisfies the requirement, break from loop early
    end
    step1 = [iteration fitness_hold(1)*100]
end
if any(fitness_hold~=1)
    fitness_hold
   'unable to find two zones'
    return;
end

'optimize'
%% ABC iterative search for minimum sum of weights
% the fitness changes to be the sum of the weights
% change from descend ordering of sort to ascend (minimum search)
% keep the weight hold from last serach method (weight_hold)
fitness_hold = [];
for j = 1:total
    w = weight_hold(:,j);
    a = x_train*w;
    check = t.*a;
    P_c = sum(check>0)/N;
    if P_c ~= 1
        fit = 1e100;  % some random high value to make it invalid
    else
        fit = sum(abs(w));
    end
    weight_hold = [weight_hold w];
    fitness_hold = [fitness_hold fit];
end

[B,I] = sort(fitness_hold,'ascend');

weight_hold = weight_hold(:,I);
fitness_hold = B
count = 0;                  % Let the criterion be that if last 100000 iterations had same solutions, break
temp = 0;
fitness_history = fitness_hold(1);

for iteration = 1:1e6
    %% employ
    weight_temp = [];
    fitness_temp = [];
    for e = 1:employ
        w = weight_hold(:,e) + 1/500*randn((M*(length(w_temp)-1)+1),1);
        a = x_train*w;
        check = t.*a;
        P_c = sum(check>0)/N;
        if P_c ~= 1
            fit = 1e100;  % some random high value to make it invalid
        else
            fit = sum(abs(w));
        end
        weight_temp = [weight_temp w];
        fitness_temp = [fitness_temp fit];
    end
    
    weight_hold = [weight_hold weight_temp];
    fitness_hold = [fitness_hold fitness_temp];
    
    [B,I] = sort(fitness_hold,'ascend');

    weight_hold = weight_hold(:,I(1:total));
    fitness_hold = B(1:total);
   
    
    %% onlook
    weight_temp = [];
    fitness_temp = [];
    
    pr = 1-cumsum(fitness_hold)/max(cumsum(fitness_hold));

    for o = 1:onlook
       index = sum(pr>rand)+1;
       w = weight_hold(:,o) + 1/500*randn((M*(length(w_temp)-1)+1),1);
       a = x_train*w;
       check = t.*a;
       P_c = sum(check>0)/N;
       if P_c ~= 1
            fit = 1e100;  % some random high value to make it invalid
       else
            fit = sum(abs(w));
       end
        weight_temp = [weight_temp w];
        fitness_temp = [fitness_temp fit];
    end
   
    weight_hold = [weight_hold weight_temp];
    fitness_hold = [fitness_hold fitness_temp];
    
    [B,I] = sort(fitness_hold,'ascend');

    weight_hold = weight_hold(:,I(1:total));
    fitness_hold = B(1:total);
    
    %% scout
    weight_temp = [];
    fitness_temp = [];
    
    for s = 1:scout
        w = [w_temp;zeros((M*(length(w_temp)-1)-(length(w_temp)-1)),1)] + 1/200*randn((M*(length(w_temp)-1)+1),1);
        a = x_train*w;
        check = t.*a;
        P_c = sum(check>0)/N;
        if P_c ~= 1
            fit = 1e100;  % some random high value to make it invalid
        else
            fit = sum(abs(w));
        end
        weight_temp = [weight_temp w];
        fitness_temp = [fitness_temp fit];
    end
    
    weight_hold = [weight_hold weight_temp];
    fitness_hold = [fitness_hold fitness_temp];
    
    [B,I] = sort(fitness_hold,'ascend');

    weight_hold = weight_hold(:,I(1:total));
    fitness_hold = B(1:total);
    if iteration~= 1 && abs(temp-fitness_hold(1))<1e-6   % error may be slightly different, at which count will not increase. fix by adding tolerance
        count = count + 1;
    else
        count = 0;
    end
    if count > 1e5
        break
    end
    optimization = [iteration count]
    temp = fitness_hold(1);
    fitness_history = [fitness_history temp];
end

%% visualization of fitness history
figure;
plot(fitness_history); grid on
xlabel('iteration'); ylabel('fitness')

weight = weight_hold(:,1);






