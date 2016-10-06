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

normalize = (str) ->
  str.toLowerCase()
  .replace /á/g, "a"
  .replace /é/g, "e"
  .replace /í/g, "i"
  .replace /ó/g, "o"
  .replace /ú/g, "u"
  .replace /ñ/g, "n"
  .replace /ç/g, "c"

Q co ->
  data = TSV.parse (yield sander.readFile "data", "index.tsv", {encoding})

  for post in data when post.id
    console.log "\nProcessing #{post.title}"

    normalized = normalize post.id

    image =
      try 
        yield sander.copyFile("data", "img", post.id + ".jpg").to(config.contentPath, "images", "migrado", "#{normalized}.jpg")
        "/content/images/migrado/#{normalized}.jpg"
      catch err
        console.log "No image for #{post.id}"
        console.log err
        undefined

    markdown =
      try
        yield transform (yield sander.readFile "data", "html", post.id + ".html", {encoding}), {
          urlToMedia: ["/", "content", "images", "migrado", "#{normalized}-media"]
          pathToMedia: [config.contentPath, "images", "migrado", "#{normalized}-media"]
          flickr: post.flickr
          form: post.form
        }
      catch err
        console.log "No text for #{post.id}"
        console.log err
        undefined

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

      unless 200 <= res.status < 300
        err = new Error "Response isn't 200'"
        err.response = res
        throw err
      
      console.log "Done #{post.id}"

    catch err
      console.log "Error posting #{post.id}"
      console.log err
  
  return

.done (console.log.bind console, "Finished"), (console.log.bind console, "Error")
