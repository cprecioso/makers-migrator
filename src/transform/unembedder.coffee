sander = require "sander"
popsicle = require "popsicle"
path = require "path"

transport = popsicle.createTransport type: "buffer"

module.exports = ({urlToMedia, pathToMedia}) ->
  (tree) ->
    promises = []

    tree.match tag: "img", (node) ->
      if (url = node.attrs?.src) and (filename = node.attrs?.alt)
        promise =
          popsicle.get {url, transport}
          .then ({body}) -> sander.writeFile pathToMedia..., filename, body
          .then -> node.attrs.src = path.resolve urlToMedia..., filename
        
        promises.push promise
        return node

    Promise.all promises
    .then -> tree
