function p = genderFromNamePredict(Theta1, Theta2, Name)
% Usage: genderFromNamePredict (Theta1, Theta2, 'Sheldon')
%
% Eg:
% octave:1> load ('g_ni_10_100_1500.m');
% octave:2> genderFromNamePredict (Theta1, Theta2, 'Sheldon');
% Sheldon is a Boy (F: 1.17%, M: 98.83%)
%
% 2017-09-17 20:14:52  leo 

m = 1;
num_labels = size(Theta2, 1);
num_inputs = size(Theta1, 2) -1;

X = toascii(toupper(Name)) - toascii('A') +1;
X = [X zeros(10 - length(X), 1)'];
X = X(: ,1:num_inputs);

p = zeros(size(X, 1), 1);

h1 = sigmoid([ones(m, 1) X] * Theta1');
h2 = sigmoid([ones(m, 1) h1] * Theta2');

diff = h2(1,1) - h2(1,2);
resTxt = "";
if (diff > 0.1)
  resTxt = "a Girl";
elseif (diff > 0.05)
  resTxt = "probably a Girl";
elseif (diff < -0.1)
  resTxt = "a Boy";
elseif (diff < -0.05)
  resTxt = "probably a Boy";
else
  resTxt = "hard to guess. My prediction rate is only 96.024506";
endif

printf ("%s is %s (F: %.2f%%, M: %.2f%%)\n", Name, resTxt, h2(1,1)*100, h2(1,2)*100);

[dummy, p] = max(h2, [], 2);

% =========================================================================


end
