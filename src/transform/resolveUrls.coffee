url = require "url"

module.exports = () -> (tree) -> 
  
  tree.match tag: 'a', (node) ->
    if node.attrs?.href
      parsed = url.parse node.attrs.href, true
      if parsed.host is "www.google.com" and parsed.pathname is "/url" and parsed.query?.q
        node.attrs.href = parsed.query.q
    node
  
  tree
