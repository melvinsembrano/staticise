require 'fileutils'
require 'yaml'

module Staticise

  class Renderer
    attr_accessor :layout, :file

    def initialize(file)
      extract(file)
    end

    def render_page
      Haml::Engine.new(read_template(@layout)).render(self) do
        Haml::Engine.new(read_template(@file)).render(self)
      end
    end

    def partial(file, locals = {})
      if file.split("/").length > 1
        path = File.join(APP_ROOT, 'app', 'pages', "_#{ file.to_s }")
      else
        path = File.join(File.dirname(@file), "_#{ file.to_s }")
      end
      Haml::Engine.new(read_template(path)).render(self, locals)
    end

    def export
      b = 'app/pages/'
      out = File.join(APP_ROOT, 'public', @file[(@file.index(b) + b.length)..-1])
      out = File.join(File.dirname(out), "#{ File.basename(out, File.extname(out)) }.html")
      puts "  -- compiling #{ @file } => #{ out }"

      FileUtils.mkdir_p(File.dirname(out)) unless File.exist?(File.dirname(out))
      File.open(out, 'w') {|f| f.puts render_page}
    end

    def self.compile_css(file)
      b = 'app/css/'
      out = File.join(APP_ROOT, 'public', 'css', file[(file.index(b) + b.length)..-1])
      out = File.join(File.dirname(out), "#{ File.basename(out, File.extname(out)) }.css")
      puts "  -- compiling #{ file } => #{ out }"

      FileUtils.mkdir_p(File.dirname(out)) unless File.exist?(File.dirname(out))
      `lessc #{ file } #{ out }`
      true
    end

    def self.pages
      puts "Compiling pages.."
      files = Dir.glob(File.join(APP_ROOT, 'app/pages/**/*.haml'))
      files << Dir.glob(File.join(APP_ROOT, 'app/pages/**/*.html'))
      files.flatten.each do |f|
        self.new(f).export unless File.basename(f).start_with?("_")
      end
      return
    end


    def self.init
      puts "Creating default folder structure.."
      %w{app/pages app/layouts app/js app/css}.each do |f|
        FileUtils.mkdir_p(File.join(APP_ROOT, f)) unless File.exist?(File.join(APP_ROOT, f))
      end
    end

    private

    def read_template(file)
      if File.extname(file).eql?(".html")
        s = [":erb\n"]
        s << File.readlines(file).map {|l| "  #{ l }"}
        res = s.flatten.join
      else
        res = File.read(file)
      end
      # puts res
      res
    end

    def extract(file)
      @file = file
      @layout = File.join(APP_ROOT, "app", "layouts", get_layout(file))
    end

    def get_layout(file)
      config = File.join(File.dirname(file), "config.yml")
      unless File.exist?(config)
        config = File.join(APP_ROOT, "config.yml")
        unless File.exist?(config)
          config = File.join(LIB_ROOT, "config.yml")
        end
      end
      data = YAML.load_file(config)

      data["layout"] || "app.haml"
    end

  end

end
