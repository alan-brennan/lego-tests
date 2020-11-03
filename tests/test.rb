require 'minitest/autorun'

require_relative '../lego.rb'

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

    #necessary or not? and is it needed for Legohat and LegoItem
    def test_creation_of_lego_figure
        assert_instance_of(LegoMinifigure, @lego_figure_full)
    end 

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
        expected = ""
        assert_equal(expected, actual)
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