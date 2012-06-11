require 'jscat'
require 'filestojs'
require 'yaml'

class FrontendLoader

  attr_accessor :resources_path
  attr_accessor :settings

  def initialize
    version = '0.0.4'
    @gem_path = Gem.path[0]+"/gems/frontendloader-"+version
    @resources_path = Gem.path[0]+"/gems/frontendloader-"+version+"/resources"
    @processors = {}
  end

  def init_app
    if File.exists?  'FrontendLoader.yml' then
      puts "Frontend Loader already initialized"
      return false
    end
    config_path = @resources_path+"/FrontendLoader.yml"
    guard_path = @resources_path+"/Guardfile"
    %x[cp #{config_path} FrontendLoader.yml]
    %x[cp #{guard_path} Guardfile]
    puts "Created basic FrontendLoader app, check FrontendLoader.yml for config"
  end

  def boilerplate
    load_settings    
  end

  def load_settings
    if  ! File.exists?  'FrontendLoader.yml' then
      init_app
    end
    begin
      @settings = YAML.load_file('FrontendLoader.yml')        
      return true
    rescue Exception => e
      puts "FrontendLoader.yml could not be parsed as valid YAML, please check your syntax"
      return false
    end
  end
  
  
  def compile
    return false unless load_settings

    #CSS
    if @settings['css']['enabled'] then
      css_source_files = Dir.glob("*.#{@settings['css']['format']}")
      if @settings['css']['prioritize'] then
        css_source_files = prioritize_files(css_source_files,@settings['css']['prioritize'])
      end
      if @settings['css']['ignore']
        css_source_files = clean_ignored_files(css_source_files,@settings['css']['ignore'])
      end
      begin
        css_processor_found = require "processors/#{@settings['css']['format']}.rb"
      rescue Exception => e
        puts "No processor for #{@settings['css']['format']} found"
        css_processor_found = false
      end
      if css_processor_found then
        css_processor = CSS_Processor.new
        css_processor.process(css_source_files)
      end
      puts "Compiled css into css.css"
    end
    
    #TEMPLATES
    if @settings['templates']['enabled'] then
      template_files = Dir.glob("*.#{@settings['templates']['format']}")
      if @settings['templates']['prioritize'] then
        template_files = prioritize_files(template_files,@settings['templates']['prioritize'])
      end
      if @settings['templates']['ignore'] then
        template_files = clean_ignored_files(template_files,@settings['templates']['ignore'])
      end
      templates_source = "#{@settings['templates']['varname']} = {};\n"
      template_files.each {|file|
        template_markup = File.read(file)
        template_markup.gsub!("\n","")
        template_markup.gsub!("\"","\\\"")
        template_markup = template_markup.strip.gsub(/\s{2,}/, ' ')
        templates_source << "#{@settings['templates']['varname']}['#{file.split('.')[0]}'] = \"#{template_markup}\";\n"
      }
      puts "Compiled templates into #{@settings['templates']['varname']} variable"
    else
      templates_source = ""
    end
    
    #JS
    if @settings['javascript']['enabled'] then
      js_source_files = Dir.glob("*.js")
      if @settings['javascript']['prioritize'] then
        js_source_files = prioritize_files(js_source_files,@settings['javascript']['prioritize'])
      end
      # if @settings['javascript']['ignore'].class != Array then
      #   @settings['javascript']['ignore'] = []
      # end
      if @settings['javascript']['ignore'] then
        js_source_files = clean_ignored_files(js_source_files,(@settings['javascript']['ignore'] << 'js.js'))
      end
      js_source = ""
      js_source_files.each { |file| 
        js_source << File.read(file)+"\n"
      }
      js_source << templates_source
      if @settings['javascript']['jsmin'] then
        begin
          jsmin = require "jsmin"
        rescue Exception => e
          puts "JSmin not installed"
        end
        if jsmin then 
          js_source = JSMin.minify(js_source)
        end
      end
      if @settings['javascript']['yui'] then
        begin
          yui = require "yui/compressor"          
        rescue Exception => e
          puts "YUI compressor gem not installed"
        end
        if yui then
          compressor = YUI::JavaScriptCompressor.new
          js_source = compressor.compress(js_source)
        end
      end
      File.open('js.js','w') { |f| 
       f.write(js_source)
      }
      puts "Compiled javascript into js.js"
    end
    
  end
  
  def prioritize_files(files, priority_files=[],path="")
    if priority_files.class != Array then
      priority_files = []
    end
    priority_files.uniq.each {|file|
      if files.include? file then
        files.delete file
      else
        priority_files.delete file
      end
    }
    prioritized_files = priority_files + files
    return prioritized_files
  end
  
  def clean_ignored_files(files, ignored_files=[],path="")
    if ignored_files.class != Array then
      ignored_files = []
    end
    cleaned_list = []
    ignored_files.uniq.each {|file|
      if files.include? file then
        files.delete file
      end
    }
    return files
  end
  
  def compile_old

    
    
    
    
    #less
    
    less_files = Dir.glob("*.less")

    if less_files.length > 0 then

      less_files.delete("style.less")
      less_string = ""
      less_files.each { |file|
        puts "Loading #{file}..."
        file = file.gsub(".less","")
        less_string = less_string + "@import '#{file}'; \n"
        File.open('style.less','w') { |f| 
           f.write(less_string)
         }
      }
      %x[lessc style.less style.css]
      # %x[rm style.less]
      
    end
    
    
    #TEMPLATES

    template_joiner = FilesToJs.new({
      :file_dir        => '.',
      :file_format     => @settings['templates']['format'],
      :js_object_name  => @settings['templates']['varname'],
      :output          => @settings['templates']['varname']+".js",
    })
    template_joiner.write_js
    
    
    
    #Javascript (includes joined templates)
    

    javascript = JsCat.new({
      :js_dir => '.',
      :prioritize => @settings['javascript']['prioritize'],
      :ignore => ['js.js'],
      :compress => @settings['javascript']['compress'],
      :output => 'js.js'
    })
    
    %x[rm templates.js]
    
    puts "Compiled into js.js and style.css"
    
  end
  
  

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  

  
end