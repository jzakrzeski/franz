require 'sinatra/base'
require 'sinatra/json'
require 'kazoo'

module Franz
  extend self

  attr_reader :brokers, :consumer_groups, :topics

  @brokers, @consumer_groups, @topics = [], [], []

  def configure!
    @zookeeper_connect = ENV['ZOOKEEPER_CONNECT']
    @cluster = Kazoo::Cluster.new(@zookeeper_connect)

    @brokers = @cluster.brokers
    @consumer_groups = @cluster.consumergroups
    @topics = @cluster.topics
  end

  class App < Sinatra::Base

    configure do
      Franz.configure!
    end

    helpers do
      def get_brokers_info
        result = {}
        Franz.brokers.each do |id, broker|
          result[id] = {
              :address => broker.addr,
              :leader_for => broker.led_partitions.map { |p| p.key },
              :replica_for => broker.replicated_partitions.map { |p| p.key }
          }
        end
        result
      end
    end

    get '/' do
      json :message => "It's alive!"
    end

    get '/brokers' do
      json get_brokers_info
    end
  end
end