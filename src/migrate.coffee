TSV = require "tsv"
Q = require "q"
Q.longStackSupport = on
co = require "co"
sander = require "sander"
popsicle = require "popsicle"
transform = require "./transform"

config = require "../config.json"

encoding = "utf8"

humanDateToISO = (date) ->
  [day, month, year] = date.split("/")
  date = new Date year, --month, day
  date.toISOString()

Q co ->
  data = TSV.parse (yield sander.readFile "data", "index.tsv", {encoding})

  for post in data when post.id
    console.log "\nProcessing #{post.title}"

    image =
      try 
        yield sander.copyFile("data", "img", post.id + ".jpg").to(config.contentPath, "images", "migrado", post.id + ".jpg")
        "/content/images/migrado/#{post.id}.jpg"
      catch err
        console.log "No image for #{post.id}"
        console.log err
        undefined

    markdown =
      try
        transform (yield sander.readFile "data", "html", post.id + ".html")
      catch err
        console.log "No text for #{post.id}"
        console.log err

    postObject = {
      slug: post.id
      title: post.title
      published_at: humanDateToISO post.timestamp
      featured: !!post.hot
      status: if post.published then "published" else "draft"
      language: "es_ES"
      image
      markdown
    }

    try
      res = yield popsicle.post
        url: config.apiPrefix + "posts/"
        body: posts: [postObject]
        headers:
          Authorization: "Bearer #{config.token}"

      if res.status isnt 200
        err = new Error "Response isn't 200'"
        err.response = res
        throw err
      
      console.log "Done #{post.id}"

    catch err
      console.log "Error posting #{post.id}"
      console.log err

.done (console.log.bind console, "Finished"), (console.log.bind console, "Error")
