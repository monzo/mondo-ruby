require 'spec_helper'
require 'mondo/client'

describe Mondo::Client do

  let(:client) { Mondo::Client.new(token: 'token', account_id: 'acc_123') }

  describe '.new' do
    it 'raises an error without an access_token' do
      expect { Mondo::Client.new(token: nil, account_id: 'acc_123') }.to raise_error(Mondo::ClientError)
    end

    context 'if the API endpoint is not specified' do
      it 'uses the default Mondo API endpoint' do
        expect(client.api_url).to eq (Mondo::Client::DEFAULT_API_URL)
      end
    end

    context 'if account_id is not specified' do
      it 'uses the account_id from the first account' do
        account = instance_double(Mondo::Account, id: '123')
        allow_any_instance_of(Mondo::Client).to receive(:accounts).and_return([account])
        client = Mondo::Client.new(token: 'token')
        expect(client.account_id).to eq(account.id)
      end
    end
  end

  describe '#accounts' do
    let(:response) { instance_double(Mondo::Response, parsed: {'accounts' => [{id: 'acc_123'}]}, error: false) }

    it 'makes a request to /accounts' do
      expect(client).to receive(:request).with(:get, '/accounts', params: {}).and_return(response)
      client.accounts
    end

    it 'returns [Mondo::Account]' do
      allow(client).to receive(:request).and_return(response)
      expect(client.accounts.first).to be_a(Mondo::Account)
      expect(client.accounts.first.id).to eq('acc_123')
    end
  end

  describe '#balance' do
    let(:response) { instance_double(Mondo::Response, parsed: {'balance' => '12345', 'currency' => 'gbp', 'spent_today' => '9900'}, error: false) }

    it 'makes a request to /balance' do
      # TODO: request should be to /balance not 'balance'
      expect(client).to receive(:request).with(:get, 'balance', params: {account_id: 'acc_123'}).and_return(response)
      client.balance
    end

    it 'returns a Mondo::Balance' do
      allow(client).to receive(:request).and_return(response)
      expect(client.balance).to be_a(Mondo::Balance)
      expect(client.balance.balance).to eq(Money.new(12345, :gbp))
      expect(client.balance.currency).to eq(Money::Currency.new(:gbp))
      expect(client.balance.spent_today).to eq(Money.new(9900, :gbp))
    end

    context 'without an account_id' do
      it 'raises a ClientError' do
        allow_any_instance_of(Mondo::Client).to receive(:account_id).and_return(nil)
        allow_any_instance_of(Mondo::Client).to receive(:accounts).and_return([])
        expect { client.balance }.to raise_error(Mondo::ClientError)
      end
    end
  end

  describe '#cards' do
    let(:response) { instance_double(Mondo::Response, parsed: {'cards' => [{id: 'card_123'}]}, error: false) }

    it 'makes a request to /cards' do
      expect(client).to receive(:request).with(:get, '/card/list', params: {account_id: 'acc_123'}).and_return(response)
      client.cards
    end

    it 'returns a [Mondo::Card]' do
      allow(client).to receive(:request).and_return(response)
      expect(client.cards.first).to be_a(Mondo::Card)
      expect(client.cards.first.id).to eq('card_123')
    end

    context 'without an account_id' do
      it 'raises a ClientError' do
        allow_any_instance_of(Mondo::Client).to receive(:account_id).and_return(nil)
        allow_any_instance_of(Mondo::Client).to receive(:accounts).and_return([])
        expect { client.cards }.to raise_error(Mondo::ClientError)
      end
    end
  end

  describe '#connection' do
    let(:connection) { instance_double(Faraday::Connection) }

    it 'returns a Faraday connection object' do
      expect(Faraday).to receive(:new).and_return(connection)
      expect(client.connection).to eq(connection)
    end
  end

  describe '#create_feed_item' do
    let(:feed_item) { instance_double(Mondo::FeedItem, save: true) }

    before do
      allow(Mondo::FeedItem).to receive(:new).and_return(feed_item)
    end

    it 'creates a new FeedItem' do
      expect(Mondo::FeedItem).to receive(:new).with({param: 'hi'}, client).and_return(feed_item)
      expect(feed_item).to receive(:save)
      client.create_feed_item({param: 'hi'})
    end
  end

  describe '#ping' do
    let(:response) { instance_double(Mondo::Response, parsed: {'ping' => 'pong!'}) }

    it 'makes a request to /ping' do
      expect(client).to receive(:request).with(:get, '/ping', {}).and_return(response)
      client.ping
    end

    it 'returns pong' do
      allow(client).to receive(:request).with(:get, '/ping', {}).and_return(response)
      expect(client.ping).to eq 'pong!'
    end
  end

  describe '#request' do
    context 'without options' do
    end

    context 'with options' do
      it 'returns a Mondo::Response' do
        response = instance_double(Faraday::Response, body: '', status: 200)
        allow(client.connection).to receive(:run_request).and_return(response)
        expect(client.request(:post, 'attachment/register', {data: 'data'})).to be_a(Mondo::Response)
      end
    end
  end

  describe '#transaction' do
    let(:response) { instance_double(Mondo::Response, parsed: {'transaction' => {id: 'tx_123'}}, error: false) }

    it 'makes a request to /transactions/:transaction_id' do
      expect(client).to receive(:request).with(:get, '/transactions/tx_123', params: {}).and_return(response)
      client.transaction('tx_123')
    end

    it 'returns a Mondo::Transaction' do
      allow(client).to receive(:request).and_return(response)
      expect(client.transaction('tx_123')).to be_a(Mondo::Transaction)
      expect(client.transaction('tx_123').id).to eq('tx_123')
    end

    context 'without a transaction_id' do
      it 'raises a ClientError' do
        expect { client.transaction(nil) }.to raise_error(Mondo::ClientError)
      end
    end
  end

  describe '#transactions' do
    let(:response) { instance_double(Mondo::Response, parsed: {'transactions' => [{id: 'tx_123'}]}, error: false) }

    it 'makes a request to /transactions' do
      expect(client).to receive(:request).with(:get, '/transactions', params: {account_id: 'acc_123'}).and_return(response)
      client.transactions
    end

    it 'returns a [Mondo::Transaction]' do
      allow(client).to receive(:request).and_return(response)
      expect(client.transactions.first).to be_a(Mondo::Transaction)
      expect(client.transactions.first.id).to eq('tx_123')
    end

    context 'without an account_id' do
      it 'raises a ClientError' do
        allow_any_instance_of(Mondo::Client).to receive(:account_id).and_return(nil)
        allow_any_instance_of(Mondo::Client).to receive(:accounts).and_return([])
        expect { client.transactions }.to raise_error(Mondo::ClientError)
      end
    end
  end

  describe 'hooks' do
    let(:get_response) { instance_double(Mondo::Response, parsed: {'webhooks' => [{id: 'webhook_123', url: 'http://example.com/callback'}]}, error: false) }
    let(:post_response) { instance_double(Mondo::Response, parsed: {}) }

    describe '#web_hooks' do
      it 'makes a request to /webhooks' do

        # TODO: request should be to /webhooks not 'webhooks'
        expect(client).to receive(:request).with(:get, 'webhooks', params: {account_id: 'acc_123'}).and_return(get_response)
        client.web_hooks
      end

      it 'returns a [Mondo::WebHook]' do
        allow(client).to receive(:request).and_return(get_response)
        expect(client.web_hooks.first).to be_a(Mondo::WebHook)
        expect(client.web_hooks.first.id).to eq('webhook_123')
        expect(client.web_hooks.first.url).to eq('http://example.com/callback')
      end

      context 'without an account_id' do
        it 'raises a ClientError' do
          allow_any_instance_of(Mondo::Client).to receive(:account_id).and_return(nil)
          allow_any_instance_of(Mondo::Client).to receive(:accounts).and_return([])
          expect { client.web_hooks }.to raise_error(Mondo::ClientError)
        end
      end
    end

    describe '#register_web_hook' do
      let(:callback_url) { 'http://example.com/callback' }

      it 'makes 1 POST & 1 GET requests to /webhooks' do

        # TODO: request should be to /webhooks not 'webhooks'
        expect(client).to receive(:request).with(:get, 'webhooks', params: {account_id: 'acc_123'}).and_return(get_response).once
        expect(client).to receive(:request).with(:post, 'webhooks', data: {account_id: 'acc_123', url: callback_url}).and_return(post_response).once

        client.register_web_hook(callback_url)
      end

      it 'returns a [Mondo::WebHook] containing the new hook' do

        # TODO: again... request should be to /webhooks not 'webhooks'
        allow(client).to receive(:request).with(:get, 'webhooks', params: {account_id: 'acc_123'}).and_return(get_response).once
        allow(client).to receive(:request).with(:post, 'webhooks', data: {account_id: 'acc_123', url: callback_url}).and_return(post_response).once

        webhooks = client.register_web_hook(callback_url)
        expect(webhooks).to be_a(Array)
        expect(webhooks.last).to be_a(Mondo::WebHook)
      end

      it 'should probably return the newly created WebHook, not an array of webhooks as spec\'d above'
      #
      # webhook = client.register_web_hook(callback_url)
      # expect(webhook.id).to eq('webhook_123')
      # expect(webhook.url).to eq('http://example.com/callback')
      #
      # currently, register_web_hook posts the request, but does not update the local instance with
      # the response, but it does request a complete list of the web_hooks and then inserts the
      # current instance into that array. The returning value is an array similar to this:
      # [<WebHook id: 'webhook_123' account: 'acc_123' url: 'http://example.com/callback'>, <WebHook id: nil account: 'acc_123' url: 'http://example.com/callback'>]
      #
      # This is not what we would want anyway, as the second WebHook is a duplicate, just without the id.
      #
      # what should probably happen is:
      #
      # register_web_hook(callback_url) => #<WebHook id:'webhook_123' account: 'acc_123', url: 'http://example.com/callback'>
      #
      # and then the user can explicitly call:
      #
      # client.web_hooks => [#<WebHook ..>]
      #
      # or to maintain it's current functionality, but fix the duplicated webhook
      # instead of (line 160 of client.rb)
      #
      # web_hooks << hook
      #
      # it should just be
      #
      # web_hooks
      #

      context 'without an account_id' do
        it 'raises a ClientError' do
          allow_any_instance_of(Mondo::Client).to receive(:account_id).and_return(nil)
          allow_any_instance_of(Mondo::Client).to receive(:accounts).and_return([])
          expect { client.register_web_hook('http://example.com/callback') }.to raise_error(Mondo::ClientError)
        end
      end
    end
  end
end
