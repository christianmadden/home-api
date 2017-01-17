
require 'rubygems'
require 'bundler'

Bundler.require

require './devices/smart-things-control'
require './devices/hue-control'
require './devices/nest-control'
require './devices/sonos-control'
require './home'
require './app'

run App
