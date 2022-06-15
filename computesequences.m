% kingston data
% realbase = csvread('count_kingston.csv');
%  realbase = csvread('hum_kingston.csv');
%  realbase = csvread('temp_kingston.csv');

% windsor data
%    realbase = csvread('windsor_count.csv');
%   realbase = csvread('windsor_temp.csv');
  realbase = csvread('windsor_hum.csv');

base = smooth(realbase,5);
%base = smooth(realbase,10);
%base = realbase;

% weekdays for either kingston or windsor
% days = csvread('weekday_kingston.csv');
 days = csvread('weekday_windsor.csv');

% computes derived sequences from the base sequence

% first start elements ignored because they are needed for lagged values
% last element ignored because we want to predict last value of base

n = length(base);

nn = length(days);
if n ~= nn
	disp('Sequence lengths dont match');
end

figure; plot(base)

start = 10;

% compute linearly decaying base seq values

lin = zeros(n,1);
for i = start:n-1
	val = base(i);
	for j = i-1:-1:i-(start-1)
		val = val + base(j) * 1/(i-j+1);
	end
	lin(i) = val;
end
	
figure; plot(lin)

% compute exponentially decaying base seq values

alpha = 0.75;
expon = zeros(n,1);
for i = start:n-1
	val = base(i);
	for j = i-1:-1:i-(start-1)
		val = val + base(j) * alpha^(i-j);
	end
	expon(i) = val;
end

figure; plot(expon)

python_input = [realbase(start+1:n) base(start:n-1)  lin(start:n-1,:) expon(start:n-1,:) days(start:n-1)];
title('Input for Python');

csvwrite('derive_data_new.csv', python_input);

return;