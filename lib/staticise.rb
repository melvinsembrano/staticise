$:.unshift File.dirname(__FILE__)

require 'rubygems'
require 'fileutils'
require 'haml'

APP_ROOT = "." #File.expand_path(File.dirname(__FILE__) + "../../")
LIB_ROOT = File.expand_path(File.dirname(__FILE__) + "../../")

require 'staticise/renderer'
require 'staticise/watcher'

