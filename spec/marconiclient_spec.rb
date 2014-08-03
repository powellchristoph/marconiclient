require 'spec_helper'

describe "Marconiclient" do

  before do
    @client = Marconiclient::Client.new(MARCONI_SERVER)
  end

  describe '#new' do

    it 'should return a client object' do
      @client.should be_an_instance_of Marconiclient::Client
    end
  end

  describe 'base endpoints' do
    it 'should return the home document' do
      @client.home.should be_an_instance_of Hash
    end

    it 'should return the health' do
      @client.health.should eql true
    end
  end

  describe 'queues endpoints' do
    describe '#create' do
      before do
        @queue = @client.queue('empty_queue', false)
      end

      it 'should be a queue' do
        @queue.should be_an_instance_of Marconiclient::Queue
      end

      it 'should not exist on the server' do
        @queue.exists?.should eql false
      end
    end
  end
end
