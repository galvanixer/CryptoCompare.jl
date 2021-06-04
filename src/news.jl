"""
    get_latest_news(; lang::String=EN, feeds::Array{String,1}, categories::Array{String,1}, ITs::Int64, sortOrder::String)

Gets the latest/popular news from CryptoCompare API.

Input parameters:
1. feeds: Specific news feeds to retrieve news from [ Min length - 1] [ Max length - 1000] [ Default - ALL_NEWS_FEEDS]
2. categories: Category of news articles to return [ Min length - 3] [ Max length - 1000] [ Default - ALL_NEWS_CATEGORIES]
3. excludeCategories: News article categories to exclude from results [ Min length - 3] [ Max length - 1000] [ Default - NO_EXCLUDED_NEWS_CATEGORIES]
4. lTs: Returns news before that timestamp [ Min - 0] [ Default - 0]
5. lang: Preferred language - English (EN) or Portuguese (PT) [ Min length - 1] [ Max length - 4] [ Default - EN]
6. sortOrder: The order to return news articles - latest or popular [ Min length - 1] [ Max length - 8] [ Default - latest]
7. extraParams: The name of your application (we recommend you send it) [ Min length - 1] [ Max length - 2000] [ Default - NotAvailable]
8. sign: If set to true, the server will sign the requests (by default we don't sign them), this is useful for usage in smart contracts [ Default - false]
"""
function get_latest_news(; lang::String="EN", feeds::Array{String,1}=Array{String,1}([]), categories::Array{String,1}=Array{String,1}([]), lTs::Int64=0, sortOrder::String="latest")
    url = build_news_url("latest_news_articles", lang=lang, feeds=feeds, categories=categories, lTs=lTs, sortOrder=sortOrder)

    try 
        str = make_API_call(url)
        jobj = JSON.Parser.parse(str)
        datadict = jobj["Data"]

        df = DataFrame(imageurl=String[], id=Int[], guid=String[], published_on=DateTime[], body=String[], downvotes=Int[], 
                       url=String[], upvotes=Int[], source=String[], title=String[], tags=String[], categories=String[], lang=String[],
                       source_info=Dict{String,Any}[])

        
        nrows = size(datadict)[1]

        for i in 1:nrows 
            push!(df, datadict[i], cols=:union)
        end 

        return df 

    catch e
        return e 
    end 
end 

"""
    get_news_feeds(; extraParams="", sign::Bool=false)

Gets the list of feeds from CryptoCompare API.

Input parameters:
1. extraParams: The name of your application (we recommend you send it) [ Min length - 1] [ Max length - 2000] [ Default - NotAvailable]
2. sign: If set to true, the server will sign the requests (by default we don't sign them), this is useful for usage in smart contracts [ Default - false]
"""
function get_news_feeds(; extraParams="", sign::Bool=false)

    url = build_news_url("feeds"; extraParams=extraParams, sign=sign)

    try 
        str = make_API_call(url)
        jobj = JSON.Parser.parse(str)
        datadict = jobj
        df = DataFrame(key=String[], name=String[], lang=String[], img=String[])
        nrows = size(datadict)[1]

        for i in 1:nrows 
            push!(df.key, datadict[i]["key"])
            push!(df.name, datadict[i]["name"])
            push!(df.lang, datadict[i]["lang"])
            push!(df.img, datadict[i]["img"])
        end 

        return df 
    
    catch e 
        return e 
    end 
end 

"""
    get_news_feeds_and_categories(; extraParams::String="", sign::Bool=false)

Gets the list of feeds and categories from CryptoCompare API.

Input parameters:
1. extraParams: The name of your application (we recommend you send it) [ Min length - 1] [ Max length - 2000] [ Default - NotAvailable]
2. sign: If set to true, the server will sign the requests (by default we don't sign them), this is useful for usage in smart contracts [ Default - false]
"""
function get_news_feeds_and_categories(; extraParams::String="", sign::Bool=false)
    url = build_news_url("feedsandcategories"; extraParams=extraParams, sign=sign)

    try 
        str = make_API_call(url)
        jobj = JSON.Parser.parse(str)
        datadict = jobj["Data"]
        datadict_feeds = datadict["Feeds"]
        datadict_categories = datadict["Categories"]
        df_feeds = DataFrame(key=String[], name=String[], lang=String[], img=String[])
        df_categories = DataFrame(categoryName=String[], excludedPhrases=Array{String,1}[], includedPhrases=Array{String,1}[], wordsAssociatedWithCategory=Array{String,1}[])
        
        nrows = size(datadict_categories)[1]
        for i in 1:nrows 
            push!(df_categories, datadict_categories[i], cols=:union)
        end 

        nrows = size(datadict_feeds)[1]
        for i in 1:nrows 
            push!(df_feeds, datadict_feeds[i], cols=:union)
        end 

        return df_feeds, df_categories
    
    catch e 
        return e 
    end 
end  

"""
    get_news_categories(; extraParams::String="", sign::Bool=false)

Gets the list of news categories from CryptoCompare API.

Input parameters:
1. extraParams: The name of your application (we recommend you send it) [ Min length - 1] [ Max length - 2000] [ Default - NotAvailable]
2. sign: If set to true, the server will sign the requests (by default we don't sign them), this is useful for usage in smart contracts [ Default - false]
"""
function get_news_categories(; extraParams="", sign::Bool=false)
    url = build_news_url("categories"; extraParams=extraParams, sign=sign)

    try 
        str = make_API_call(url)
        jobj = JSON.Parser.parse(str)
        datadict = jobj
        df = DataFrame(categoryName=String[], excludedPhrases=Array{String,1}[], includedPhrases=Array{String,1}[], wordsAssociatedWithCategory=Array{String,1}[])
        nrows = size(datadict)[1]

        for i in 1:nrows 
            push!(df, datadict[i], cols=:union)
        end 

        return df 
    
    catch e 
        return e 
    end 
end 

