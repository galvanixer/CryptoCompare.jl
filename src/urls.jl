function build_blockchain_data_url(fname::String; kwargs...)
    if fname == "available_coin_list"
        url = "https://min-api.cryptocompare.com/data/blockchain/list?"
    elseif fname == "latest"
        url = "https://min-api.cryptocompare.com/data/blockchain/latest?"
    elseif fname == "historical_daily"
        url = "https://min-api.cryptocompare.com/data/blockchain/histo/day?"
    elseif fname == "mining_calculator_data"
        url = "https://min-api.cryptocompare.com/data/blockchain/mining/calculator?"
    end 

    # collect url parts in list
    url_parts = []

    for (key, value) in kwargs
        # conversion
        if key == :fsym
            push!(url_parts,"fsym=$(value)")
        elseif key == :fsyms
            push!(url_parts,"fsyms=$(join(value,","))")
        elseif key == :tsyms
            push!(url_parts,"tsyms=$(join(value,","))")

        # limit 
        elseif key==:limit 
            push!(url_parts, "limit=$(value)")
        # toTs
        elseif key==:toTs && value ≠ ""
            push!(url_parts, "toTs=$(value)")

        # extraParams
        elseif key == :extraParams && value ≠ ""
            push!(url_parts,"extraParams=$(value)")
        # sign
        elseif key == :sign && value==true
            push!(url_parts,"sign=$(value)")

        # api_key
        elseif key == :api_key && value!=""
            push!(url_parts, "api_key=$(value)")
        end 

    end 

    # put url together
    url = url * join(url_parts,"&")

    return url


end

function build_exchange_vol_url(fname::String; kwargs...)
    if fname in ["day", "hour", "minute"]
        url = "https://min-api.cryptocompare.com/data/exchange/histo$(fname)?"
    end

    # collect url parts in list
    url_parts = []

    for (key, value) in kwargs
        # conversion

        if key == :tsym
            push!(url_parts,"tsym=$(value)")
        # exchange
        elseif key == :e && value!= "all"
            push!(url_parts, "e=$(value)")
        elseif key == :e && value == "all"
            push!(url_parts, "e=CCCAGG")

        # aggregate 
        elseif key==:aggregate && value>1
            push!(url_parts, "aggregate=$(value)")
        # aggregate Predictable Time Periods
        elseif key==:aggregatePredictableTimePeriods && value==false
            push!(url_parts, "aggregatePredictableTimePeriods=$(value)")
        # limit 
        elseif key==:limit 
            push!(url_parts, "limit=$(value)")
        # toTs
        elseif key==:toTs && value!=""
            push!(url_parts, "toTs=$(value)")
        # extraParams
        elseif key == :extraParams && value ≠ ""
            push!(url_parts,"extraParams=$(value)")
        # sign
        elseif key == :sign && value==true
            push!(url_parts,"sign=$(value)")
        end 

    end 

    # put url together
    url = url * join(url_parts,"&")

    return url
end 

function build_symbol_vol_url(fname::String; kwargs...)
    if fname in ["day", "hour"]
        url = "https://min-api.cryptocompare.com/data/symbol/histo$(fname)?"
    end

    # collect url parts in list
    url_parts = []

    for (key, value) in kwargs
        # conversion
        if key == :tsym
            push!(url_parts,"tsym=$(value)")
        elseif key == :fsym
            push!(url_parts,"fsym=$(value)")

        # aggregate 
        elseif key==:aggregate && value>1
            push!(url_parts, "aggregate=$(value)")
        # limit 
        elseif key==:limit 
            push!(url_parts, "limit=$(value)")
        # toTs
        elseif key==:toTs && value!=""
            push!(url_parts, "toTs=$(value)")
        # extraParams
        elseif key == :extraParams && value ≠ ""
            push!(url_parts,"extraParams=$(value)")
        # sign
        elseif key == :sign && value==true
            push!(url_parts,"sign=$(value)")
        end 

    end 

    # put url together
    url = url * join(url_parts,"&")

    return url
end 

