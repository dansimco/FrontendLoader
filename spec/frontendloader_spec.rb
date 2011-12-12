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
    %x[rm test_view.less]
    %x[rm TestView.js]
    %x[rm js.js]
    %x[rm style.css]
  end

  it 'It should copy the yml file to the directory' do
    @fel.init_app
    File.exists?("FrontendLoader.yml").should eq true
    @settings = YAML.load_file('FrontendLoader.yml')
  end
  
  it 'should be able to create a view' do
    @fel.create_view('test_view')
    File.exists?("test_view.mustache").should eq true
    File.exists?("test_view.less").should eq true
    File.exists?("TestView.js").should eq true
  end
  
  it 'should not blow away an existing view' do
    @fel.create_view('test_view')
    @fel.create_view('test_view').should eq(false)
  end
  
  it 'should be able to compile' do
    @fel.compile    
    File.exists?("js.js").should eq true
    File.exists?("style.css").should eq true
  end
  
  
end
