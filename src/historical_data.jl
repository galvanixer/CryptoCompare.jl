export get_historical_data, get_exchange_volume, get_symbol_volume, get_symbol_volume_single_exchange
"""
    get_historical_data(duration::String, fsym::String, tsym::String; tryConversion::Bool=true,
                                e::String="all", aggregate::Int=1, aggregatePredictableTimePeriods::Bool=true, 
                                limit::Int=30, allData::Bool=false, toTs::String="", explainPath::Bool=false, extraParams::String="", sign::Bool=false)

Get open, high, low, close, volumefrom and volumeto from the daily/hourly/minutewise historical data. 
The values are based on 00:00 GMT time. 
If e=CCCAGG and tryConversion=true, it attempts conversion through BTC or ETH to determine the best possible path. 
The conversion type and symbol used are appended per historical point. 
If you want to get all the available historical data, you can use limit=2000 and keep going back in time using the toTs param. 
You can then keep requesting batches using: &limit=2000&toTs={the earliest timestamp received}.

1. tryConversion: If set to false, it will try to get only direct trading values. This parameter is only valid for e=CCCAGG value [ Default - true]
2. fsym [Required]: The cryptocurrency symbol of interest [ Min length - 1] [ Max length - 30]
3. tsym [Required]: The currency symbol to convert into [ Min length - 1] [ Max length - 30]
4. e: The exchange to obtain data from [ Min length - 2] [ Max length - 30] [ Default - CCCAGG]
5. aggregate: Time period to aggregate the data over (for daily it's days, for hourly it's hours and for minute histo it's minutes) [ Min - 1] [ Max - 30] [ Default - 1]
6. aggregatePredictableTimePeriods: Only used when the aggregate param is also in use. If false it will aggregate based on the current time.If the param is false and the time you make the call is 1pm - 2pm, with aggregate 2, it will create the time slots: ... 9am, 11am, 1pm.If the param is false and the time you make the call is 2pm - 3pm, with aggregate 2, it will create the time slots: ... 10am, 12am, 2pm.If the param is true (default) and the time you make the call is 1pm - 2pm, with aggregate 2, it will create the time slots: ... 8am, 10am, 12pm.If the param is true (default) and the time you make the call is 2pm - 3pm, with aggregate 2, it will create the time slots: ... 10am, 12am, 2pm. [ Default - true]
7. limit: The number of data points to return. If limit * aggregate > 2000 we reduce the limit param on our side. So a limit of 1000 and an aggerate of 4 would only return 2000 (max points) / 4 (aggregation size) = 500 total points + current one so 501. [ Min - 1] [ Max - 2000] [ Default - 30]
8. allData: Returns all data (only available on histo day) [ Default - false]
9. toTs: Returns historical data before that timestamp. If you want to get all the available historical data, you can use limit=2000 and keep going back in time using the toTs param. You can then keep requesting batches using: &limit=2000&toTs={the earliest timestamp received}
10. explainPath: If set to true, each point calculated will return the available options it used to make the calculation path decision. This is intended for calculation verification purposes, please note that manually recalculating the returned data point values from this data may not match exactly, this is due to levels of caching in some circumstances. [ Default - false]
11. extraParams: The name of your application (we recommend you send it) [ Min length - 1] [ Max length - 2000] [ Default - NotAvailable]
12. sign: If set to true, the server will sign the requests (by default we don't sign them), this is useful for usage in smart contracts [ Default - false]
"""
function get_historical_data(duration::String, fsym::String, tsym::String; tryConversion::Bool=true,
                                e::String="all", aggregate::Int=1, aggregatePredictableTimePeriods::Bool=true, 
                                limit::Int=30, allData::Bool=false, toTs::String="", explainPath::Bool=false, extraParams::String="", sign::Bool=false)
    if duration in ["day", "minute", "hour"]
        url = build_historical_data_url(duration, fsym=fsym, tsym=tsym, e=e, tryConversion=tryConversion, 
                          aggregate=aggregate, aggregatePredictableTimePeriods=aggregatePredictableTimePeriods, 
                          limit=limit, allData=allData, toTs=toTs, explainPath=explainPath, extraParams=extraParams, sign=sign)
    # RAISE ERROR...
    end 

    try
        str = make_API_call(url)
        jobj = JSON.Parser.parse(str)
        if jobj["Response"] == "Success"
            datadict = jobj["Data"]["Data"]
            df = DataFrame(time=Int[], datetime=Dates.DateTime[], open=Float64[], close=Float64[], high=Float64[], low=Float64[], volumefrom=Float64[], volumeto=Float64[])
        
            nrows = size(datadict)[1]
            for i in 1:nrows 
                push!(df, datadict[i], cols=:union)
            end 
            df[:,:datetime] = unix2datetime.(df[:,:time])
            return df
        end
    catch e
        return e
    end
