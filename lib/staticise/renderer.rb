require 'fileutils'

module Staticise

  class Renderer
    attr_accessor :layout, :file

    def initialize(file)
      extract(file)
    end

    def render
      Haml::Engine.new(File.read(@layout)).render do
        Haml::Engine.new(File.read(@file)).render
      end
    end

    def export
      b = 'app/pages/'
      out = File.join(APP_ROOT, 'public', @file[(@file.index(b) + b.length)..-1])
      out = File.join(File.dirname(out), "#{ File.basename(out, File.extname(out)) }.html")
      puts "  -- compiling #{ @file } => #{ out }"

      FileUtils.mkdir_p(File.dirname(out)) unless File.exist?(File.dirname(out))
      File.open(out, 'w') {|f| f.puts render}
    end

    def self.all
      puts "Compiling pages.."
      files = Dir.glob(File.join(APP_ROOT, 'app/pages/**/*.haml'))
      files.each do |f|
        self.new(f).export
      end
      return
    end

    private

    def extract(file)
      @layout = File.join(APP_ROOT, "app", "layouts", "app.haml")
      @file = file
    end

  end

end
