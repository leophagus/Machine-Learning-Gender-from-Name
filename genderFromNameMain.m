% Neural Network to predict Gender (Boy/Girl) from First names.
% Derived from Ex-4 of Machine Learning Online Class. This is the
% first exercise where you get to train a neural network with 
% back propagation. Once I got that working, I wanted to see if
% I can apply this to a real-world problem, where the data isnt
% in a ready to consume format like mnist.
%
% 2017-09-17 19:58:20 leo 

%% Initialization
clear ; close all; clc

% Model info:
%   * 3 layers
%   * 10 input layers. X comes from the first names of data set. Limiting 10 to chars, each
%        char is converted to uppercase, ASCII and re-based to A+1 (i.e. 'A' = 1, 'B'=2..)
%        See prep.py for details
%   * 100 units in hidden layer. String determinant of prediction quality
%   * 2 output units. Could have gone with just 1, but want to expand to more predictions later.
input_layer_size  = 10;  % 10 chars converted to uppercase ASCII, based off A+1

% fewer hidden layers reduces accuracy. Some experiments:
%   50 = 90%, 10 =73%, 100 = 96.024506%
%   100 with 1500 iters: 97.245292%
% Need to do a systematic Train, CV, Test framework to evaluate the models TODO
hidden_layer_size = 100;  % 25 hidden units

num_labels = 2;   % girl, boy
%num_labels = 8;  % 8 labels if predicting ethnicity

% g = gender, ge = gender+ethnicity, noinv = no name reverse
dataFile = 'out_noinv_g.dat';
data = load(dataFile);

X = data(:, [1:end-1]); y = data(:, end); 
m = size(X, 1);
fprintf('Loaded %s m= %d\n', dataFile, m);

fprintf('\nInitializing Neural Network Parameters ...\n')

initial_Theta1 = randInitializeWeights(input_layer_size, hidden_layer_size);
initial_Theta2 = randInitializeWeights(hidden_layer_size, num_labels);

% Unroll parameters
initial_nn_params = [initial_Theta1(:) ; initial_Theta2(:)];


fprintf('\nTraining Neural Network... \n')

options = optimset('MaxIter', 1500);

% TODO evaluate best lambda 
lambda = 1;

% Create "short hand" for the cost function to be minimized
costFunction = @(p) nnCostFunction(p, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, X, y, lambda);

% Now, costFunction is a function that takes in only one argument (the
% neural network parameters)
[nn_params, cost] = fmincg(costFunction, initial_nn_params, options);

% Obtain Theta1 and Theta2 back from nn_params
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

fprintf('Program paused. Press enter to continue.\n');
pause;

% TODO create seperate CV and Test data set
pred = predict(Theta1, Theta2, X);

fprintf('\nTraining Set Accuracy: %f\n', mean(double(pred == y)) * 100);

% save trained model. Use genderFromNamePredict to use the model 
save g_ni_10_100_1500.m Theta1 Theta2;

% done
