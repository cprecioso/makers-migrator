module.exports = () -> (tree) -> 
  tree.walk (node) ->
    delete node.attrs?.id
    node
  tree
