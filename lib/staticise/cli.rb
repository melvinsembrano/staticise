require 'guard'
require 'guard/cli'
require 'guard/staticise'

module Staticise
  class CLI < ::Guard::CLI

    desc 'init [GUARDS]', 'Generates a Guardfile at the current directory (if it is not already there) and adds all installed guards or the given GUARDS into it'

    method_option :bare,
                  :type => :boolean,
                  :default => false,
                  :aliases => '-b',
                  :banner => 'Generate a bare Guardfile without adding any installed guard into it'

    # Initializes the templates of all installed Guard plugins and adds them
    # to the `Guardfile` when no Guard name is passed. When passing
    # Guard plugin names it does the same but only for those Guard plugins.
    #
    # @see Guard::Guard.initialize_template
    # @see Guard::Guard.initialize_all_templates
    #
    # @param [Array<String>] guard_names the name of the Guard plugins to initialize
    #
    def init(*guard_names)
      puts "initializing..."

      ::Staticise::Renderer.init

      verify_bundler_presence

      ::Guard::Guardfile.create_guardfile(:abort_on_existence => options[:bare])

      return if options[:bare]

      File.open('Guardfile', 'wb') do |f|

        f.puts("guard 'coffeescript', :input => 'app/js', :output => 'public/js'")
        f.puts("guard 'sass', :input => 'app/css', :output => 'public/css'")
        f.puts("guard 'less', :output => 'public/css'")
        f.puts("guard 'staticise', :input => 'app', :output => 'public'")

      end

=begin
      if guard_names.empty?
        ::Guard::Guardfile.initialize_all_templates
      else
        guard_names.each do |guard_name|
          ::Guard::Guardfile.initialize_template(guard_name)
        end
      end
=end

    end
  end
end
