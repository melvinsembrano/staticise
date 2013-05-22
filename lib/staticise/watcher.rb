require 'fileutils'
require 'listen'

module Staticise

  class Watcher
    attr_accessor :no_sass, :no_less, :no_haml, :no_coffee

    def initialize(options)
      @no_sass = !options.no_sass.nil?
      @no_less = !options.no_less.nil?
      @no_haml = !options.no_haml.nil?
      @no_coffee = !options.no_coffee.nil?

      puts "listening now with #{ self.inspect }"

      @listener = Listen.to!(File.join(APP_ROOT, 'app')) do |modified, added, removed|
        process(modified)
      end
    end

    def process(file)
      if file.class.eql?(Array)
        file.each {|f| process(f)}
        return
      end

      ext = File.extname(file.to_s).downcase

      case ext
        when ".sass"
          sass(file) unless @no_sass
        when ".less"
          less(file) unless @no_less
        when ".haml"
          haml(file) unless @no_haml
        when ".coffee"
          coffee(file) unless @no_coffee
        else

      end
    end

    def haml(file)
      Staticise::Renderer.pages
    end

    def less(file)
      Staticise::Renderer.styles
    end

    def sass(file)
      puts "processing #{ file }"
      ext = '.sass'
      FileUtils.mkdir_p(File.join(APP_ROOT, "public", "css")) unless File.exist?(File.join(APP_ROOT, "public", "css"))
      `sass #{ File.join(APP_ROOT, 'app', file) }:#{ File.join(APP_ROOT, 'public', File.dirname(file), "#{ File.basename(file, ext) }.css") }`
    end

    def coffee(file)
      Staticise::Renderer.scripts
    end
  end
end
