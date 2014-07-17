#!/usr/bin/env ruby

require 'marconiclient'
require 'pp'

url = 'http://162.209.105.136'
client = Marconiclient::Client.new(url)

puts client.health

# Create queue
puts "## Create queue"
q = client.queue 'test_queue'
puts "Exists? #{q.exists?}"

# Update metadata
puts "## Metadata"
pp q.metadata
metadata = {:var1 => {
          :subvar1 => "alpha",
          :subvar2 => [1,2,3,4]}}
puts "## Set metadata"
q.set_metadata(metadata, merge=false)
pp q.metadata
metadata = {
  :var1 => {
    :subvar1 => "beta",
    :subvar2 => [1,2,3,4]
  },
  :var2 => "monkey"
}
puts "## Merge metadata"
q.set_metadata(metadata)
pp q.metadata

# Stats
puts "## Stats"
pp q.stats

# Delete queue
puts "## Delete queue"
q.delete

#names = [:test1, :test2, :test3]
#queues = Array.new
#
#puts 'Create queues'
#names.each do |n|
#  q = client.queue(n)
#  puts "#### #{q.name}"
#  queues.push(q)
#end
#
#puts 'List queues'
#pp client.queues
#
#queues.each do |q|
#  puts "#{q.name.upcase}"
#  puts 'Exists?'
#  puts q.exists?
#  puts 'Delete'
#  puts q.delete
#  puts 'Exists?'
#  puts q.exists?
#end
