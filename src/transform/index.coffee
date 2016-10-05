Q = require "q"
Q.longStackSupport = on
co = require "co"
sander = require "sander"
posthtml = require "posthtml"
toMd = require "to-markdown"

encoding = "utf8"

processor =
  posthtml()
  .use require("./select")(unwrap: yes, selector: attrs: id: "contents")
  .use require("./removeIds")()
  .use require("./removeSuperfluousSpans")()
  .use require("./namespace")()
  .use require("./resolveUrls")()

module.exports = (dirtyHtml) ->
  processor.process(dirtyHtml)
  .then ({html}) -> toMd html
