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
      @client.health.should be_true
    end
  end

  describe 'queues endpoints' do
    describe '#create' do
      before do
        @manual_queue = @client.queue('manual_queue', false)
        @auto_queue = @client.queue('auto_queue')
      end

      after do
        @manual_queue.delete
        @auto_queue.delete
      end

      it 'should be a queue' do
        @manual_queue.should be_an_instance_of Marconiclient::Queue
      end

      it 'should not exist on the server' do
        @manual_queue.exists?.should be_false
      end

      it 'should exist on server after creation' do
        @manual_queue.create
        @manual_queue.exists?.should be_true
      end

      it 'should exist on autocreate' do
        @auto_queue.exists?.should be_true
      end
    end

    describe '#list_queue' do
      describe 'with empty queues' do
        let(:resp) { @client.queues }
  
        it 'should return Hash' do
          resp.should be_an_instance_of Hash
        end
  
        it 'should have links and queues' do
          resp.should have_key(:links)
          resp.should have_key(:queues)
        end
  
        it 'should be empty' do
          resp[:links].should be_empty
          resp[:queues].should be_empty
        end
      end

      describe 'with full queues' do
        before do
          @queue_list = Array.new
          (1..5).each { |i| @queue_list << @client.queue("test#{i}") }
        end

        after do
          @queue_list.each { |q| q.delete }
        end

        let(:resp) { @client.queues }

        it 'should have links and queues' do
          resp.should have_key(:links)
          resp.should have_key(:queues)
        end

        it 'should have 5 queues' do
          resp[:queues].should have(5).items
        end
      end
    end
  end
end
