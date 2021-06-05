# CryptoCompare

[![Build Status](https://travis-ci.com/galvanixer/CryptoCompare.jl.svg?branch=master)](https://travis-ci.com/galvanixer/CryptoCompare.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/galvanixer/CryptoCompare.jl?svg=true)](https://ci.appveyor.com/project/galvanixer/CryptoCompare-jl)
[![Codecov](https://codecov.io/gh/galvanixer/CryptoCompare.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/galvanixer/CryptoCompare.jl)
[![Coveralls](https://coveralls.io/repos/github/galvanixer/CryptoCompare.jl/badge.svg?branch=master)](https://coveralls.io/github/galvanixer/CryptoCompare.jl?branch=master)

This package is a Julia wrapper over [CryptoCompare]( https://min-api.cryptocompare.com/documentation) REST API. This package collects data from CryptoCompare and provides wide range of market data includes cryptocurrency trade data, order book data, blockchain data, social data and historical data. Please visit https://min-api.cryptocompare.com for more details.

## Installation

```julia 
pkg> add https://github.com/galvanixer/CryptoCompare.jl.git
```

## Usage 

1. Price

   - Symbol price: Get the current price of any cryptocurrency in any other currency that you need. If the crypto does not trade directly into the toSymbol requested, BTC will be used for conversion. If the opposite pair trades we invert it (eg.: BTC-XMR)

    ```julia
    julia> using CryptoCompare
    julia> get_symbol_price("BTC", ["USDT", "INR"])
     Dict{String, Any} with 2 entries:
       "INR"  => 2.98e6
       "USDT" => 36707.5
    ```

   - Getting current price for multiple symbols

   ```julia
    julia> get_multisymbol_price(["BTC","ETH"], ["USDT", "INR"])
     Dict{String, Any} with 2 entries:
       "BTC" => Dict{String, Any}("INR"=>2.98e6, "USDT"=>36666.3)
       "ETH" => Dict{String, Any}("INR"=>2.13636e5, "USDT"=>2628.88)
   ```

   - Getting multi symbol full data: Get all the current trading info (price, vol, open, high, low etc) of any list of cryptocurrencies in any other currency that you need. If the crypto does not trade directly into the toSymbol requested, BTC will be used for conversion. This API also returns Display values for all the fields. If the opposite pair trades we invert it (eg.: BTC-XMR)

    ```julia
    julia> get_multisymbol_fulldata(["BTC", "ETH"], ["USDT"])
    Dict{String, Any} with 2 entries:
      "DISPLAY" => Dict{String, Any}("BTC"=>Dict{String, Any}("USDT"=>Dict{String, Any}("VOLUME24HOURTO"=>"₮ 5,831,331,754.2", "CHANGE24HOUR"=>"₮ -1,773.56", "MARKET"=>"CryptoCompare Index", "MKTCAPPENALTY"=>"0 %", "LASTUPDATE"=>"…
      "RAW"     => Dict{String, Any}("BTC"=>Dict{String, Any}("USDT"=>Dict{String, Any}("MARKET"=>"CCCAGG", "CONVERSIONTYPE"=>"direct", "VOLUMEHOURTO"=>2.30396e8, "LASTVOLUME"=>0.053214, "FLAGS"=>"2052", "HIGHDAY"=>39279.7, "PRICE…
    ```

   - Getting custom average: Compute the current trading info (price, vol, open, high, low etc) of the requested pair as a volume weighted average based on the exchanges requested.

   ```julia
   julia> CryptoCompare.get_custom_average("BTC", "USDT", "all")
     Dict{String, Any} with 2 entries:
       "DISPLAY" => Dict{String, Any}("VOLUME24HOURTO"=>"₮ 5,847,445,148.0", "CHANGE24HOUR"=>"₮ -1,708.59", "MARKET"=>"CUSTOMAGG", "LASTUPDATE"=>"Just now", "CH…
       "RAW"     => Dict{String, Any}("VOLUME24HOURTO"=>5.84745e9, "CHANGE24HOUR"=>-1708.59, "MARKET"=>"CUSTOMAGG", "LASTUPDATE"=>1622814938, "CHANGEHOUR"=>0, "…
   ```

2. Historical Data

   - Getting historical data: Get open, high, low, close, volumefrom and volumeto from the daily/hourly/minutewise historical data. 

   ```julia
   julia> get_historical_data("day", "BTC", "USDT")
   31×10 DataFrame
    Row │ time        datetime             open     close    high     low      volumefr ⋯
        │ Int64       DateTime…?           Float64  Float64  Float64  Float64  Float64  ⋯
   ─────┼────────────────────────────────────────────────────────────────────────────────
      1 │ 1620259200  2021-05-06T00:00:00  57435.3  56392.8  58353.2  55233.1       1.1 ⋯
      2 │ 1620345600  2021-05-07T00:00:00  56392.8  57314.7  58624.8  55257.4       1.0
      3 │ 1620432000  2021-05-08T00:00:00  57314.7  58864.0  59492.2  56915.0       1.3
      4 │ 1620518400  2021-05-09T00:00:00  58864.0  58236.9  59220.9  56267.7       1.1
     ⋮  │     ⋮                ⋮              ⋮        ⋮        ⋮        ⋮           ⋮  ⋱
     29 │ 1622678400  2021-06-03T00:00:00  37569.4  39240.5  39473.3  37180.9       1.3 ⋯
     30 │ 1622764800  2021-06-04T00:00:00  39240.5  36837.2  39279.7  35608.0  159415.0
     31 │ 1622851200  2021-06-05T00:00:00  36837.2  37572.9  37833.4  36626.1   30609.5
                                                            4 columns and 24 rows omitted
   ```

   - Getting exchange volume: Get total volume from the daily historical exchange data.

   ```julia
     julia> CryptoCompare.get_exchange_volume("hour", "BTC", e="Kraken")
     31×3 DataFrame
      Row │ time        datetime             volume  
          │ Int64       DateTime…?           Float64 
     ─────┼──────────────────────────────────────────
        1 │ 1622761200  2021-06-03T23:00:00  1034.83
        2 │ 1622764800  2021-06-04T00:00:00  1363.64
        3 │ 1622768400  2021-06-04T01:00:00  4632.93
        4 │ 1622772000  2021-06-04T02:00:00  2346.89
       ⋮  │     ⋮                ⋮              ⋮
       29 │ 1622862000  2021-06-05T03:00:00   763.58
       30 │ 1622865600  2021-06-05T04:00:00   763.88
       31 │ 1622869200  2021-06-05T05:00:00   642.3
                                      24 rows omitted
   ```

   - Getting symbol volume: Get total volumes from the daily historical symbol volume data.

   ```julia
   julia> get_symbol_volume("hour", "BTC", "USDT")
   31×11 DataFrame
    Row │ total_volume_base  time        top_tier_volume_quote  top_tier_volume_base  cccagg_volume_total  t ⋯
        │ Float64            Int64       Float64                Float64               Float64              F ⋯
   ─────┼─────────────────────────────────────────────────────────────────────────────────────────────────────
      1 │         1.2833e9   1622764800              2.65921e8             7.04155e8            6.49584e8    ⋯
      2 │         2.53017e9  1622768400              5.28305e8             1.32781e9            1.38675e9
      3 │         1.52643e9  1622772000              2.66361e8             8.18268e8            7.62417e8
      4 │         1.05322e9  1622775600              1.99479e8             6.00715e8            4.93196e8
     ⋮  │         ⋮              ⋮                 ⋮                     ⋮                     ⋮             ⋱
     29 │         8.98651e8  1622865600              1.45316e8             5.67821e8            3.66997e8    ⋯
     30 │         7.79174e8  1622869200              1.46039e8             5.37131e8            2.88712e8
     31 │         0.0        1622872800              0.0                   0.0                  0.0
                                                                                 6 columns and 24 rows omitted 
   ```

   - Getting symbol volume for a particular exchange: 

   ```julia
   julia> get_symbol_volume_single_exchange("day", "BTC", "USDT", e="Binance")
   31×5 DataFrame
    Row │ volumeto   time        volumetotal  volumefrom  datetime            
        │ Float64    Int64       Float64      Float64     DateTime…           
   ─────┼─────────────────────────────────────────────────────────────────────
      1 │ 8.29609e9  1620259200   1.36606e10   5.36453e9  2021-05-06T00:00:00
      2 │ 8.60901e9  1620345600   1.42683e10   5.65934e9  2021-05-07T00:00:00
      3 │ 6.80027e9  1620432000   1.21696e10   5.36932e9  2021-05-08T00:00:00
      4 │ 7.77634e9  1620518400   1.31006e10   5.32427e9  2021-05-09T00:00:00
     ⋮  │     ⋮          ⋮            ⋮           ⋮                ⋮
     29 │ 2.21379e9  1622678400   6.23544e9    4.02165e9  2021-06-03T00:00:00
     30 │ 2.12543e9  1622764800   6.69061e9    4.56517e9  2021-06-04T00:00:00
     31 │ 3.29027e8  1622851200   9.24713e8    5.95685e8  2021-06-05T00:00:00
                                                               24 rows omitted
   ```

   

3. Blockchain data

   **NOTE**: These functions require an API key which one can get from CryptoCompare.

   - Getting coin list

   ```julia
   julia> CryptoCompare.get_coin_list(api_key=api_key)
   
   809×6 DataFrame
    Row │ id      data_available_from_timestamp  data_available_from  key     symbol  partner_symbol 
        │ Int64   Int64                          Dates.DateTime       String  String  String         
   ─────┼────────────────────────────────────────────────────────────────────────────────────────────
      1 │   5324                     1438905600  2015-08-07T00:00:00  ETC     ETC     ETC
      2 │ 600395                     1516060800  2018-01-16T00:00:00  GENE    GENE    GENE
      3 │ 710156                     1513814400  2017-12-21T00:00:00  AGI     AGI     AGI
      4 │ 392253                     1518825600  2018-02-17T00:00:00  CRDS    CRDS    CS
     ⋮  │   ⋮                   ⋮                         ⋮             ⋮       ⋮           ⋮
    807 │ 202714                     1505865600  2017-09-20T00:00:00  CSNO    CSNO    CSNO
    808 │ 716522                     1515628800  2018-01-11T00:00:00  IOST    IOST    IOST
    809 │ 311829                     1508284800  2017-10-18T00:00:00  DRT     DRT     DRT
   ```

   - Getting latest blockchain data for a coin

   ```julia
   julia> get_coin_latest("BTC", api_key=api_key)
   Dict{String, Any} with 18 entries:
     "hashrate"                => 1.36385e8
     "time"                    => 1622764800
     "difficulty"              => 2.10477e13
     "block_size"              => 1290167
     "current_supply"          => 18726912
     "block_height"            => 686304
     "id"                      => 1182
     "transaction_count"       => 236672
     "symbol"                  => "BTC"
     "new_addresses"           => 416203
     "active_addresses"        => 921892
     ⋮                         => ⋮
   ```

   - Get daily historical block chain data for a coin

   ```julia
   julia> get_historical_daily("BTC", api_key=api_key)
   30×18 DataFrame
    Row │ hashrate   time        difficulty  block_size  current_supply  block_height  id     transaction_co ⋯
        │ Float64    Int64       Float64     Int64       Int64           Int64         Int64  Int64          ⋯
   ─────┼─────────────────────────────────────────────────────────────────────────────────────────────────────
      1 │ 1.74004e8  1620259200  2.06088e13     1361765        18701912        682304   1182             311 ⋯
      2 │ 1.76859e8  1620345600  2.06088e13     1296296        18702987        682476   1182             307
      3 │ 1.75722e8  1620432000  2.06088e13     1310903        18704050        682647   1182             274
      4 │ 1.93208e8  1620518400  2.06088e13     1360895        18705212        682833   1182             247
     ⋮  │     ⋮          ⋮           ⋮           ⋮             ⋮              ⋮          ⋮            ⋮      ⋱
     28 │ 1.75997e8  1622592000  2.10477e13     1291096        18725168        686026   1182             250 ⋯
     29 │ 1.55955e8  1622678400  2.10477e13     1293653        18726087        686173   1182             255
     30 │ 1.36385e8  1622764800  2.10477e13     1290167        18726912        686304   1182             236
                                                                                11 columns and 23 rows omitted
   ```

   - Get the price, the total supply, the hash rate, the block reward and the block time. Based on these values you can calculate the profitability of a mining rig.

   ```julia
   julia> get_mining_calculator_data(["BTC","ETH"],["USDT"], api_key=api_key)
   Dict{String, Any} with 2 entries:
     "BTC" => Dict{String, Any}("Price"=>Dict{String, Any}("USDT"=>37775.8), "CoinInfo"=>Dict{String, Any}("NetHashesPerSecond"=>-2003397897726812928, "BlockR…
     "ETH" => Dict{String, Any}("Price"=>Dict{String, Any}("USDT"=>2799.37), "CoinInfo"=>Dict{String, Any}("NetHashesPerSecond"=>6.2186e14, "BlockReward"=>2.3…
   ```

4. News

   - Get the latest/popular news from CryptoCompare API.
   
     ```julia
     julia> df = get_latest_news(sortOrder="popular")
     50×14 DataFrame
      Row │ imageurl                           id        guid                              
          │ String                             Any       String                            
     ─────┼─────────────────────────────────────────────────────────────────────────────────────────────────────────
        1 │ https://images.cryptocompare.com…  26986446  https://cryptoslate.com/?p=192077
        2 │ https://images.cryptocompare.com…  26986253  https://cryptopotato.com/?p=1221…
        3 │ https://images.cryptocompare.com…  26986191  https://www.newsbtc.com/?p=464997
        4 │ https://images.cryptocompare.com…  26986014  https://cryptopotato.com/?p=1220…
       ⋮  │                 ⋮                     ⋮                      ⋮                  ⋮  ⋮  ⋮  ⋮  ⋮  ⋮  ⋮  ⋮  ⋮  ⋮  ⋮
       48 │ https://images.cryptocompare.com…  26986515  https://coinnounce.com/?p=26565
       49 │ https://images.cryptocompare.com…  26986514  https://www.newsbtc.com/?p=465037
       50 │ https://images.cryptocompare.com…  26986513  https://news.bitcoin.com/?p=4637…
                                                                                              11 columns and 43 rows omitted
     ```
   
   - Get the list of feeds from CryptoCompare API.
   
     ```julia
     julia> get_news_feeds()
     55×4 DataFrame
      Row │ key               name                   lang    img                               
          │ String            String                 String  String                            
     ─────┼────────────────────────────────────────────────────────────────────────────────────
        1 │ cryptocompare     CryptoCompare          EN      https://images.cryptocompare.com…
        2 │ cryptoglobe       CryptoGlobe            EN      https://images.cryptocompare.com…
        3 │ theblock          TheBlock               EN      https://images.cryptocompare.com…
        4 │ cryptonewsreview  CryptoNewsReview       EN      https://images.cryptocompare.com…
       ⋮  │        ⋮                    ⋮              ⋮                     ⋮
       53 │ okexinsights      OKEx Insights          EN      https://images.cryptocompare.com…
       54 │ blockworks        Blockworks             EN      https://images.cryptocompare.com…
       55 │ coinrepublic      The Coin Republic      EN      https://images.cryptocompare.com…
                                                                                48 rows omitted
     ```
   
   - Get the list of news categories from CryptoCompare API.
   
     ```julia 
     julia> get_news_categories()
     28×4 DataFrame
      Row │ categoryName  excludedPhrases          includedPhrases          wordsAssociatedWithCategory       
          │ String        Vector{Any}?             Vector{Any}?             Vector{Any}                       
     ─────┼───────────────────────────────────────────────────────────────────────────────────────────────────
        1 │ BTC           Any["BITCOIN CASH"]      missing                  Any["BTC", "BITCOIN", "SATOSHI"]
        2 │ BCH           missing                  Any["BITCOIN CASH"]      Any["BCH", "BITCOINCASH"]
        3 │ ETH           Any["ETHEREUM CLASSIC"]  missing                  Any["ETH", "ETHEREUM", "VITALIK"…
        4 │ LTC           missing                  missing                  Any["LTC", "LITECOIN"]
       ⋮  │      ⋮                   ⋮                        ⋮                             ⋮
       26 │ Business      missing                  missing                  Any["BUSINESS", "INVESTOR", "INV…
       27 │ Commodity     missing                  missing                  Any["COMMODITIES", "OIL", "OIL-B…
       28 │ Sponsored     missing                  missing                  Any["SPONSORED", "FEATURED", "PR…
                                                                                               21 rows omitted
     ```
   
   - Gets the list of feeds and categories from CryptoCompare API.
   
     ```julia
     julia> get_news_feeds_and_categories()
     (55×4 DataFrame
      Row │ key               name                   lang    img                               
          │ String            String                 String  String                            
     ─────┼────────────────────────────────────────────────────────────────────────────────────
        1 │ cryptocompare     CryptoCompare          EN      https://images.cryptocompare.com…
        2 │ cryptoglobe       CryptoGlobe            EN      https://images.cryptocompare.com…
        3 │ theblock          TheBlock               EN      https://images.cryptocompare.com…
        4 │ cryptonewsreview  CryptoNewsReview       EN      https://images.cryptocompare.com…
       ⋮  │        ⋮                    ⋮              ⋮                     ⋮
       53 │ okexinsights      OKEx Insights          EN      https://images.cryptocompare.com…
       54 │ blockworks        Blockworks             EN      https://images.cryptocompare.com…
       55 │ coinrepublic      The Coin Republic      EN      https://images.cryptocompare.com…
                                                                                48 rows omitted, 28×4 DataFrame
      Row │ categoryName  excludedPhrases          includedPhrases          wordsAssociatedWithCategory       
          │ String        Vector{Any}?             Vector{Any}?             Vector{Any}                       
     ─────┼───────────────────────────────────────────────────────────────────────────────────────────────────
        1 │ BTC           Any["BITCOIN CASH"]      missing                  Any["BTC", "BITCOIN", "SATOSHI"]
        2 │ BCH           missing                  Any["BITCOIN CASH"]      Any["BCH", "BITCOINCASH"]
        3 │ ETH           Any["ETHEREUM CLASSIC"]  missing                  Any["ETH", "ETHEREUM", "VITALIK"…
        4 │ LTC           missing                  missing                  Any["LTC", "LITECOIN"]
       ⋮  │      ⋮                   ⋮                        ⋮                             ⋮
       26 │ Business      missing                  missing                  Any["BUSINESS", "INVESTOR", "INV…
       27 │ Commodity     missing                  missing                  Any["COMMODITIES", "OIL", "OIL-B…
       28 │ Sponsored     missing                  missing                  Any["SPONSORED", "FEATURED", "PR…
                                                                                               21 rows omitted)
     ```


**TO DO:** 

1. Register package at Julia registry
2. Write unit tests and enable code coverage
