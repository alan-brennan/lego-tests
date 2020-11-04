require 'minitest/autorun'

require_relative '../lego.rb'

# 1. Names of test classes should mimic the Ruby class by <ruby class name>_test.rb
#
# 2. Typically when you have many small classes in a single file its a code
# smell that you probably want to move them to different files. The benefits
# are that constant loading is more straightforward, and testing is easier and
# more explicit
#
# 3. Lots of these arguments are positional in nature. Meaning, the caller
# doesn't really know unless they read the method prototype or documentation
# what exactly these arguments should be, datatype or even data. This would be
# a good case to use keyword arguments.
#
# 4. Lots of the methods, like the methods in LegoMiniFigure class should be
# private. They are an implementation concern that only helps the public
# methods do work more easily. Keeping methods explicit as private or protected
# allows you to keep the guts of the class hidden from the public.
# Additionally, if you decide to change implementation details but not the
# public API you won't need to update tests
#
# 5. Generally you don't see custom to_s implementations in the wild. However,
# its completely fine to do so. For example, lets say you exposed a library
# that calling `to_s` on the result returned out some normalized result.
#
# 6. Testing should save you money. That's the whole point. It seems tedious
# now, but imagine you're working in a codebase with hundreds of other
# developers that is tens of thousands of lines large. Testing helps us by
# having computers check implementations are correct instead of humans.
#
# Lots of people really dislike testing, you'll often hear that tests might be
# slow, fragile (ie; will break if you change the implementation often).
# They're expensive, etc. It's absolutely possible to have cost effective tests.
#
# 7. Unit tests should be _few_. We want the code for the tests to be the most
# apt expression of how to interact with your code. We don't want extra lines
# of unnecessary test code.
#
# 8. As a rule of thumb, avoid `and` or `or` keywords in Ruby. Most of the time
# these are footguns. `||` has a higher precedence than `or`. A common example
# of this is:
#
#   a = false || true  #=> true
#   a  #=> true
#   a = false or true  #=> true
#   a  #=> false
#
# 9. Sometimes its difficult to find the balance of too few and too many tests.
# Ultimately, unit tests add a cost. It's about finding the right balance of
# too much and too little testing.

class TestLego < Minitest::Test
    def test_do_stuff
        # We now can leverage our fully feature test helper methods to help us
        # create dummy data

        lego_hat
        lego_item
        lego_figure(hat: false)
    end

    private

    # We can leverage memoization here. If we call this method multiple times
    # in the same test we won't create needless objects.
    def lego_hat
        @lego ||= LegoHat.new(4, "blue", "baseball")
    end

    def lego_item
        @lego_item ||= LegoItem.new("sign", 10)
    end

    # We don't actually care about the contents of the data here. If we did,
    # these could be modified to pass in explicit data instead. In a typical
    # Rails application we'll leverage fixtures
    # (https://api.rubyonrails.org/v3.1/classes/ActiveRecord/Fixtures.html)
    # rather than an implementation like this.
    def lego_figure(hat: true, left_item: true, right_item: true)
        data = []
        data << 'Alan'
        data << lego_hat if hat
        data << lego_item if left_item
        data << lego_item if right_item

        LegoMinifigure.new(*data)
    end
end

