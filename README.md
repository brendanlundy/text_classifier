# text_classifier
Text classification of a new document using multinomial naive bayes.

<h2>Install</h2>

<p>Put this line in your Gemfile:</p>

<pre>gem 'text_classifier'</pre>

<p>Then bundle:</p>

<pre>bundle install</pre>


<h2>Usage</h2>

<p>Each document is simply a string of text. Strings that are in the same array have the same label.</p>
<p> A naive example is included below. There are 3 strings written by a cat, then 2 strings written by a dog. 
Then there is an unlabeled document and we want to know whether it was written by a cat or a dog.</p>

<pre>
# The strings are in the same array with others that have the same label
documents_by_category = [['cat cat meow','cat kitten dog','cat jump mouse'],['dog bark woof','dog chase']]

# We have this unlabeled document and we want to know whether it belongs to the first group or the second.
unlabeled_document = 'cat cat bark meow'

# call the text_classifier. It will output the likelihood of being in each group. 
# In this case it will print [0.932, 0.068] meaning there is a 93.2% chance this unlabeled text has the same label as the first group.
puts TextClassifier.classify(documents_by_category, unlabeled_document)
</pre>
