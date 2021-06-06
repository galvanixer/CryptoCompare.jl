export get_coin_list, get_coin_latest, get_historical_daily, get_mining_calculator_data

function get_coin_list(; extraParams::String="", sign::Bool=false, api_key::String="")
    url = build_blockchain_data_url("available_coin_list", extraParams=extraParams, sign=sign, api_key=api_key)
    try
        str = make_API_call(url)
        jobj = JSON.Parser.parse(str)

        datadict = jobj["Data"]
        df = DataFrame(id=Int[], data_available_from_timestamp= Int[], data_available_from=DateTime[], key=String[], symbol=String[], partner_symbol=String[], )
    
        for k in keys(datadict)
            value = datadict[k]
            push!(df.id, value["id"])
            push!(df.data_available_from_timestamp, value["data_available_from"])
            push!(df.data_available_from, unix2datetime(value["data_available_from"]))
            push!(df.key, k)
            push!(df.symbol, value["symbol"])
            push!(df.partner_symbol, value["partner_symbol"])
        end 

        return df

    catch e
        return e
    end

end

function get_coin_latest(fsym::String; extraParams::String="", sign::Bool=false, api_key::String="")
    url = build_blockchain_data_url("latest", fsym=fsym, extraParams=extraParams, sign=sign, api_key=api_key)
    try
        str = make_API_call(url)
        jobj = JSON.Parser.parse(str)
        datadict = jobj["Data"]
        return datadict

    catch e
        return e
    end
end

"""
    get_historical_daily(fsym::String; limit::Int=30, toTs::String="", extraParams::String="", sign::String="", api_key::String=api_key)


1. fsym [Required]: The cryptocurrency symbol of interest [ Min length - 1] [ Max length - 10]
2. limit: The number of data points to return. [ Min - 1] [ Max - 2000] [ Default - 30]
3. toTs: Returns historical data before that timestamp. If you want to get all the available historical data, you can use limit=2000 and keep going back in time using the toTs param. You can then keep requesting batches using: &limit=2000&toTs={the earliest timestamp received}
4. extraParams: The name of your application (we recommend you send it) [ Min length - 1] [ Max length - 2000] [ Default - NotAvailable]
5. sign: If set to true, the server will sign the requests (by default we don't sign them), this is useful for usage in smart contracts [ Default - false]
"""
function get_historical_daily(fsym::String; limit::Int=30, toTs::String="", extraParams::String="", sign::String="", api_key::String="")
    url = build_blockchain_data_url("historical_daily", fsym=fsym, limit=limit, toTs=toTs, extraParams=extraParams, sign=sign, api_key=api_key)
    try
        str = make_API_call(url)
        jobj = JSON.Parser.parse(str)
        datadict = jobj["Data"]["Data"]

        df = DataFrame()
        nrows = size(datadict)[1]
        for i in 1:nrows 
            push!(df, datadict[i], cols=:union)
        end 
        df.datetime = unix2datetime.(df.time)
        return df

    catch e
        return e
    end
end

"""
    get_mining_calculator_data(fsyms::Array{String,1}, tsyms::Array{String,1}, extraParams::String, sign::Bool, api_key::String)

    Get the price, the total supply, the hash rate, the block reward and the block time. Based on these values you can calculate the profitability of a mining rig.
1. fsyms [Required]: Comma separated cryptocurrency symbols list [ Min length - 1] [ Max length - 300]
2. tsyms [Required]: Comma separated cryptocurrency symbols list to convert into [ Min length - 1] [ Max length - 100]
3. extraParams: The name of your application (we recommend you send it) [ Min length - 1] [ Max length - 2000] [ Default - NotAvailable]
4. sign: If set to true, the server will sign the requests (by default we don't sign them), this is useful for usage in smart contracts [ Default - false]
"""
function get_mining_calculator_data(fsyms::Array{String,1}, tsyms::Array{String,1}; extraParams::String="", sign::Bool=false, api_key::String)
    url = build_blockchain_data_url("mining_calculator_data", fsyms=fsyms, tsyms=tsyms, extraParams=extraParams, sign=sign, api_key=api_key)
    try
        str = make_API_call(url)
        jobj = JSON.Parser.parse(str)
        datadict = jobj["Data"]
        return datadict

    catch e
        return e
    end
end