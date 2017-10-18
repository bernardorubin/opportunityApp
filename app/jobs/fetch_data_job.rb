class FetchDataJob < ApplicationJob
  queue_as :default

  after_perform do |job|
    FetchDataJob.perform_later
  end

  def perform(*args)
    @volabit_ticker = Faraday.get 'https://www.volabit.com/api/v1/tickers'
    @bitso_ticker = Faraday.get 'https://api.bitso.com/v3/ticker/?book=btc_mxn'
    @bitstamp_ticker = Faraday.get 'https://www.bitstamp.net/api/ticker/'

    @parsed_volabit = JSON.parse(@volabit_ticker.body)
    @parsed_bitso = JSON.parse(@bitso_ticker.body)
    @parsed_bitstamp = JSON.parse(@bitstamp_ticker.body)

    @volabit_sell_btc_mxn = @parsed_volabit["btc_mxn_sell"].to_f
    @volabit_buy_btc_mxn = @parsed_volabit["btc_mxn_buy"].to_f

    @bitso_payload = @parsed_bitso["payload"]
    @bitso_sell_btc_mxn = @bitso_payload["ask"].to_f
    @bitso_buy_btc_mxn = @bitso_payload["bid"].to_f

    @bitstamp_sell_btc_usd = @parsed_bitstamp["ask"].to_f
    @bitstamp_buy_btc_usd = @parsed_bitstamp["bid"].to_f

    @data = {}
    @data[:volabit_sell_btc_mxn] = @volabit_sell_btc_mxn
    @data[:volabit_buy_btc_mxn] = @volabit_buy_btc_mxn
    @data[:bitso_sell_btc_mxn] = @bitso_sell_btc_mxn
    @data[:bitso_buy_btc_mxn] = @bitso_buy_btc_mxn
    @data[:bitstamp_sell_btc_usd] = @bitstamp_sell_btc_usd
    @data[:bitstamp_buy_btc_usd] = @bitstamp_buy_btc_usd

    ActionCable.server.broadcast 'data_flow_channel', data: @data
  end
end
