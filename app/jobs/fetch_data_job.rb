class FetchDataJob < ApplicationJob
  queue_as :default

  after_perform do |job|
    FetchDataJob.set(wait: 5.seconds).perform_later
  end

  def perform(*args)
    fetch && calc && ActionCable.server.broadcast('data_flow_channel', data)
  end

  def fetch
    @parsed_volabit = JSON.parse(Faraday.get('https://www.volabit.com/api/v1/tickers').body)
    @parsed_bitso = JSON.parse(Faraday.get('https://api.bitso.com/v3/ticker/?book=btc_mxn').body)["payload"]
    @parsed_bitstamp = JSON.parse(Faraday.get('https://www.bitstamp.net/api/ticker/').body)
    @fx_mxn_usd =  JSON.parse(Faraday.get('http://api.fixer.io/latest?base=USD&symbols=MXN').body)["rates"]["MXN"].to_f
  end

  def calc
    @volabit_sell_btc_mxn = @parsed_volabit["btc_mxn_sell"].to_f
    @volabit_buy_btc_mxn = @parsed_volabit["btc_mxn_buy"].to_f

    @bitso_sell_btc_mxn = @parsed_bitso["ask"].to_f
    @bitso_buy_btc_mxn = @parsed_bitso["bid"].to_f

    @bitstamp_sell_btc_usd = @parsed_bitstamp["ask"].to_f
    @bitstamp_buy_btc_usd = @parsed_bitstamp["bid"].to_f
    @bitstamp_sell_btc_mxn = @bitstamp_sell_btc_usd * @fx_mxn_usd
    @bitstamp_buy_btc_mxn = @bitstamp_buy_btc_usd * @fx_mxn_usd
  end

  def data
    {
      volabit_sell_btc_mxn: @volabit_sell_btc_mxn,
      volabit_buy_btc_mxn: @volabit_buy_btc_mxn,
      bitso_sell_btc_mxn: @bitso_sell_btc_mxn,
      bitso_buy_btc_mxn: @bitso_buy_btc_mxn,
      bitstamp_sell_btc_usd: @bitstamp_sell_btc_usd,
      bitstamp_buy_btc_usd: @bitstamp_buy_btc_usd,
      bitstamp_sell_btc_mxn: @bitstamp_sell_btc_mxn,
      bitstamp_buy_btc_mxn: @bitstamp_buy_btc_mxn,
      fx_mxn_usd: @fx_mxn_usd
    }
  end
end
