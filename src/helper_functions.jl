function make_API_call(url::String)
    try
        response = HTTP.get(url)
        return String(response.body)
    catch e 
        #return "Error occurred: $(e)"
        return e
    end
end

function read_CSV_url(url::String)
    try
        response = HTTP.get(url)
        df = CSV.read(response.body, DataFrame)
        return df 
    catch e 
        return e 
    end 
end