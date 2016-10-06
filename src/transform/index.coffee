Q = require "q"
Q.longStackSupport = on
co = require "co"
sander = require "sander"
posthtml = require "posthtml"

encoding = "utf8"

module.exports = (dirtyHtml, {flickr, form}) ->

  processor =
    posthtml()
    .use require("./select")(unwrap: yes, selector: attrs: id: "contents")
    .use require("./removeIds")()
    .use require("./removeSuperfluousSpans")()
    .use require("./namespace")()
    .use require("./resolveUrls")()
  
  if flickr
    processor = processor.use require("./flickr")(flickr)
  if form
    processor = processor.use require("./form")(form)
  
  processor.process(dirtyHtml)
  .then ({html}) -> html
