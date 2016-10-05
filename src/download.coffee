TSV = require "tsv"
Q = require "q"
Q.longStackSupport = on
co = require "co"
sander = require "sander"
popsicle = require "popsicle"

encoding = "utf8"

Q co ->
  data = TSV.parse (yield sander.readFile "data", "index.tsv", {encoding})

  results = for post in data when post.id
    console.log "Processing #{post.id}"
    page = yield popsicle.get "https://docs.google.com/document/d/#{post.article}/pub"
    sander.writeFile "data", "html", post.id + ".html", page.body, {encoding}

.done (console.log.bind console, "Finished"), (console.log.bind console, "Error")