end 

"""
    get_exchange_volume(duration::String, tsym::String; e::String="all", aggregate::Int=1, aggregatePredictableTimePeriods::Bool=true, limit::Int=30,toTs::String="", extraParams::String="", sign::Bool=false)

Get total volume from the daily historical exchange data. The values are based on 00:00 GMT time. We store the data in BTC and we multiply by the BTC-tsym value. If you want to get all the available historical data, you can use limit=2000 and keep going back in time using the toTs param. You can then keep requesting batches using: &limit=2000&toTs={the earliest timestamp received}.

1. tsym [Required]: The currency symbol to convert into [ Min length - 1] [ Max length - 30]
2. e: The exchange to obtain data from [ Min length - 2] [ Max length - 30] [ Default - CCCAGG]
3. aggregate: Time period to aggregate the data over (for daily it's days, for hourly it's hours and for minute histo it's minutes) [ Min - 1] [ Max - 30] [ Default - 1]
4. aggregatePredictableTimePeriods: Only used when the aggregate param is also in use. If false it will aggregate based on the current time.If the param is false and the time you make the call is 1pm - 2pm, with aggregate 2, it will create the time slots: ... 9am, 11am, 1pm.If the param is false and the time you make the call is 2pm - 3pm, with aggregate 2, it will create the time slots: ... 10am, 12am, 2pm.If the param is true (default) and the time you make the call is 1pm - 2pm, with aggregate 2, it will create the time slots: ... 8am, 10am, 12pm.If the param is true (default) and the time you make the call is 2pm - 3pm, with aggregate 2, it will create the time slots: ... 10am, 12am, 2pm. [ Default - true]
5. limit: The number of data points to return. If limit * aggregate > 2000 we reduce the limit param on our side. So a limit of 1000 and an aggerate of 4 would only return 2000 (max points) / 4 (aggregation size) = 500 total points + current one so 501. [ Min - 1] [ Max - 2000] [ Default - 30]
6. toTs: Returns historical data before that timestamp. If you want to get all the available historical data, you can use limit=2000 and keep going back in time using the toTs param. You can then keep requesting batches using: &limit=2000&toTs={the earliest timestamp received}
7. extraParams: The name of your application (we recommend you send it) [ Min length - 1] [ Max length - 2000] [ Default - NotAvailable]
8. sign: If set to true, the server will sign the requests (by default we don't sign them), this is useful for usage in smart contracts [ Default - false]
"""
function get_exchange_volume(duration::String, tsym::String; e::String="all", aggregate::Int=1, aggregatePredictableTimePeriods::Bool=true, limit::Int=30,
                             toTs::String="", extraParams::String="", sign::Bool=false)
    if duration in ["day", "hour"]
        url = build_exchange_vol_url(duration, tsym=tsym, e=e,
                            aggregate=aggregate, aggregatePredictableTimePeriods=aggregatePredictableTimePeriods, 
                            limit=limit, toTs=toTs, extraParams=extraParams, sign=sign)
    # RAISE ERROR...
    end 

    try
        str = make_API_call(url)
        jobj = JSON.Parser.parse(str)
        datadict = jobj["Data"]
        df = DataFrame(time=Int[], datetime=Dates.DateTime[], volume=Float64[])
    
        nrows = size(datadict)[1]
        for i in 1:nrows 
            push!(df, datadict[i], cols=:union)
        end 
        df[:,:datetime] = unix2datetime.(df[:,:time])
        return df
    catch e
        return e
    end
end


