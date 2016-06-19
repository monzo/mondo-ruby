require 'spec_helper'

describe Mondo do
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
        client = Mondo::Client.new(token: "token", account_id: "id")
        resp = instance_double(Faraday::Response, body: '', status: 200)
        allow(client.connection).to receive(:run_request).and_return(resp)
        expect(client.api_post("attachment/register", {})).to be_a(Mondo::Response)
      end
    end
  end
end

