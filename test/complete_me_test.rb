require "minitest/autorun"
require "minitest/pride"
require 'simplecov'
require "./lib/complete_me"
SimpleCov.start

class CompleteMeTest < Minitest::Test
  def test_it_exists
    c = CompleteMe.new
    assert c
  end

  def test_count_begins_at_zero
    c = CompleteMe.new
    assert_equal 0, c.count
  end

  def test_it_inserts_a_letter
    c = CompleteMe.new
    assert c.insert('a')
    assert_equal 'a', c.root.child['a'].value
  end

  def test_it_inserts_a_word
    c = CompleteMe.new
    assert c.insert('pie')
    assert_equal 'pie', c.root.child['p'].child['i'].child['e'].value
  end

  def test_it_counts_words
    c = CompleteMe.new
    assert_equal 0, c.count
    c.insert('ape')
    assert_equal 1, c.count
    c.insert('bear')
    c.insert('cat')
    assert_equal 3, c.count
  end

  def test_it_doesnt_count_duplicates
    c = CompleteMe.new
    c.insert('eagle')
    assert_equal 1, c.count
    c.insert('eagle')
    assert_equal 1, c.count
    c.insert('eager')
    assert_equal 2, c.count
  end

  def test_it_finds_words
    c = CompleteMe.new
    refute c.find('pie')
    c.insert('pie')
    assert c.find('pie')
    c.insert('piggy')
    assert c.find('piggy')
    refute c.find('pigg')
  end

  def test_it_returns_node_at_substring
    c = CompleteMe.new
    c.insert('elephant')
    assert_equal 'elep', c.get_node_at_substring('elep').value
  end

  def test_it_doesnt_find_nonexistent_node
    c = CompleteMe.new
    refute c.get_node_at_substring('elep')
  end

  def test_it_finds_words_at_substring
    c = CompleteMe.new
    c.insert('pizza')
    c.insert('pizzeria')
    c.insert('pie')
    c.insert('pictograph')
    c.insert('panorama')
    expect = ["panorama", "pictograph", "pie", "pizza", "pizzeria"]
    assert_equal expect[1..4], c.find_words_at_substring('pi').sort
    assert_equal expect[3..4], c.find_words_at_substring('piz').sort
  end

  def test_it_suggests_with_one_word
    c = CompleteMe.new
    c.insert('pizza')
    assert_equal ['pizza'], c.suggest('piz')
  end

  def test_it_populates_dictionary
    c = CompleteMe.new
    c.insert('pizza')
    assert_equal 1, c.count
    dict = File.read("/usr/share/dict/words")
    c.populate(dict)
    assert_equal 235886, c.count
  end

  def test_it_suggests_many_words
    c = CompleteMe.new
    c.populate(File.read("/usr/share/dict/words"))
    expect = ["pize", "pizza", "pizzeria", "pizzicato", "pizzle"]
    assert_equal expect, c.suggest('piz').sort
  end

  def test_select_increases_a_weight
    c = CompleteMe.new
    c.populate(File.read("/usr/share/dict/words"))
    c.select("piz", "pizzeria")
    assert_equal 1, c.get_node_at_substring("piz").weight["pizzeria"]
  end

  def test_get_weight_method
    c = CompleteMe.new
    c.populate(File.read("/usr/share/dict/words"))
    c.select("piz", "pizzeria")
    assert_equal 1, c.get_weight("piz", 'pizzeria')
  end

  def test_select_increases_weight_with_many_words
    c = CompleteMe.new
    c.populate(File.read("/usr/share/dict/words"))
    c.select("piz", "pizzeria")
    c.select("piz", "pizzeria")
    c.select("piz", "pizzeria")
    c.select("pi", "pizza")
    c.select("pi", "pizza")
    c.select("pi", "pizzicato")
    assert_equal 3, c.get_weight("piz", "pizzeria")
    assert_equal 2, c.get_weight("pi", "pizza")
    assert_equal 1, c.get_weight("pi", "pizzicato")
  end

  def test_suggest_works_with_specific_substrings
    c = CompleteMe.new
    c.populate(File.read("/usr/share/dict/words"))
    c.select("piz", "pizzeria")
    c.select("piz", "pizzeria")
    c.select("piz", "pizzeria")
    c.select("pi", "pizza")
    c.select("pi", "pizza")
    c.select("pi", "pizzicato")
    assert_equal "pizzeria", c.suggest("piz")[0]
    assert_equal "pizza", c.suggest("pi")[0]
    assert_equal "pizzicato", c.suggest("pi")[1]
  end

  def test_suggestions_with_other_words
    c = CompleteMe.new
    c.populate(File.read("/usr/share/dict/words"))
    c.select("h", "hey")
    c.select("h", "hey")
    c.select("h", "hi")
    c.select("h", "hey")
    c.select("he", "hello")
    c.select("he", "hello")
    c.select("he", "hey")
  end


end
