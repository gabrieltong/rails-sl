require 'test_helper'

class CardTplTest < ActiveSupport::TestCase
  context "can acquire" do
    setup do
      @card_tpl = CardTpl.new
    end

    should "return card_tpl_inactive if inactive" do
      a = 5
      assert_equal 4, a
    end
  end
end
