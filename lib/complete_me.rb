require_relative 'node'


class CompleteMe
  attr_accessor :root, :count

  def initialize
    @root = Node.new
    @count = 0
  end

  def insert(word)
    this_node = @root
    word.chars.each do |letter|
      this_node.add_child(letter)
      this_node = this_node.child[letter]
    end
    @count +=1 unless this_node.is_word
    this_node.is_word = true
  end

  def find(word)
    this_node = @root
    word.chars.each do |letter|
      if this_node
        this_node = this_node.child[letter]
      else
        return false
      end
    end
    return this_node.is_word
  end

  def get_node_at_substring(substring)
    this_node = @root
    path = substring.chars
    while !path.empty?
      if !this_node
        break
      else
        this_node = this_node.child[path.shift]
      end
    end
    this_node
  end

  def find_words_at_substring(substring)
    this_node = get_node_at_substring(substring)
    @suggestions = []
    def traverse(node, results=@suggestions)
      if node.is_word then results << node.value end
      node.child.keys.each do |key|
        traverse(node.child[key])
      end
      results
    end
    traverse(this_node)
  end

  def suggest(substring) #returns max of 5 suggestions
    words = find_words_at_substring(substring)
    sorted_weight_words = words.map{ |word| [get_weight(substring, word) || 0, word] }.sort
    sorted_weight_words.reverse.map{ |array| array[1]}[0..5]
  end

  def populate(dictionary)
    words = dictionary.split("\n")
    words.each do |word|
      insert(word)
    end
  end

  def select(substring, word)
    this_node = get_node_at_substring(substring)
    if this_node.weight[word]
      this_node.weight[word] += 1
    else
      this_node.weight[word] = 1
    end
  end

  def get_weight(substring, word)
    get_node_at_substring(substring).weight[word]
  end
end


  #
  # def insert(word, cur_node=@root)
  #   cur_letter = word[0]
  #   new_word   = word[1..-1]
  #   #
  #   # if new_word == ''
  #   #   if cur_node[cur_letter].is_word == false
  #   #     cur_node.set_as_word
  #   #     @count += 1
  #   #   else
  #   #     return
  #   #   end
  #   # else
  #   #   insert(new_word, cur_node.add_child(cur_letter))
  #   # end
  #   # new_node = cur_node.add_child(cur_letter)
  #   # insert(new_word, new_node)
  #
  # end


  # def insert(word, cur_node=@root)
  #   letters = word.chars
  #   cur_letter = word.shift
  #   cur_node.add_child(letter)
  #   rest_of_word = word.join
  #   if rest_of_word == ''
  #     cur_node.set_as_word
  #   else
  #     cur_node.add_child()
  #
  #
  #   if letters.length == 1
  #     cur_node.set_as_word
  #   end
  # end
