start = 1;
%    inputili = csvread('derivedili.csv');
%  inputhum = csvread('derivedhum.csv');
%  inputtemp = csvread('derivedtemp.csv');

% kingston
   inputili = csvread('svm_count_kingston.csv');
   inputhum = csvread('svm_hum_kingston.csv');
   inputtemp = csvread('svm_temp_kingston.csv');

% windsor
%   inputili = csvread('svm_windsor_days.csv');
%   inputhum = csvread('SVM_windsor_temp.csv');
%   inputtemp = csvread('SVM_windsor_hum.csv');




n = size(inputili,1)

% predict humidity

% predict from all
label = inputili(:,1);
%label = label(randperm(length(label)));

inputdata = [inputili(:,2:11)];
deflt = inputili(:,2);


Mdl = fitrsvm(inputdata, label,'KernelFunction','rbf','KernelScale','auto','BoxConstraint', 260,'Standardize',true);

yHat = predict(Mdl, inputdata);
mae = abs(label - yHat);
ae = label - yHat;

figure;
scatter(label,yHat);
title('Scatter plot of actual versus predicted values train/train');

disp(['mae ' num2str(sum(mae)/n)])

% predict tomorrow to be today

dumbmae = abs(label - deflt);

disp(['dumbmae ' num2str(sum(dumbmae)/n)])

figure; plot(mae);
title('SVM MAE ILI from all train/train');

figure; hist(mae)
title('Mae from train/train');

figure;hist(ae);
title('ae from train/train');

ilixx = find(mae > 2);
length(ilixx)

figure;
hold on;
plot(label,'g-');
plot(yHat,'r');
title('Actual vs predicted train/train');

disp('Starting svm next day prediction');
allyhat = [];
alllabelleft = [];
testmae = 0;
testae = 0;
count = 1;

prediction = [];
actual_data = [];
for targ = 10:n-1

	inputprefix = inputdata(1:targ,:);
	labelprefix = label(1:targ);
	
	inputleft = inputdata(targ+1,:);
	labelleft = label(targ+1);
	
	
	Mdl = fitrsvm(inputprefix, labelprefix,'KernelFunction','rbf','KernelScale','auto','BoxConstraint', 400,'Standardize',true);
	
	yhat = predict(Mdl, inputleft);
	allyhat = [allyhat; yhat];
	alllabelleft = [alllabelleft; labelleft];

    	prediction(end+1, :) = yhat;
    	actual_data(end+1, :) = labelleft;

	testmae(count) = abs(labelleft - yhat);
	testae(count) = labelleft - yhat;
	count = count + 1;
	if mod(targ, 100) == 0
		targ
	end
end

title('RSVM Prediction Data');

csvwrite('prediction_rsvm_transformation_windsor.csv', prediction);

title('RSVM Actual Data');

csvwrite('actual_rsvm_transformation_windsor.csv', actual_data);
disp(['mae ' num2str(sum(testmae)/(count-1))])

figure;
hold on;
plot(alllabelleft,'g-');
plot(allyhat,'r');
title('Next day predictions svm');

% try full experiment with xgboost

disp('Starting xgboost next day prediction');

xallyhat = [];
xalllabelleft = [];
testmae = 0;
testae = 0;
count = 1;


t = templateTree('NumVariablesToSample','all');
% 'PredictorSelection','interaction-curvature');
rng(1); % For reproducibility
prediction = [];
actual_data = [];

for targ = 10:n-1

	inputprefix = inputdata(1:targ,:);
	labelprefix = label(1:targ);
	
	inputleft = inputdata(targ+1,:);
	labelleft = label(targ+1);

	Mdl = fitrensemble(inputprefix,labelprefix,'Method','LSBoost','LearnRate', 0.01,'NumLearningCycles',500,'Learners',t);	

	yhat = predict(Mdl, inputleft);
	xallyhat = [xallyhat; yhat];
	xalllabelleft = [xalllabelleft; labelleft];
    
    	prediction(end+1, :) = yhat;
    	actual_data(end+1, :) = labelleft;

	testmae(count) = abs(labelleft - yhat);
	testae(count) = labelleft - yhat;
	count = count + 1;
	if mod(targ, 100) == 0
		targ
	end
end
title('Resemble Prediction Data');

csvwrite('prediction_Resemble_transformation.csv', prediction);
csvwrite('prediction_Resemble_transformation_windsor.csv', prediction);

title('Resemble Actual Data');

% csvwrite('actual_rsvm_transformation.csv', actual_data);
csvwrite('actual_rsvm_transformation_windsor.csv', actual_data);

disp(['mae ' num2str(sum(testmae)/(count-1))])

figure;
hold on;
plot(xalllabelleft,'g-');
plot(xallyhat,'r');
title('Predictions xgboost');

figure;
hold on;
plot(xallyhat,'b');
plot(allyhat,'g');
title('Comparing the two predictions');

alp = 0.00;
aver = ((1-alp)* xallyhat + alp * allyhat);
%aver = max(xallyhat, allyhat);

figure;
hold on;
plot(alllabelleft,'g-');
plot(aver,'r');
title('Predictions both against ground truth');


figure;
plot(alllabelleft-aver);
title('Errors using both together');

sum(abs(xalllabelleft - aver))/1712