App.data_flow = App.cable.subscriptions.create "DataFlowChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    console.log 'Hello'
    console.log data['data']['bitso_buy_btc_mxn']
    $('.volabit_buy_btc_mxn').html (data['data']['volabit_buy_btc_mxn']) + "MXN"
    $('.volabit_sell_btc_mxn').html (data['data']['volabit_sell_btc_mxn']) + "MXN"
    $('.bitso_buy_btc_mxn').html (data['data']['bitso_buy_btc_mxn']) + "MXN"
    $('.bitso_sell_btc_mxn').html (data['data']['bitso_sell_btc_mxn']) + "MXN"
    $('.bitstamp_buy_btc_usd').html (data['data']['bitstamp_buy_btc_usd']) + "USD"
    $('.bitstamp_sell_btc_usd').html (data['data']['bitstamp_sell_btc_usd']) + "USD"

    $('.volabit_spread').html (parseFloat((data['data']['volabit_sell_btc_mxn'])) - parseFloat((data['data']['volabit_buy_btc_mxn']))).toFixed(2)
    $('.bitso_spread').html (parseFloat((data['data']['bitso_sell_btc_mxn'])) - parseFloat((data['data']['bitso_buy_btc_mxn']))).toFixed(2)
    $('.bitstamp_spread').html (parseFloat((data['data']['bitstamp_sell_btc_usd'])) - parseFloat((data['data']['bitstamp_buy_btc_usd']))).toFixed(2)

    $('.volabit_spread_percentage').html (((parseFloat((data['data']['volabit_sell_btc_mxn'])) / parseFloat((data['data']['volabit_buy_btc_mxn'])))-1)*100).toFixed(2) + "%"
    $('.bitso_spread_percentage').html (((parseFloat((data['data']['bitso_sell_btc_mxn'])) / parseFloat((data['data']['bitso_buy_btc_mxn'])))-1)*100).toFixed(2) + "%"
    $('.bitstamp_spread_percentage').html (((parseFloat((data['data']['bitstamp_sell_btc_usd'])) / parseFloat((data['data']['bitstamp_buy_btc_usd'])))-1)*100).toFixed(2) + "%"


    $('body').append("<div> New Data !</div>")
