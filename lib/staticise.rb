$:.unshift File.dirname(__FILE__)

require 'rubygems'
require 'fileutils'
require 'haml'

APP_ROOT = File.expand_path(File.dirname(__FILE__) + "../../")

require 'staticise/renderer'
