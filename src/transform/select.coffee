module.exports = ({selector, unwrap = no}) ->
  (tree) ->
    matches = []
    tree.match selector, (node) ->
      matches.push (if unwrap then node.content or '' else node)
      node

    if matches.length is 1
    then matches[0]
    else matches
