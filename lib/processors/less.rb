class CSS_Processor
  def process(less_files)
    if less_files.length > 0 then
      less_files.delete("style.less")
      less_string = ""
      less_files.each { |file|
        file = file.gsub(".less","")
        less_string = less_string + "@import '#{file}'; \n"
        File.open('style.less','w') { |f| 
           f.write(less_string)
         }
      }
      %x[lessc style.less style.css]
      %x[rm style.less]
    end    
  end
end
