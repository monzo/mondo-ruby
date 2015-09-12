# Mondo Ruby Client

The Mondo Ruby client provides a simple Ruby interface to the Mondo API.

API documentation, usage guides, and setup information can be found at [getmondo.co.uk/docs](https://getmondo.co.uk/docs/).

## Initialize your client

```ruby
mondo = Mondo::Client.new(token: YOUR_TOKEN)
```

## Ping

```ruby
mondo.api_get("/ping")

=> #<Faraday::Response @body="{\"ping\":\"pong\"}" @status=200>> 
```

## List Transactions

```ruby
mondo.api_get("/transactions", account_id: YOUR_ACCOUNT_ID)
=> #<Faraday::Response @body="{\"transactions\":[]}" @status=200>
```