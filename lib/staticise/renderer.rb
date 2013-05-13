require 'fileutils'

module Staticise

  class Renderer
    attr_accessor :layout, :file

    def initialize(file)
      extract(file)
    end

    def render_page
      Haml::Engine.new(File.read(@layout)).render(self) do
        Haml::Engine.new(File.read(@file)).render(self)
      end
    end

    def partial(file, locals = {})
      if file.split("/").length > 1
        path = File.join(APP_ROOT, 'app', 'pages', "_#{ file.to_s }.haml")
      else
        path = File.join(File.dirname(@file), "_#{ file.to_s }.haml")
      end
      Haml::Engine.new(File.read(path)).render(self, locals)
    end

    def export
      b = 'app/pages/'
      out = File.join(APP_ROOT, 'public', @file[(@file.index(b) + b.length)..-1])
      out = File.join(File.dirname(out), "#{ File.basename(out, File.extname(out)) }.html")
      puts "  -- compiling #{ @file } => #{ out }"

      FileUtils.mkdir_p(File.dirname(out)) unless File.exist?(File.dirname(out))
      File.open(out, 'w') {|f| f.puts render_page}
    end

    def self.all
      self.pages
      self.scripts
      puts "DONE..."
    end

    def self.pages
      puts "Compiling pages.."
      files = Dir.glob(File.join(APP_ROOT, 'app/pages/**/*.haml'))
      files.each do |f|
        self.new(f).export unless File.basename(f).start_with?("_")
      end
      return
    end

    def self.scripts
      puts 'compiling coffees...'
      `coffee -o #{ File.join(APP_ROOT, 'public', 'js') } -c #{ File.join(APP_ROOT, 'app', 'js')}`
    end

    def self.init
      puts "Creating default folder structure.."
      %w{app/pages app/layouts app/js app/css}.each do |f|
        FileUtils.mkdir_p(File.join(APP_ROOT, f)) unless File.exist?(File.join(APP_ROOT, f))
      end
    end

    private

    def extract(file)
      @layout = File.join(APP_ROOT, "app", "layouts", "app.haml")
      @file = file
    end

  end

end
