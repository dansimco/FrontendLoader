require "sass"

class CSS_Processor
  def process(files)
    scss_string = ""
    files.each { |file| 
      scss_string << File.read(file)+"\n"
    }
    engine = Sass::Engine.new(scss_string, :syntax => :scss)
    css = engine.render
    File.open('style.css','w') { |f| 
      f.write(css)
    }
  end
end
