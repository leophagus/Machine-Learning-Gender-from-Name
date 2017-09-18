# Machine Learning - Neural Network to Predict Gender from First Name

## Background
I just finished Exercise-4 of Dr Andrew Ng's most excellent [Machine
Learning](https://www.coursera.org/learn/machine-learning) course.  This is the first exercise where
you get to train a neural network with back propagation to recognize handwritten digits from the MNIST
data set. Once I got that working, I wanted to see if I can apply what I learnt to a real-world problem,
where the data isnt in a ready to consume format like MNIST. And whats more important than knowing
if the person you are chatting with is a Male or Female :)

## Data Set
I found this Government data-set from the City of NY: [Most Popular Baby Names by Sex and Mother's
Ethnic Group, New York City](https://catalog.data.gov/dataset/most-popular-baby-names-by-sex-and-mothers-ethnic-group-new-york-city-8c742).
22036 samples with baby names from four years, 2011 to 2014. They have a downloadable csv file with
the following format:

| Year of Birth | Gender | Ethnicity | Child's First Name | Count | Rank |

## Data Prep
For gender prediction using the Neural Network we need a training set that has the names and the
gender of the baby. Names are strings of characters. First step is to
find a suitable representation of the names. ASCII is a good option, but the part of ASCII used by
regular names is very small (i.e. 26 out of 256). I felt that maybe this might hurt training. ASCII
rebased to the first alphabet 'A', seemed like a good idea.  A simple python script (prep.py)
converts the string to ASCII and subtracts 'A' to rebase. The names are thus converted to arrays of
numbers, each number from 0 to 26. Each name is limited to 10 chars with zero-padding at the end. 

## Neural Network Model
The network we developed during Ex-4 has three layers: input, hidden and output. Since I wanted to
reuse this Matlab/Octave code, I had to go with the same 3 layers. The input layer has 10 nodes, one
for each number, representing a char from the name. The output layer has 2 nodes, one each for Male
and Female labels. The number of nodes in the hidden layer was a big unknown. I tried several values
and settled on 100. I need to do more rigorous analysis on this key parameter.

## Training
The Ex-4 solution uses fmincg (Conjugate Gradient) to minimize the errors for back-propagation. The
number of iterations has a big impact on the errors. I went upto 1500 iters and got close to 97.25%
accuracy on the test data. 

## Testing
genderFromNamePredict lets you pass in any name and get the estimated gender. I declare the class
with no pessimism if one of the output classes is better than the other by > 10%. If they are
between 5 and 10%, I color the prediction with "probably" :) If the gap is too close (< 5%), then I
declare a tie. 

```Matlab
octave:3> load ('g_ni_10_100_1500.m');
octave:4> genderFromNamePredict (Theta1, Theta2, 'Sheldon');
Sheldon is a Boy (F: 1.17%, M: 98.83%)
```

Trying it on the beloved [Simpsons](https://en.wikipedia.org/wiki/The_Simpsons)
family, it worked for all except
[Bart](https://en.wikipedia.org/wiki/Bart_Simpson). But it was right for
Bartholomew, which is Bart's full name :) !

```Matlab
octave:10> genderFromNamePredict (Theta1, Theta2, 'Homer');
Homer is a Boy (F: 1.58%, M: 98.40%)
octave:11> genderFromNamePredict (Theta1, Theta2, 'Marge');
Marge is a Girl (F: 83.47%, M: 16.52%)
octave:12> genderFromNamePredict (Theta1, Theta2, 'Maggie');
Maggie is a Girl (F: 98.80%, M: 1.20%)
octave:13> genderFromNamePredict (Theta1, Theta2, 'Bart');
Bart is a Girl (F: 99.40%, M: 0.60%)
octave:14> genderFromNamePredict (Theta1, Theta2, 'Lisa');
Lisa is a Girl (F: 90.40%, M: 9.64%)
octave:15> predict2 (Theta1, Theta2, 'bartholomew');
bartholomew is a Boy (F: 0.02%, M: 99.98%)
octave:16> genderFromNamePredict (Theta1, Theta2, 'ned');
ned is a Boy (F: 16.73%, M: 83.02%)
octave:17> genderFromNamePredict (Theta1, Theta2, 'edna');
edna is a Girl (F: 86.03%, M: 14.04%)
```

## Next Steps
This was so much fun. Iam Thrilled that I was able to take something that I
just learnt and apply it to a real world data-set and get reasonably okay
results. Next step is to formalize the network model and parameters (lambda,
hidden layers), split the data set into training, cross-verification and test
sets and use rigorous methods to determine the parameters.  Additional
data-sets from other sources would be a nice addition as well.
