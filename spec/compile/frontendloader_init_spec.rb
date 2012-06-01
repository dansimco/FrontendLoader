require 'rubygems'
require 'yaml'

require_relative '../../lib/FrontendLoader'

describe FrontendLoader do

  before :all do
    @fel = FrontendLoader.new
    @fel.resources_path = "../../resources"
    @fel.load_settings
    puts @fel.settings.inspect
    puts "\n\n\n"
    @fel.compile
    puts "compiled"
  end

  it 'The javascript should not contain ignored files' do
    code = File.read('./js.js')
    describe code do
      it { should_not include("ignored")}
    end
  end

  it 'The css should not contain ignored files' do
    code = File.read('./style.css')
    describe code do
      it { should_not include("ignored")}
    end
  end
  

  
end
