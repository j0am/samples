# Gif search app takes a param as the Criteria to use in the Search
# The app makes use of the giphy api to fetch results.
# We are interested in only the id and url values that are returned,
# and additionaly limit to 5 objects in the return JSON
#   Test using /app/w_flask/gif_search/gif_search_env/bin/python3 gif_search.py
#   point the browser/netcat/other tool at port localhost:8080/search/[your search criteria]

import urllib,json

from flask import Flask
app = Flask( __name__ )

@app.route("/search/<string:qry_criteria>")              # The only criteria we accept
def search( qry_criteria ):

    #construct the url as documented in the API call at:[https://github.com/Giphy/GiphyAPI]
    qry_str = "http://api.giphy.com/v1/gifs/search?q=" +\
               urllib.parse.quote_plus( qry_criteria ) +\
              "&api_key=dc6zaTOxFJmzC"                 +\
              "&limit=5&fmt=json"

    http_resp = urllib.request.urlopen(qry_str).read()   #<class 'http.client.HTTPResponse'>
    json_data = json.loads( http_resp.decode() ) 
    gif_list = json_data["data"]


    #filter the elements we want
    rtn_list = [ {"gif_id":gif["id"], "url":gif["url"]} for gif in gif_list ]
    rtn_str = json.dumps( rtn_list, indent=4, sort_keys=True )

    return '{"data":'+ rtn_str + '}'

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080 )
