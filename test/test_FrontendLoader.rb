require 'test/unit'
require 'FrontendLoader'

class FrontendLoaderTest < Test::Unit::TestCase

  def setup
   
  end
  
  def test_compile
    assert_equal false,
          FrontendLoader.new.compile
  end

end
