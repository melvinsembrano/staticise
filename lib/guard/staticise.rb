require 'guard'
require 'guard/guard'
require 'guard/watcher'

require File.expand_path(File.join(File.dirname(__FILE__), "..", "staticise"))

module Guard
  class Staticise < Guard
    autoload :Notifier, File.join(File.dirname(__FILE__), 'staticise', 'notifier')

    DEFAULT_OPTIONS = {
      :output => 'public',
      :input => 'app',
      :all_on_start => true
    }

    def initialize(watchers =[], options = {})
      watchers = [] if !watchers
      ::Guard::UI.info("staticise watcher #{ watchers }")

      defaults = DEFAULT_OPTIONS.clone.merge(options)

      watchers << ::Guard::Watcher.new(%r{^#{ defaults[:input] }/(.+\.h[ta]ml)$})

      super(watchers, defaults)
    end

    def start
      run_all if options[:all_on_start]
    end

    def stop

    end

    def reload

    end

    def run_all
      begin
        ::Staticise::Renderer.pages
      rescue Exception => e
        message = "Error compiling pages: #{ e.message }"
        ::Guard::UI.info(message)
        Notifier.notify(false, message)


      end
    end

    def run_on_changes(paths)
      puts paths.join(", ")
      begin
        paths.each do |f|
          if File.basename(f).start_with?("_") || f.index("layouts")
            ::Staticise::Renderer.pages
          else
            ::Staticise::Renderer.new(f).export
          end
        end
      rescue Exception => e
        message = "Error compiling #{ paths.join(", ")}: #{ e.message }"
        ::Guard::UI.info(message)
        Notifier.notify(false, message)

      end

    end

    def run_on_removals(paths)
      # Runner.remove(Inspector.clean(paths, :missing_ok => true), watchers, options)
    end

  end
end
