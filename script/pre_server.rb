#!/usr/bin/env ruby
# encoding: utf-8

require 'yaml'
config = YAML.load_file('/config/' + ENV['CONFIG_FILE'].to_s)

