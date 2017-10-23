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
        lastLetter = spreadClass.substr(spreadClass.length - 1)
        if lastLetter == 'd'
          $("." + spreadClass).html (parseFloat((data[htmlClasses[index]])) - parseFloat((data[htmlClasses[index + 1]]))).toFixed(2)
        else
          $("." + spreadClass).html (((parseFloat((data[htmlClasses[index-1]])) / parseFloat((data[htmlClasses[index]])))-1)*100).toFixed(2) + "%"
      )

    $('.fx_mxn_usd').html data['fx_mxn_usd']

    calculate = (array) ->
      array.map((innerArray) ->
        $(innerArray[0]).html (((parseFloat((data[innerArray[1]])) / parseFloat((data[innerArray[2]])))-1)*100).toFixed(2) + '%'
      )

    calculate([['.volabit_bitso_sell_diff', 'volabit_sell_btc_mxn', 'bitso_sell_btc_mxn'],
                ['.volabit_bitso_buy_diff', 'volabit_buy_btc_mxn', 'bitso_buy_btc_mxn'],
                ['.bitso_bitstamp_sell_diff', 'bitso_sell_btc_mxn', 'bitstamp_sell_btc_mxn'],
                ['.bitso_bitstamp_buy_diff', 'bitso_buy_btc_mxn', 'bitstamp_buy_btc_mxn']])

    console.log 'New Data Received'            
    $('body').append("<div> New Data Received -> Updating </div>")
