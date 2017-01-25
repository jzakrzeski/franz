require 'sinatra/base'
require 'sinatra/json'
require 'kazoo'

module Franz
  extend self

  attr_reader :cluster

  def configure!
    @zookeeper_connect = ENV['ZOOKEEPER_CONNECT']
    @cluster = Kazoo::Cluster.new(@zookeeper_connect)
  end

  class App < Sinatra::Base

    configure do
      Franz.configure!
    end

    get '/' do
      json :message => "It's alive!"
    end
  end
end