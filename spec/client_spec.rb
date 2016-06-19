require 'spec_helper'

describe Mondo do
  describe 'Client' do
    describe '#request' do
      it "should not throw an error when opts param are supplied" do
        client = Mondo::Client.new(token: "token", account_id: "id")
        resp = instance_double(Faraday::Response, body: '', status: 200)
        allow(client.connection).to receive(:run_request).and_return(resp)
        expect(client.api_post("attachment/register", {})).to be_a(Mondo::Response)
      end
    end
  end
end
