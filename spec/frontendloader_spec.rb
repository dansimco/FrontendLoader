require 'rubygems'
require 'yaml'

require_relative '../lib/FrontendLoader'

describe FrontendLoader do

  before :all do
    @fel = FrontendLoader.new
    @fel.resources_path = "../resources"
  end
  
  after :all do
    #Cleanup
    %x[rm FrontEndLoader.yml]
    %x[rm test_view.mustache]
    %x[rm js.js]
    %x[rm style.css]
  end

  it 'It should copy the yml file to the directory' do
    @fel.init_app
    File.exists?("FrontendLoader.yml").should eq true
    @settings = YAML.load_file('FrontendLoader.yml')
  end
  
  it 'should be able to compile' do
    @fel.compile    
    File.exists?("js.js").should eq true
    File.exists?("style.css").should eq true
  end
  
  
end
