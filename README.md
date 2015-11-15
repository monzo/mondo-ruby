# Mondo Ruby Client

The Mondo Ruby client provides a simple Ruby interface to the Mondo API.

API documentation, usage guides, and setup information can be found at [getmondo.co.uk/docs](https://getmondo.co.uk/docs/).

## Initialize your client

```ruby
mondo = Mondo::Client.new(
  token: YOUR_TOKEN,
  account_id: YOUR_ACCOUNT_ID # recommended, but optional. If not set, the client will fetch it from the API
)
```

## Configure a different API URL
```ruby
mondo.api_url = "https://otherurl.com"
```

## Ping

Check your client is configured correctly

```ruby
mondo.ping
=> "pong"
```

## Get Balance

```ruby
mondo.balance

=> {"balance"=>-7708, "currency"=>"GBP", "spend_today"=>-12708} 
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
  etc...
]

mondo.transactions(expand: [:merchant], limit: 2, since: "2015-08-10T23:00:00Z")
=> [
  #<Mondo::Transaction -6GBP OZONE COFFEE ROASTERS  LONDON        GBR tx_00008zy8VxynHJGWOqY3aD>,
  #<Mondo::Transaction -28GBP FGW SELF SERVICE       PADDINGTON    GBR tx_00008zyGtoILjhPUwlZli5>,
]

# Fetch a single transaction
mondo.transaction(tx_00008zvemPnUEdNo8attNB)
=> #<Mondo::Transaction -5GBP PRET A MANGER          LONDON        GBR tx_00008zvemPnUEdNo8attNB>


# TODO - make a Merchant object
mondo.transactions.last.merchant
=>
#<Mondo::Merchant merch_000090ER75UzBxejYTIb4r {"id"=>"merch_000090ER75UzBxejYTIb4r", "group_id"=>"grp_00008yEdfHhvbwnQcsYryL", "created"=>"2015-09-19T09:42:16Z", "name"=>"Department Of Coffee And Social Affairs", "logo"=>"http://avatars.io/twitter/deptofcoffee/?size=large", "address"=>{"address"=>"14-16 Leather Ln", "city"=>"London", "region"=>"Greater London", "country"=>"GB", "postcode"=>"EC1N 7SU", "latitude"=>51.519348553897686, "longitude"=>-0.1090317964553833}}> 
```

## Update Transaction Tags

```ruby
tx = mondo.transactions.first

# You can store deeply-nested key-value data on metadata. All values are stored & returned as strings.
tx.metadata[:tags] += "#expenses" # tag this "expenses"

tx.save_metadata
=> true
```


## Add an attachment to a transaction

```ruby
tx = mondo.transactions.first

tx.register_attachment(
  file_url: "https://example.com/nyannyan.jpg", 
  file_type: "image/jpg"
)

=> [#<Mondo::Attachment {"id"=>"attach_00009253YR2h9Besgp6aLR", "url"=>"https://example.com/nyannyan.jpg", "type"=>"image/jpg", "created"=>"2015-11-13T16:50:05Z"}>]

# And remove it again
tx.attachments.first.deregsiter
```


## Webhooks

```ruby
# register a new web-hook
mondo.register_web_hook("http://google.com")

=> [#<Mondo::WebHook {"id"=>"webhook_00009258bk4RMBeR4niFFp", "account_id"=>"acc_000091N8nkeAUWHJjR9k9J", "url"=>"http://google.com"}>]

# list webhooks
mondo.web_hooks

=> [#<Mondo::WebHook {"id"=>"webhook_00009258bk4RMBeR4niFFp", "account_id"=>"acc_000091N8nkeAUWHJjR9k9J", "url"=>"http://google.com"}>]

# and remove it

mondo.web_hooks.first.delete

```

## Feed Items

```ruby
# Create a new feed item

mondo.create_feed_item(
  title: "Foo", 
  image_url: "https://www.example.com/img.jpg", # small icon shown in the feed
  url: "https://www.example.com", # when feed item is clicked, show this page in a webview
)


```
