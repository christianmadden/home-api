
require 'rubygems'
require 'bundler'

Bundler.require

require 'dotenv'
Dotenv.load

require './devices/smartthings'
require './devices/hue'
require './devices/nest'
require './devices/sonos'
require './home'
require './app'

run App