function build_symbol_vol_single_exchange_url(fname::String; kwargs...)
    if fname in ["day", "hour"]
        url = "https://min-api.cryptocompare.com/data/exchange/symbol/histo$(fname)?"
    end

    # collect url parts in list
    url_parts = []

    for (key, value) in kwargs
        # conversion
        if key == :tsym
            push!(url_parts,"tsym=$(value)")
        elseif key == :fsym
            push!(url_parts,"fsym=$(value)")
        # exchange
        elseif key == :e && value!= "all"
            push!(url_parts, "e=$(value)")
        elseif key == :e && value == "all"
            push!(url_parts, "e=CCCAGG")
        # aggregate 
        elseif key==:aggregate && value>1
            push!(url_parts, "aggregate=$(value)")
        # limit 
        elseif key==:limit 
            push!(url_parts, "limit=$(value)")
        # toTs
        elseif key==:toTs && value!=""
            push!(url_parts, "toTs=$(value)")
        # extraParams
        elseif key == :extraParams && value ≠ ""
            push!(url_parts,"extraParams=$(value)")
        # sign
        elseif key == :sign && value==true
            push!(url_parts,"sign=$(value)")
        end 

    end 

    # put url together
    url = url * join(url_parts,"&")

    return url
end 

function build_historical_data_url(fname::String; kwargs...)
    if fname in ["day", "hour", "minute"]
        url = "https://min-api.cryptocompare.com/data/v2/histo$(fname)?"
    end 

    # collect url parts in list
    url_parts = []

    for (key, value) in kwargs
        # conversion
        if key == :try_conversion && value==false
            push!(url_parts, "tryConversion=false")
        elseif key == :fsym
            push!(url_parts,"fsym=$(value)")
        elseif key == :fsyms
            push!(url_parts,"fsyms=$(join(value,","))")
        elseif key == :tsym
            push!(url_parts,"tsym=$(value)")
        elseif key == :tsyms
            push!(url_parts,"tsyms=$(join(value,","))")

        # exchange
        elseif key == :e && value!= "all"
            push!(url_parts, "e=$(value)")
        elseif key == :e && value == "all"
            push!(url_parts, "e=CCCAGG")

        # aggregate 
        elseif key==:aggregate && value>1
            push!(url_parts, "aggregate=$(value)")
        # aggregate Predictable Time Periods
        elseif key==:aggregatePredictableTimePeriods && value==false
            push!(url_parts, "aggregatePredictableTimePeriods=$(value)")
        # limit 
        elseif key==:limit 
            push!(url_parts, "limit=$(value)")
        # allData
        elseif key==:allData && value==true
            push!(url_parts, "allData=$(value)")
        # toTs
        elseif key==:toTs && value ≠ ""
            push!(url_parts, "toTs=$(value)")
        # explainPath
        elseif key==:explainPath && value==true 
            push!(url_parts, "explainPath=$(value)")
        # extraParams
        elseif key == :extraParams && value ≠ ""
            push!(url_parts,"extraParams=$(value)")
        # sign
        elseif key == :sign && value==true
            push!(url_parts,"sign=$(value)")
        end 

    end 

    # put url together
    url = url * join(url_parts,"&")

    return url

end 

function build_price_url(fname::String; kwargs...)
    if fname=="single_symbol_price"
        url = "https://min-api.cryptocompare.com/data/price?"
    elseif fname == "multiple_symbol_price"
        url = "https://min-api.cryptocompare.com/data/pricemulti?"
    elseif fname == "multiple_symbol_full"
        url = "https://min-api.cryptocompare.com/data/pricemultifull?"
    elseif fname == "generateAvg"
        url = "https://min-api.cryptocompare.com/data/generateAvg?"
    end 

    # collect url parts in list
    url_parts = []

    for (key, value) in kwargs
        if key == :fsym
            push!(url_parts,"fsym=$(value)")
        elseif key == :fsyms
            push!(url_parts,"fsyms=$(join(value,","))")
        elseif key == :tsym
            push!(url_parts,"tsym=$(value)")
        elseif key == :tsyms
            push!(url_parts,"tsyms=$(join(value,","))")

        # exchange
        elseif key == :e && value!= "all"
            push!(url_parts, "e=$(value)")
        elseif key == :e && value == "all"
            push!(url_parts, "e=cccagg_or_exchange")

        # conversion
        elseif key == :try_conversion && value==false
            push!(url_parts, "tryConversion=false")

        elseif key == :relaxedValidation && value==false
            push!(url_parts, "relaxedValidation=false")
        
        elseif key == :extraParams && value ≠ ""
            push!(url_parts,"extraParams=$(value)")
        elseif key == :sign && value==true
            push!(url_parts,"sign=$(value)")
        end 

    end 

    # put url together
    url = url * join(url_parts,"&")

    return url

