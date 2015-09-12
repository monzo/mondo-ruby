# Mondo Ruby Client

The Mondo Ruby client provides a simple Ruby interface to the Mondo API.

API documentation, usage guides, and setup information can be found at [getmondo.co.uk/docs](https://getmondo.co.uk/docs/).

## Initialize your client

```ruby
mondo = Mondo::Client.new(
	token: YOUR_TOKEN,
	account_id: YOUR_ACCOUNT_ID
)
```

## Ping

```ruby
mondo.api_get("/ping")

=> #<Faraday::Response @body="{\"ping\":\"pong\"}" @status=200>> 
```

## List Transactions

```ruby
mondo.transactions
=> [#<Mondo::Transaction 50GBP Top up via Stripe tx_0000900AEVTaaWMkPW8D6v>] 
```