module.exports = () -> (tree) -> 
  tree.match {tag: 'span'}, (node) ->
    if node.attrs? and (Object.keys(node.attrs).length isnt 0)
    then node
    else node.content or ''
  tree
