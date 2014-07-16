#!/usr/bin/env ruby

require 'marconiclient'
require 'pp'

url = 'http://162.209.105.136'
client = Marconiclient::Client.new(url)

#puts client.health

puts 'List queues'
pp client.queues

names = [:test1, :test2, :test3]
queues = Array.new

puts 'Create queues'
names.each do |n|
  q = client.queue(n)
  puts "#### #{q.name}"
  queues.push(q)
end

puts 'List queues'
pp client.queues

queues.each do |q|
  puts "#{q.name.upcase}"
  puts 'Exists?'
  puts q.exists?
  puts 'Delete'
  puts q.delete
  puts 'Exists?'
  puts q.exists?
end