class TestLego < Minitest::Test
    def setup
        @lego_hat = LegoHat.new(4, "blue", "baseball")
        @lego_not_stylish_hat = LegoHat.new(4, "green", "tophat")
        @lego_item_left = LegoItem.new("sign", 10)
        @lego_item_right = LegoItem.new("light", 8)
        @lego_figure_full = LegoMinifigure.new("Alan", @lego_hat, @lego_item_left, @lego_item_right)
        @lego_figure_no_hat = LegoMinifigure.new("Alan", nil, @lego_item_left, @lego_item_right)
        @lego_figure_no_left_item_no_hat = LegoMinifigure.new("Alan", nil, nil, @lego_item_right)
        @lego_figure_no_left_item_and_hat = LegoMinifigure.new("Alan", @lego_hat, nil, @lego_item_right)
        @lego_figure_no_items_no_hat = LegoMinifigure.new("Alan")
        @lego_figure_with_non_stylish_hat = LegoMinifigure.new("Alan", @lego_not_stylish_hat)
    end

    # This test is not necessary.

    #necessary or not? and is it needed for Legohat and LegoItem
    # def test_creation_of_lego_figure
    #     assert_instance_of(LegoMinifigure, @lego_figure_full)
    # end

    def test_to_string_for_lego_hat
        actual = @lego_hat.to_s
        expected = "a 4 blue baseball"
        assert_equal(expected, actual)
    end

    def test_to_string_for_lego_item
        actual = @lego_item_left.to_s
        expected =  "a 10 gram sign"
        assert_equal(expected, actual)
    end

    def test_the_lego_item_is_heavy_returns_true_above_threshold
        assert(@lego_item_left.is_heavy(9))
    end

    def test_the_lego_item_is_heavy_returns_false_below_threshold
        refute(@lego_item_left.is_heavy(10))
    end

    # test this or test to_s NOTE: hat_words is not a private method
    def test_hat_description_is_returned_for_lego_figure_with_a_hat
        actual = @lego_figure_full.hat_words
        expected =  ", who is wearing a 4 blue baseball"
        assert_equal(expected, actual)
    end

    def test_left_item_words_for_figure_with_no_left_item_and_hat_words
        actual = @lego_figure_no_left_item_and_hat.left_item_words
        # expected = ""

        assert_empty(actual)
        # assert_equal(expected, actual)
    end

    def test_left_item_words_for_figure_with_left_item_and_hat_words
        actual = @lego_figure_full.left_item_words
        expected = " and is holding a 10 gram sign in the left hand"
        assert_equal(expected, actual)
    end

    def test_left_item_words_for_figure_with_left_item_and_no_hat
        actual = @lego_figure_no_hat.left_item_words
        expected = ", who is holding a 10 gram sign in the left hand"
        assert_equal(expected, actual)
    end

    def test_right_item_words_for_figure_with_right_item_and_hat
        actual = @lego_figure_full.right_item_words
        expected = " and a 8 gram light in the right hand"
        assert_equal(expected, actual)
    end

    def test_right_item_words_for_figure_with_right_item_and_no_hat
        actual = @lego_figure_no_hat.right_item_words
        expected = " and a 8 gram light in the right hand"
        assert_equal(expected, actual)
    end

    def test_right_item_words_for_figure_with_right_item_and_no_left_item_and_no_hat
        actual = @lego_figure_no_left_item_no_hat.right_item_words
        expected = ", who is holding a 8 gram light in the right hand"
        puts "The difference is..."
        puts "#{diff(expected, actual)}"
        assert_equal(expected, actual)
    end

    def test_right_item_words_for_figure_with_right_item_and_no_left_item_and_hat
        actual = @lego_figure_no_left_item_and_hat.right_item_words
        expected = " , who is holding a 8 gram light in the right hand"
        assert_equal(expected, actual)
    end

    def test_right_item_words_for_figure_with_no_items_and_no_hat
        #actual = @lego_figure_no_items_no_hat.right_item_words
        #expected = ""
        #assert_equal(expected, actual)
        assert_empty(@lego_figure_no_items_no_hat.right_item_words)
    end

    # Red, blue, and no hat cases should be tested

    # Should I test for red hat also
    def test_is_stylish_for_minifigure_blue_hat
        assert(@lego_figure_full.is_stylish?)
    end

    def test_is_stylish_for_minifigure_green_hat
        refute(@lego_figure_with_non_stylish_hat.is_stylish?)
    end

    def test_wear_hat_lego_mini_figure
        @lego_figure_no_items_no_hat.wear_hat(@lego_not_stylish_hat)
        actual = @lego_figure_no_items_no_hat.hat_words
        expected = ", who is wearing a 4 green tophat"
        assert_equal(expected, actual)
    end

    # can these be done in one test? should they be done like this
    def test_swap_hands_right_hand_for_lego_mini_figure
        actual = @lego_figure_full.swap_hands.right_item.name
        expected = "sign"
        assert_equal(expected, actual)
    end

    def test_swap_hands_left_hand_for_lego_mini_figure
        actual = @lego_figure_full.swap_hands.left_item.name
        expected = "light"
        assert_equal(expected, actual)
    end

    # test to_s for LegoMiniFigure
    # Q. How many tests given that hat_words, left_arm_words etc have been tested

    #test place_in_left_hand with item and without existing item in hand
    #test place_in_right_hand with item and without existing item in hand

    #test is_strong right || left
    #test is_strong right && left
    #test is_strong on boundary 10/10, 9/10, 10/9, 9/9
end

# Example case

# class MyApi
#     class << self
#         def fetch!
#             # does some remote http work
#             Net::HTTP.get(...)
#         end
#     end
# end

# def test_fetch!
#     # test all possible cases here
# end


# class MyOtherService
#     def meth
#         result = MyApi.fetch!
#         # does stuff
#     end
# end

# def test_meth
#     MyApi.expect(:fetch!).return({})
# end

# # allow requests to /foo
# def foo
#     MyOtherService.meth
#     # bunce of other stuff
# end