end 

function build_news_url(fname::String; kwargs...)
    # latest_news_articles_url = "https://min-api.cryptocompare.com/data/v2/news/?lang=EN"
    # latest_news_feeds_url = "https://min-api.cryptocompare.com/data/news/feeds"
    # news_articles_categories_url = "https://min-api.cryptocompare.com/data/news/categories"
    # list_news_feeds_and_categories_ulr = "https://min-api.cryptocompare.com/data/news/feedsandcategories"

    # keys2 = [feeds::String, categories::String, excludeCategories::String, ITs::Int64, lang::String, sortOrder::String]
    # keys = [extraParams::String, sign::Bool]
    if fname == "latest_news_articles"
        url = "https://min-api.cryptocompare.com/data/v2/news/?"
    elseif fname in ["feeds", "categories", "feedsandcategories"]
        url = "https://min-api.cryptocompare.com/data/news/$(fname)?"
    end 

    url_parts = []

    for (key,value) in kwargs
        if key == :feeds 
            if size(value)[1]≥1
                push!(url_parts,"feeds=$(join(value,","))")
            end
        elseif key == :categories 
            if size(value)[1]≥1
                push!(url_parts,"categories=$(join(value,","))")
            end
        elseif key == :excludeCategories 
            if size(value)[1]≥1
                push!(url_parts,"excludeCategories=$(join(value,","))")
            end
        elseif key == :lTs 
            push!(url_parts,"lTs=$(value)")
        elseif key == :lang 
            push!(url_parts,"lang=$(value)")
        elseif key == :sortOrder
            push!(url_parts,"sortOrder=$(value)")
        elseif key == :extraParams
            if value ≠ ""
                push!(url_parts,"extraParams=$(value)")
            end
        elseif key == :sign 
            push!(url_parts,"sign=$(value)")
        end 
    end 
    
    # put url together
    url = url * join(url_parts,"&")
    #return url_parts
    return url
end 


function build_url2(fname::String; kwargs...)
    
    if fname in ["price", "coinlist", "coinsnapshot", "miningcontracts","miningequipment"]
        url = "https://www.cryptocompare.com/api/data/$(fname)?"
    elseif fname in ["exchanges", "volumes", "pairs"]
        url = "https://min-api.cryptocompare.com/data/top/$(fname)?"
    elseif fname in ["minute", "hour", "day"]
        url = "https://min-api.cryptocompare.com/data/histo$(fname)?"
    else
        url = "https://min-api.cryptocompare.com/data/$(fname)?"
    end 

    # collect url parts in list
    url_parts = []

    for (key, value) in kwargs
        if key == :fsym
            append!(url_parts,"fsym=$(value)")
        elseif key == :fsyms
            append!(url_parts,"fsyms=$(join(value,","))")
        elseif key == :tsym
            append!(url_parts,"tsym=$(value)")
        elseif key == :tsyms
            append!(url_parts,"tsyms=$(join(value,","))")

        # exchange
        elseif key == :e && value!= "all"
            append!(url_parts, "e=$(value)")
        elseif key == :e && value == "all"
            append!(url_parts, "e=CCCAGG")

        # conversion
        elseif key == :try_conversion && value==false
            append!(url_parts, "tryConversion=false")

        # markets
        elseif key == :markets && value != "all"
            append!(url_parts, "e=$(join(value, ","))")
        elseif key == :markets && value == "all"
            append!(url_parts, "e=CCCAGG")

        elseif key == :avg_type && value!= "HourVWAP"
            append!(url_parts, "avgType=$(value)")
        elseif key == :utc_hour_diff && value!=0
            append!(url_parts, "UTCHourDiff=$(value)")
        # elseif key == :to_ts && value==true
        #     timestamp = to_ts_args_to_timestamp(value)
        #     if timestamp:
        #         url_parts.append("toTs={}".format(timestamp))
        elseif key==:aggregate && value!= 1
            append!(url_parts, "aggregate=$(value)")

        elseif key == :limit
            append!(url_parts, "limit=$(value)")
        end 

    end 

    # put url together
    url = url * join(url_parts,"&")

    return url
end 