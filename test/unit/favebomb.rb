require 'minitest/autorun'
require 'minitest/unit'
require 'minitest/pride'

$:.unshift File.dirname(__FILE__) + '/../../lib'
require 'favebomb'

class TestFavebomb < MiniTest::Unit::TestCase

  def setup
    @favebomb = Favebomb.new
    @favebomb.bomb "bieber"
  end

  def test_that_it_can_bomb_a_term
    @favebomb.instance_variable_get("@faved").count.must_be_close_to @favebomb.instance_variable_get("@results").count, 1
    @favebomb.instance_variable_get("@faved").must_be_kind_of Array
  end

end
