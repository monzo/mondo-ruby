require 'spec_helper'

require 'mondo/client'

describe Mondo::Client do
  let(:client) { Mondo::Client.new(token: "token", account_id: "id") }

  describe "#new" do
    it "requires an access_token" do
      expect{
        Mondo::Client.new(token: nil, account_id: "id")
      }.to raise_error(Mondo::ClientError)
    end

    context "if the API endpoint is not specified" do
      it "uses the default Mondo API endpoint" do
        expect(client.api_url).to eq (Mondo::Client::DEFAULT_API_URL)
      end
    end
  end

  describe "#connection" do
    it "returns a Faraday connection object" do
      expect(Faraday).to receive(:new).and_return(true)

      client.connection
    end
  end

  describe "#create_feed_item" do
    let(:feed_item) { instance_double(Mondo::FeedItem, save: true) }

    before do
      allow(Mondo::FeedItem).to receive(:new).and_return(feed_item)
    end

    it "creates a new FeedItem" do
      expect(Mondo::FeedItem).to receive(:new).with({param: "hi"}, client).
        and_return(feed_item)
      expect(feed_item).to receive(:save)

      client.create_feed_item({param: "hi"})
    end
  end

  describe "#ping" do
    let(:response) { instance_double(Mondo::Response,
      parsed: {"ping" => "pong!"}
    ) }

    it "makes a request to /ping" do
      expect(client).to receive(:api_request).with(:get, "/ping").
      and_return(response)

      client.ping
    end

    it "returns the value of response key 'ping'" do
      allow(client).to receive(:api_request).with(:get, "/ping").
        and_return(response)

      expect(client.ping).to eq "pong!"
    end
  end
end
