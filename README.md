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
=> [
		#<Mondo::Transaction -7GBP LOWER EAST SIDE DELI   LONDON  EC2A  GBR tx_00008zphrT5MZQoOhLbTur>, 
		#<Mondo::Transaction -5GBP SACAT MARKS & SPENCER  LONDON        GBR tx_00008zqEXy8SiMLdEqVVmT>, 
		#<Mondo::Transaction -31GBP OZONE COFFEE ROASTERS  UNITED KINGDO GBR tx_00008zrYsmW9IVgPz3bUiv>, 
		#<Mondo::Transaction -26GBP LAN TANA               LONDON        GBR tx_00008zru1CYoS6lW6nhpeD>, 
		#<Mondo::Transaction -5GBP PRET A MANGER          LONDON        GBR tx_00008zvemPnUEdNo8attNB>, 
		#<Mondo::Transaction -4GBP EXPRESS OFF LICENSE    LONDON        GBR tx_00008zxnkK6vh3rvN38W6z>, 
		#<Mondo::Transaction -13GBP LOWER EAST SIDE DELI   LONDON  EC2A  GBR tx_00008zy3PP7LTxxiXVEXAn>, 
		#<Mondo::Transaction -6GBP OZONE COFFEE ROASTERS  LONDON        GBR tx_00008zy8VxynHJGWOqY3aD>, 
		#<Mondo::Transaction -28GBP FGW SELF SERVICE       PADDINGTON    GBR tx_00008zyGtoILjhPUwlZli5>, 
		#<Mondo::Transaction -6GBP EXPRESS OFF LICENSE    LONDON        GBR tx_00008zzwuRFvGsQCml15Kj>
]

mondo.transctions(expand: merchant, limit: 3, since: "2015-08-10T23:00:00Z")
=> [
    #<Mondo::Transaction -6GBP OZONE COFFEE ROASTERS  LONDON        GBR tx_00008zy8VxynHJGWOqY3aD>, 
    #<Mondo::Transaction -28GBP FGW SELF SERVICE       PADDINGTON    GBR tx_00008zyGtoILjhPUwlZli5>, 
    #<Mondo::Transaction -6GBP EXPRESS OFF LICENSE    LONDON        GBR tx_00008zzwuRFvGsQCml15Kj>
]
```