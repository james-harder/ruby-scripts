# From https://www.geeksforgeeks.org/how-to-parse-a-yaml-file-in-ruby/
require 'yaml'
require 'json'

data = YAML.load_file('example.yaml')

puts data['apiVersion'].class
puts data['metadata'].class

puts JSON.generate(data)