"""
    get_symbol_volume(duration::String, fsym::String, tsym::String; aggregate::Int=1, limit::Int=30, toTs::String="", extraParams::String="", sign::Bool=false)

Get total volumes from the daily historical symbol volume data. The volumes are stored in fsym (base) and are converted using the matching historical fsym - tsym conversion rates. For example if you are asking for the fsym BTC and tsym USD, the volume returned is the total BTC that was part of all trades (base and quote) converted using the BTC-USD exchange rate
The value is based on 00:00 GMT time and is calculated as the sum of all trades where the symbol/asset was involved either as the from/base or as the to/quote/counter. The top_tier_volume_quote and base are totals based on exchanges included in our exchange benchmark that are ranked as AA, A or B. cccagg_volume_quote and _base are based on the exchanges included in our CCCAGG average. total_volume_quote and _base are the sum of all trades across all markets where the asset/coin was either the fsym/base or the tsym/quote/counter
If you want to get all the available historical data, you can use limit=2000 and keep going back in time using the toTs param. You can then keep requesting batches using: &limit=2000&toTs={the earliest timestamp received}.

1. fsym [Required]: The cryptocurrency symbol of interest [ Min length - 1] [ Max length - 30]
2. tsym [Required]: The currency symbol to convert into [ Min length - 1] [ Max length - 30]
3. aggregate: Time period to aggregate the data over (for daily it's days, for hourly it's hours and for minute histo it's minutes) [ Min - 1] [ Max - 30] [ Default - 1]
4. limit: The number of data points to return. If limit * aggregate > 2000 we reduce the limit param on our side. So a limit of 1000 and an aggerate of 4 would only return 2000 (max points) / 4 (aggregation size) = 500 total points + current one so 501. [ Min - 1] [ Max - 2000] [ Default - 30]
5. toTs: Returns historical data before that timestamp. If you want to get all the available historical data, you can use limit=2000 and keep going back in time using the toTs param. You can then keep requesting batches using: &limit=2000&toTs={the earliest timestamp received}
6. extraParams: The name of your application (we recommend you send it) [ Min length - 1] [ Max length - 2000] [ Default - NotAvailable]
7. sign: If set to true, the server will sign the requests (by default we don't sign them), this is useful for usage in smart contracts [ Default - false]
"""
function get_symbol_volume(duration::String, fsym::String, tsym::String; aggregate::Int=1, limit::Int=30,
                             toTs::String="", extraParams::String="", sign::Bool=false)
    if duration in ["day", "hour"]
        url = build_symbol_vol_url(duration, fsym=fsym, tsym=tsym,
                            aggregate=aggregate,
                            limit=limit, toTs=toTs, extraParams=extraParams, sign=sign)
    # RAISE ERROR...
    end 

    try
        str = make_API_call(url)
        jobj = JSON.Parser.parse(str)
        datadict = jobj["Data"]
        df = DataFrame()
    
        nrows = size(datadict)[1]
        for i in 1:nrows 
            push!(df, datadict[i], cols=:union)
        end 
        df[:,:datetime] = unix2datetime.(df[:,:time])
        return df
    catch e
        return e
    end
end

"""
    get_symbol_volume_single_exchange(duration::String, fsym::String, tsym::String; e::String="all", aggregate::Int=1, limit::Int=30, toTs::String="", extraParams::String="", sign::Bool=false)
Get the daily from and to volume for a symbol on an exchange.
The value is based on 00:00 GMT time and is calculated as the sum of all trades where the symbol/asset was involved either as the from/base or as the to/quote/counter on the requested exchange.
If you want to get all the available historical data, you can use limit=2000 and keep going back in time using the toTs param. You can then keep requesting batches using: &limit=2000&toTs={the earliest timestamp received}.

1. fsym [Required]: The cryptocurrency symbol of interest [ Min length - 1] [ Max length - 30]
2. tsym [Required]: The currency symbol to convert into [ Min length - 1] [ Max length - 30]
3. e: The exchange to obtain data from [ Min length - 2] [ Max length - 30] [ Default - CCCAGG]
4. aggregate: Time period to aggregate the data over (for daily it's days, for hourly it's hours and for minute histo it's minutes) [ Min - 1] [ Max - 30] [ Default - 1]
5. limit: The number of data points to return. If limit * aggregate > 2000 we reduce the limit param on our side. So a limit of 1000 and an aggerate of 4 would only return 2000 (max points) / 4 (aggregation size) = 500 total points + current one so 501. [ Min - 1] [ Max - 2000] [ Default - 168]
6. toTs: Returns historical data before that timestamp. If you want to get all the available historical data, you can use limit=2000 and keep going back in time using the toTs param. You can then keep requesting batches using: &limit=2000&toTs={the earliest timestamp received}
7. extraParams: The name of your application (we recommend you send it) [ Min length - 1] [ Max length - 2000] [ Default - NotAvailable]
8. sign: If set to true, the server will sign the requests (by default we don't sign them), this is useful for usage in smart contracts [ Default - false]
"""
function get_symbol_volume_single_exchange(duration::String, fsym::String, tsym::String; e::String="all", aggregate::Int=1, limit::Int=30, toTs::String="", extraParams::String="", sign::Bool=false)
    if duration in ["day", "hour"]
        url = build_symbol_vol_single_exchange_url(duration, fsym=fsym, tsym=tsym, e=e,
                            aggregate=aggregate,
                            limit=limit, toTs=toTs, extraParams=extraParams, sign=sign)
    # RAISE ERROR...
    end 

    try
        str = make_API_call(url)
        jobj = JSON.Parser.parse(str)
        datadict = jobj["Data"]
        df = DataFrame()
    
        nrows = size(datadict)[1]
        for i in 1:nrows 
            push!(df, datadict[i], cols=:union)
        end 
        df[:,:datetime] = unix2datetime.(df[:,:time])
        return df
    catch e
        return e
    end
end