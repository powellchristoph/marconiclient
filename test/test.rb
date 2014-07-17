#!/usr/bin/env ruby

require 'marconiclient'
require 'pp'

url = 'http://162.209.105.136'
client = Marconiclient::Client.new(url)

puts client.health

# Create queue
puts "\n## Create queue ####################################"
q = client.queue 'test_queue'
puts "Exists? #{q.exists?}"

# Update metadata
puts "\n## Metadata ####################################"
pp q.metadata
metadata = {:var1 => {
          :subvar1 => "alpha",
          :subvar2 => [1,2,3,4]}}
puts "\n## Set metadata ####################################"
q.set_metadata(metadata, merge=false)
pp q.metadata
metadata = {
  :var1 => {
    :subvar1 => "beta",
    :subvar2 => [1,2,3,4]
  },
  :var2 => "monkey"
}
puts "\n## Merge metadata ####################################"
q.set_metadata(metadata)
pp q.metadata

# Submit message
puts "\n## Post message ####################################"
pp q.post({:ttl => 300, :body => { :var => "alpha"}})
messages = Array.new
10.times do |id|
  messages.push({:ttl => 300, :body => {:id => id}})
end
#puts "## Messages"
#pp messages
puts "\n## Post Messages ####################################"
pp q.post(messages)

# Stats
puts "\n## Stats ####################################"
pp q.stats

# Delete queue
puts "\n## Delete queue ####################################"
pp q.delete

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
