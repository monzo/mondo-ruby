require 'spec_helper'

describe Mondo do
  before do
  end

  describe 'Hash' do
    describe '#to_param' do
      it 'should return params string for a hash' do
        expect({hello: 'world', great: 'day'}.to_param).to eq('great=day&hello=world')
      end
    end
  end

  describe 'Client' do
    describe '#request' do
      it "It should not throw an error when opts param are supplied" do
        FakeWeb.allow_net_connect = false
        FakeWeb.register_uri(:get, 'https://api.getmondo.co.uk/accounts', body: {accounts: {id: 'acc_123', description: 'Mark Watney', created: '2015-11-13T12:17:42Z'}}.to_json, content_type: 'application/javascript')
        FakeWeb.register_uri(:post, 'https://api.getmondo.co.uk/attachment/register', content_type: 'application/javascript')
        client = Mondo::Client.new(token: 'theuserstoken')
        opts = {
          external_id: 'tx_123',
          file_url: 'https://url-to-an-image.com/image.png',
          file_type: 'image/png',
        }
        expect(client.api_post("attachment/register", opts)).to be_a(Mondo::Response)
      end
    end
  end
end

