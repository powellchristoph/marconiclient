require 'spec_helper'
require 'pp'

describe "Marconiclient" do

  let(:client) { Marconiclient::Client.new(MARCONI_SERVER) }

  describe 'new client' do
    it 'should return a client object' do
      client.should be_an_instance_of Marconiclient::Client
    end
  end

  describe 'has base endpoints' do
    it 'should return the home document' do
      client.home.should be_an_instance_of Hash
    end

    it 'should return the health' do
      client.health.should be_true
    end
  end

  describe 'queues endpoints' do
    let(:manual_queue) { client.queue('manual_queue', false) }
    let(:auto_queue) { client.queue('auto_queue') }

    describe 'create queue' do
      it 'should be a queue object' do
        manual_queue.should be_an_instance_of Marconiclient::Queue
      end

      it 'should not exist on the server' do
        manual_queue.exists?.should be_false
      end

      it 'should exist on server after creation' do
        manual_queue.create
        manual_queue.exists?.should be_true
      end

      it 'should exist on server with autocreate' do
        auto_queue.exists?.should be_true
      end

      it 'should have proper name' do
        auto_queue.name.should match('auto_queue')
      end
    end

    describe 'delete queue' do
      it 'should delete the queues' do
        manual_queue.delete
        auto_queue.delete
        manual_queue.exists?.should be_false
        auto_queue.exists?.should be_false
      end
    end

    describe 'list queues' do
      describe 'with no queues on server' do
        let(:resp) { client.queues }
  
        it 'should return Hash' do
          resp.should be_an_instance_of Array
        end
  
        it 'should be empty' do
          resp.should be_empty
        end
      end

      describe 'with queues on server' do
        before do
          @queue_list = Array.new
          (1..5).each { |i| @queue_list << client.queue("test#{i}") }
        end

        after do
          @queue_list.each { |q| q.delete }
        end

        let(:resp) { client.queues }

        it 'should have 5 queues' do
          resp.should have(5).items
        end
      end
    end

    describe 'stats' do
      it 'should return Hash' do
        manual_queue.create
        manual_queue.stats.should be_an_instance_of Hash
        manual_queue.delete
      end
    end

    describe 'metadata' do
      let(:metadata_queue) { client.queue 'metadata' }

      after(:all) { metadata_queue.delete }

      describe 'get from queue' do
        it 'should be Hash' do
          metadata_queue.metadata.should be_an_instance_of Hash
        end

        it 'should be empty' do
          metadata_queue.metadata.should be_empty
        end
      end

      describe 'set' do
        it 'should be a Hash' do
          meta = metadata_queue.set_metadata(:var1 => 'foo', :var2 => 'bar')
          meta.should be_an_instance_of Hash
        end

        it 'should have content var1:foo var2:bar' do
          meta = metadata_queue.metadata
          meta.should include(
            :var1 => 'foo',
            :var2 => 'bar'
          )
        end
      end

      describe 'merge' do
        it 'should be a Hash' do
          metadata_queue.set_metadata(:var3 => 'baz').should be_an_instance_of Hash
        end

        it 'should have content var1:foo var2:bar var3:baz' do
          meta = metadata_queue.metadata
          meta.should include(
            :var1 => 'foo',
            :var2 => 'bar',
            :var3 => 'baz'
          )
        end
      end

      describe 'update' do
        it 'should have content var1:foo var2:bar var3:foobar' do
          metadata_queue.set_metadata(:var3 => 'foobar').should include(
            :var1 => 'foo',
            :var2 => 'bar',
            :var3 => 'foobar'
          )
        end
      end

      describe 'overwrite' do
        it 'should be a Hash' do
          metadata_queue.set_metadata({:var => 'foobar'}, true).should be_an_instance_of Hash
        end

        it 'should only have content var:foobar' do
          meta = metadata_queue.metadata
          meta.should include(
            :var => 'foobar'
          )
          meta.should_not include(
            :var1 => 'foo',
            :var2 => 'bar',
            :var2 => 'baz',
          )
        end
      end
    end
  end

  describe 'messages endpoints' do
    let(:messages_q) { client.queue('messages_q') }
    let(:list) { messages_q.messages }

    after(:all) { messages_q.delete }

    it 'should post single message' do
      m = messages_q.post(:ttl => 300, :body => 'message 1')
      m.should include(:resources)
    end

    it 'should post many messages' do
      messages = [
        { :ttl => 300, :body => 'message 2'}, 
        { :ttl => 300, :body => 'message 3'}, 
        { :ttl => 300, :body => 'message 4'}
      ]
      list = messages_q.post(messages)
      list.should include(:resources)
    end

    describe 'list messages' do
      describe 'with no options' do
        it 'should return Array' do
          list.should be_an_instance_of Array
        end

        it 'should contain Messages' do
          list[0].should be_an_instance_of Marconiclient::Message
        end

        it 'should have 4 messages' do
          list.should have(4).items
        end
      end

      describe 'with options' do
        let(:list_options) { messages_q.messages(options={echo: true, limit: 20}) }

        it 'should return Array' do
          list_options.should be_an_instance_of Array
        end

        it 'should contain Messages' do
          list_options[0].should be_an_instance_of Marconiclient::Message
        end

        it 'should have 4 messages' do
          list_options.should have(4).items
        end
      end
    end

    describe 'get' do
      before(:all) do
        @mlist = Array.new
        @queue = client.queue('my_queue')
        messages = [
          {ttl: 300, body: "message"},
          {ttl: 300, body: "message"},
          {ttl: 300, body: "message"}]
        resources = @queue.post(messages)[:resources]
        resources.each { |r| @mlist << r.split('/')[-1] }
      end

      after(:all) { @queue.delete }

      describe 'single message' do
        it 'should be a Message' do
          m = @queue.message(@mlist[0])
          m.should be_an_instance_of Marconiclient::Message
        end
      end

      describe 'many messages' do
        it 'should be an Array' do
          @queue.messages(messages: @mlist).should be_an_instance_of Array
        end

        it 'should contain 3 Messages' do
          messages = @queue.messages(messages: @mlist)
          messages.should have(3).items
        end
      end

      describe 'delete' do
        it 'a single message' do
          m = @queue.message(@mlist[0])
          m.delete
        end
          
        it 'a set of messages' do
          messages = @queue.messages(messages: @mlist)
          messages.each { |m| m.delete }
        end

        it 'queue should be empty' do
          messages = @queue.messages
          messages.should be_empty
        end
      end
    end
  end
end

