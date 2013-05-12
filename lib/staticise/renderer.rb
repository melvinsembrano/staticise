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

    private

    def extract(file)
      puts "app root is " + APP_ROOT
      @layout = File.join(APP_ROOT, "app", "layouts", "fixed.haml")
      @file = file
    end

  end

end
