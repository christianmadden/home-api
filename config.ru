
require 'rubygems'
require 'bundler'

Bundler.require

require 'dotenv'
Dotenv.load

require './devices/smartthings-control'
require './devices/hue-control'
require './devices/nest-control'
require './home'
require './app'

run App
