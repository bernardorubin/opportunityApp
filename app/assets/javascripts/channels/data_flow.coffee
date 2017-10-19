App.data_flow = App.cable.subscriptions.create "DataFlowChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    htmlClasses = ['volabit_sell_btc_mxn', 'volabit_buy_btc_mxn', 'bitso_sell_btc_mxn',
              'bitso_buy_btc_mxn', 'bitstamp_sell_btc_mxn', 'bitstamp_buy_btc_mxn']

    htmlClasses.map((htmlClass) ->
        currency = htmlClass.substr(htmlClass.length - 3)
        $("." + htmlClass).html data[htmlClass].toFixed(2) + currency.toUpperCase()
      )

    spreadCalculations = ['volabit_spread', 'volabit_spread_percentage', 'bitso_spread',
                          'bitso_spread_percentage', 'bitstamp_spread', 'bitstamp_spread_percentage']

    spreadCalculations.map((spreadClass, index) ->
        console.log index
        lastLetter = spreadClass.substr(spreadClass.length - 1)
        if lastLetter == 'd'
          $("." + spreadClass).html (parseFloat((data[htmlClasses[index]])) - parseFloat((data[htmlClasses[index + 1]]))).toFixed(2)
        else
          $("." + spreadClass).html (((parseFloat((data[htmlClasses[index-1]])) / parseFloat((data[htmlClasses[index]])))-1)*100).toFixed(2) + "%"
      )

    $('.fx_mxn_usd').html data['fx_mxn_usd']

    # TODO: Refactor This
    $('.volabit_bitso_sell_diff').html Math.abs((((parseFloat((data['volabit_sell_btc_mxn'])) / parseFloat((data['bitso_sell_btc_mxn'])))-1)*100)).toFixed(2) + '%'
    $('.volabit_bitso_buy_diff').html Math.abs((((parseFloat((data['volabit_buy_btc_mxn'])) / parseFloat((data['bitso_buy_btc_mxn'])))-1)*100)).toFixed(2) + '%'
    $('.bitso_bitstamp_sell_diff').html Math.abs((((parseFloat((data['bitso_sell_btc_mxn'])) / parseFloat((data['bitstamp_sell_btc_mxn'])))-1)*100)).toFixed(2) + '%'
    $('.bitso_bitstamp_buy_diff').html Math.abs((((parseFloat((data['bitso_buy_btc_mxn'])) / parseFloat((data['bitstamp_buy_btc_mxn'])))-1)*100)).toFixed(2) + '%'

    $('body').append("<div> New Data Received -> Updating </div>")
