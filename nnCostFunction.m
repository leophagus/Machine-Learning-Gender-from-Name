function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%
% This is my vectorized implementation of nnCostFunction from Ex-4. Very thrilled to
% have a succesful vectorized solution in first attempt.
% 2017-09-17 20:22:17  leo 

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% y is 5000x1, y\in 1:10 (K or class). Have to convert it to a matrix ymat
% where each row is a binary vector (one hot) corresponding to y_i. 
% Y is m*k
%Y = y==[1:num_labels];
%Cool syntax but geneartes warning from octave: warning: mx_el_eq: automatic
%broadcasting operation applied can use permutation matrix or the loop below
Y = y==1;
for i = 2:num_labels
  Y = [Y y==i];
endfor

%a1 = x. Add column of 1s for bias. m*(n+1)
A1 = [ones(m, 1) X];

% Theta1 = h * (n+1); Theta' = (n+1) * h
% z2 = A1 * Theta1' = m * h
% A2 = m * (h+1)
%A2 = [ones(m,1) (sigmoid (A1 * Theta1'))];
z2 = A1 * Theta1';
A2 = [ones(m,1) (sigmoid (z2))];
%puts ("Done 2\n");

% Theta2 = k* (h+1)
% A3 = m * k
%A3 = sigmoid (A2 * Theta2');
z3 = A2 * Theta2';
A3 = sigmoid(z3);

%tmp = 0;
%size(Y)
%size(A3)
tmp = (-Y .* log(A3)) - ( (1 - Y) .* log(1 - A3) );
% sum normally adds in first (row) dimension. (:) creates a (column) vector
J = sum (tmp(:))/m;

% A3: m*k Y: m*k Delta3: m*k
Delta3 = A3 - Y;

% Theta2: k*(h+1) Delta3: m*k Theta2_nobias: k*h; Delta2_: m*h
Delta2_ = Delta3 * Theta2(: , 2:end);
% z2: m*h
%Delta2  = Delta2_(: , 2:size(Delta2_,2)) .* sigmoidGradient (z2); 
Delta2  = Delta2_ .* sigmoidGradient (z2); 
%puts ("Done 30\n");

% Theta2_grad (big Delta) is defined on entie A. Dont take out bias from A
%Theta2_grad = Delta3' * A2(: , 2:size(A2,2));
% Delta3: m*k; A2: m*(h+1); Delta3'*A2: k*m * m*(h+1) = k*(h+1)
Theta2_grad = Delta3' * A2;
Theta2_grad = Theta2_grad * 1/m;
%puts ("Done 40\n");

%Theta1_grad = Delta2' * A1(: , 2:size(A1,2));
% Delta2: m*h; A1: m*(n+1); Delta2'*A1: h*m * m*(n+1) = h*(n+1)
Theta1_grad = Delta2' * A1;
Theta1_grad = Theta1_grad * (1/m);
%puts ("Done 50\n");

% dont regularize bias which is in first col of both Thetas.
Theta1_FirstCol0 = [zeros(size(Theta1,1),1) Theta1(: , 2:end)];
Theta2_FirstCol0 = [zeros(size(Theta2,1),1) Theta2(: , 2:end)];
J += lambda/(2*m) * ( sum ( (Theta1 .* Theta1_FirstCol0)(:)) + sum ( (Theta2 .* Theta2_FirstCol0)(:)));

%Theta1_grad is h*(n+1)
Theta1_grad += lambda/(m) * Theta1_FirstCol0;

%Theta2_grad is k*(h+1)
Theta2_grad += lambda/(m) * Theta2_FirstCol0;


% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
