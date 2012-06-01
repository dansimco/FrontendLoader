require 'rubygems'
require 'yaml'

require_relative '../../lib/FrontendLoader'

describe FrontendLoader do

  before :all do
    @fel = FrontendLoader.new
    @fel.resources_path = "../../resources"
  end
  
  after :all do
    #Cleanup
  end

  it 'It should copy the yml file to the directory' do
    @fel.init_app
    File.exists?("FrontendLoader.yml").should eq true
    @settings = YAML.load_file('FrontendLoader.yml')
  end  
  
end
