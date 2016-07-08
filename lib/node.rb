class Node
  attr_accessor :child, :value, :is_word, :weight
  def initialize(value='')
    @child = {}
    @value = value
    @is_word = false
    @weight = {}
  end

  def add_child(key)
    @child[key] = Node.new(@value+key) unless @child.has_key?(key)
  end

end
