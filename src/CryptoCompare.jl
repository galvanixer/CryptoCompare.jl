module CryptoCompare

using HTTP, JSON
using DataFrames, CSV
using Dates

api_key = "48e75e238a2194a99700ccf0922eef2de5b29fbdde578b86ddc26c649709c44b"

include("helper_functions.jl")
include("urls.jl")
include("news.jl")
include("price.jl")
include("historical_data.jl")
include("blockchain_data.jl")

end # module
