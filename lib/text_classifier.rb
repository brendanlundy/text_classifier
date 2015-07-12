require 'set'

class TextClassifier
  def self.classify(documents_by_category, test_doc)
    stop_words = Set.new ['a','about','above','after','again','against','all','am','an','and','any','are','aren\'t','as','at','be','because','been','before','being','below','between','both','but','by','can\'t','cannot','could','couldn\'t','did','didn\'t','do','does','doesn\'t','doing','don\'t','down','during','each','few','for','from','further','had','hadn\'t','has','hasn\'t','have','haven\'t','having','he','he\'d','he\'ll','he\'s','her','here','here\'s','hers','herself','him','himself','his','how','how\'s','i','i\'d','i\'ll','i\'m','i\'ve','if','in','into','is','isn\'t','it','it\'s','its','itself','let\'s','me','more','most','mustn\'t','my','myself','no','nor','not','of','off','on','once','only','or','other','ought','our','ours','ourselves','out','over','own','same','shan\'t','she','she\'d','she\'ll','she\'s','should','shouldn\'t','so','some','such','than','that','that\'s','the','their','theirs','them','themselves','then','there','there\'s','these','they','they\'d','they\'ll','they\'re','they\'ve','this','those','through','to','too','under','until','up','very','was','wasn\'t','we','we\'d','we\'ll','we\'re','we\'ve','were','weren\'t','what','what\'s','when','when\'s','where','where\'s','which','while','who','who\'s','whom','why','why\'s','with','won\'t','would','wouldn\'t','you','you\'d','you\'ll','you\'re','you\'ve','your','yours','yourself','yourselves']
    num_categories = documents_by_category.size
    probability_of_category = Array.new(num_categories)
    num_words_in_category = Array.new(num_categories)
    count_words_by_category = Array.new(num_categories)
    entire_vocabulary = Set.new

    # count the total number of documents across all categories
    num_docs = 0
    for i in 0..num_categories-1 do
      documents_this_cat = documents_by_category[i]
      num_docs += documents_this_cat.size
      documents_this_cat.each do |doc|
        doc = doc.downcase.gsub(/[^a-z']/, ' ').squeeze(' ')
      end
    end
    test_doc = test_doc.downcase.gsub(/[^a-z']/, ' ').squeeze(' ')

    # count how many of each word are in each category and build the entire vocabulary
    for i in 0..num_categories-1 do
      category = documents_by_category[i]
      probability_of_category[i] = category.size.to_f / num_docs

      num_words_this_cat = 0
      count_words_this_cat = Hash.new(0)
      category.each do |document|
        document.split.each do |word|
          entire_vocabulary.add(word)
          num_words_this_cat += 1
          count_words_this_cat[word] += 1
        end
      end
      num_words_in_category[i] = num_words_this_cat
      count_words_by_category[i] = count_words_this_cat
    end

    # find the conditional probability of a word, given that we are in a category
    cond_probs = Array.new(num_categories)
    size = entire_vocabulary.size
    for i in 0..num_categories-1 do
      prob = Hash.new(0)
      denom = num_words_in_category[i] + size
      entire_vocabulary.each do |word|
        numer = 1.0 + count_words_by_category[i][word]
        prob[word] = numer / denom
      end

      cond_probs[i] = prob
    end

    # calculate the probability of each category on the new test document
    test_doc_probs = Array.new(num_categories)
    for i in 0..num_categories-1 do
      prob = cond_probs[i]
      total_prob = probability_of_category[i]
      test_doc.split.each do |word|
        total_prob *= prob[word]
      end

      test_doc_probs[i] = total_prob
    end

    # test_doc_probs are proportional to each other so scale to make them sum to 1
    sum_test_doc_probs = test_doc_probs.inject(:+)
    for i in 0..num_categories-1 do
      test_doc_probs[i] /= sum_test_doc_probs
    end

    return test_doc_probs
  end
end