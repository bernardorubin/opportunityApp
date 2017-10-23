class DataFlowChannel < ApplicationCable::Channel
  def subscribed
    stream_from "data_flow_channel"
    # update_prices
  end

  # Solución incompleta Genaro 
  # private
  #
  # def update_prices
  #   fetch_prices
  #   ActionCable.server.broadcast('data_flow_channel', data: data)
  # end
  #
  # def data
  #   {
  #     volabit_buy_btc_mxn: @volabit_ticker['btc_mxn_buy'].to_f,
  #     bitso_buy_btc_mxn: @bitso_ticker['bid'].to_f,
  #     bitstamp_buy_btc_usd: @bitstamp_ticker['bid'].to_f,
  #     usd_mxn: @usd_mxn
  #   }
  # end
  #
  # def fetch_prices
  #   volabit_ticker = Faraday.get('https://www.volabit.com/api/v1/tickers')
  #   bitso_ticker = Faraday.get('https://api.bitso.com/v3/ticker/?book=btc_mxn')
  #   bitstamp_ticker = Faraday.get('https://www.bitstamp.net/api/ticker/')
  #   fixer_io =  Faraday.get('http://api.fixer.io/latest?base=USD&symbols=MXN')
  #
  #   @volabit_ticker = JSON.parse(volabit_ticker.body)
  #   @bitso_ticker = JSON.parse(bitso_ticker.body)['payload']
  #   @bitstamp_ticker = JSON.parse(bitstamp_ticker.body)
  #   @usd_mxn = JSON.parse(fixer_io.body)['rates']['MXN']
  # end

end
