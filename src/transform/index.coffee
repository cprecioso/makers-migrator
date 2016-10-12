posthtml = require "posthtml"

module.exports = (dirtyHtml, {urlToMedia, pathToMedia, flickr, form}) ->

  processor =
    posthtml()
    .use require("./select")(unwrap: yes, selector: attrs: id: "contents")
    .use require("./removeIds")()
    .use require("./removeSuperfluousSpans")()
    .use require("./namespace")()
    .use require("./resolveUrls")()
    .use require("./unembedder")({urlToMedia, pathToMedia})
  
  if flickr
    processor = processor.use require("./flickr")(flickr)
  if form
    processor = processor.use require("./form")(form)
  
  processor.process(dirtyHtml)
  .then ({html}) -> html
