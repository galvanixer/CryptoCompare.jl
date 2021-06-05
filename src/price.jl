export get_symbol_price, get_multisymbol_price, get_multisymbol_data, get_custom_average
"""
    get_symbol_price()

Get the current price of any cryptocurrency in any other currency that you need. If the crypto does not trade directly into the toSymbol requested, BTC will be used for conversion. If the opposite pair trades we invert it (eg.: BTC-XMR)

1. tryConversion: If set to false, it will try to get only direct trading values. This parameter is only valid for e=CCCAGG value [ Default - true]
2. fsym [Required]: The cryptocurrency symbol of interest [ Min length - 1] [ Max length - 30]
3. tsyms [Required]: Comma separated cryptocurrency symbols list to convert into [ Min length - 1] [ Max length - 500]
4. relaxedValidation: Setting this to true will make sure you don't get an error on non trading pairs, they will just be filtered out of the response. [ Default - true]
5. e: The exchange to obtain data from [ Min length - 2] [ Max length - 30] [ Default - cccagg_or_exchange]
6. extraParams: The name of your application (we recommend you send it) [ Min length - 1] [ Max length - 2000] [ Default - NotAvailable]
7. sign: If set to true, the server will sign the requests (by default we don't sign them), this is useful for usage in smart contracts [ Default - false]
"""
function get_symbol_price(fsym::String, tsyms::Array{String,1}; tryConversion::Bool=true, relaxedValidation::Bool=true, e::String="cccagg_or_exchange", extraParams::String="", sign::Bool=false)
    url = build_price_url("single_symbol_price", fsym=fsym, tsyms=tsyms, e=e, tryConversion=tryConversion, 
                          relaxedValidation=relaxedValidation, extraParams=extraParams, sign=sign)
    try
        str = make_API_call(url)
        jobj = JSON.Parser.parse(str)
        datadict = jobj
        return datadict
    catch e
        return e
    end
end

"""
    get_multisymbol_price(fsyms::Array{String,1}, tsyms::Array{String,1}; tryConversion::Bool=true, relaxedValidation::Bool=true, e::String="cccagg_or_exchange", extraParams::String="", sign::Bool=false)

Same as single API path but with multiple from symbols.

1. tryConversion: If set to false, it will try to get only direct trading values. This parameter is only valid for e=CCCAGG value [ Default - true]
2. fsyms [Required]: Comma separated cryptocurrency symbols list [ Min length - 1] [ Max length - 300]
3. tsyms [Required]: Comma separated cryptocurrency symbols list to convert into [ Min length - 1] [ Max length - 100]
4. relaxedValidation: Setting this to true will make sure you don't get an error on non trading pairs, they will just be filtered out of the response. [ Default - true]
5. e: The exchange to obtain data from [ Min length - 2] [ Max length - 30] [ Default - cccagg_or_exchange]
6. extraParams: The name of your application (we recommend you send it) [ Min length - 1] [ Max length - 2000] [ Default - NotAvailable]
7. sign: If set to true, the server will sign the requests (by default we don't sign them), this is useful for usage in smart contracts [ Default - false]
"""
function get_multisymbol_price(fsyms::Array{String,1}, tsyms::Array{String,1}; tryConversion::Bool=true, relaxedValidation::Bool=true, 
                                e::String="cccagg_or_exchange", extraParams::String="", sign::Bool=false)
    url = build_price_url("multiple_symbol_price", fsyms=fsyms, tsyms=tsyms, e=e, tryConversion=tryConversion, 
                          relaxedValidation=relaxedValidation, extraParams=extraParams, sign=sign)
    try
        str = make_API_call(url)
        jobj = JSON.Parser.parse(str)
        datadict = jobj
        return datadict
    catch e
        return e
    end
end 

"""
    get_multisymbol_fulldata(fsyms::Array{String,1}, tsyms::Array{String,1}; tryConversion::Bool=true, relaxedValidation::Bool=true, e::String="cccagg_or_exchange", extraParams::String="", sign::Bool=false)

Get all the current trading info (price, vol, open, high, low etc) of any list of cryptocurrencies in any other currency that you need. If the crypto does not trade directly into the toSymbol requested, BTC will be used for conversion.
This API also returns Display values for all the fields. If the opposite pair trades we invert it (eg.: BTC-XMR)

1. tryConversion: If set to false, it will try to get only direct trading values. This parameter is only valid for e=CCCAGG value [ Default - true]
2. fsyms [Required]: Comma separated cryptocurrency symbols list [ Min length - 1] [ Max length - 300]
3. tsyms [Required]: Comma separated cryptocurrency symbols list to convert into [ Min length - 1] [ Max length - 100]
4. relaxedValidation: Setting this to true will make sure you don't get an error on non trading pairs, they will just be filtered out of the response. [ Default - true]
5. e: The exchange to obtain data from [ Min length - 2] [ Max length - 30] [ Default - cccagg_or_exchange]
6. extraParams: The name of your application (we recommend you send it) [ Min length - 1] [ Max length - 2000] [ Default - NotAvailable]
7. sign: If set to true, the server will sign the requests (by default we don't sign them), this is useful for usage in smart contracts [ Default - false]
"""
function get_multisymbol_fulldata(fsyms::Array{String,1}, tsyms::Array{String,1}; tryConversion::Bool=true, relaxedValidation::Bool=true, 
                                e::String="cccagg_or_exchange", extraParams::String="", sign::Bool=false)
    url = build_price_url("multiple_symbol_full", fsyms=fsyms, tsyms=tsyms, e=e, tryConversion=tryConversion, 
                          relaxedValidation=relaxedValidation, extraParams=extraParams, sign=sign)
    try
        str = make_API_call(url)
        jobj = JSON.Parser.parse(str)
        datadict = jobj
        return datadict
    catch e
        return e
    end
end 

"""
    get_custom_average()

Compute the current trading info (price, vol, open, high, low etc) of the requested pair as a volume weighted average based on the exchanges requested.

1. fsym [Required]: The cryptocurrency symbol of interest [ Min length - 1] [ Max length - 30]
2. tsym [Required]: The currency symbol to convert into [ Min length - 1] [ Max length - 30]
3. e [Required]: The exchange to obtain data from [ Min length - 2] [ Max length - 150]
4. extraParams: The name of your application (we recommend you send it) [ Min length - 1] [ Max length - 2000] [ Default - NotAvailable]
5. sign: If set to true, the server will sign the requests (by default we don't sign them), this is useful for usage in smart contracts [ Default - false]
"""
function get_custom_average(fsym::String, tsym::String, e::String; extraParams::String="", sign::Bool=false)
    url = build_price_url("generateAvg", fsym=fsym, tsym=tsym, e=e, extraParams=extraParams, sign=sign)
    try
        str = make_API_call(url)
        jobj = JSON.Parser.parse(str)
        datadict = jobj
        return datadict
    catch e
        return e
    end
end