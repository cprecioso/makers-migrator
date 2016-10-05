crypto = require "crypto"
posthtmlPrefixClass = require "posthtml-prefix-class"
postcss = require "posthtml-postcss"
postcssClassPrefix = require "postcss-class-prefix"
postcssPrefixSelector = require "postcss-prefix-selector"

defaultPrefixer = ->
  crypto.randomBytes(5).toString "hex"

module.exports = ({prefixer = defaultPrefixer} = {}) ->
  (tree) ->
    prefix = "p#{prefixer tree}__"
    root = prefix + "principal"
    
    Promise.resolve(tree)
    .then posthtmlPrefixClass({prefix})
    .then postcss([
      postcssClassPrefix prefix
      postcssPrefixSelector prefix: ".#{root} "
    ], {})
    .then (tree) ->
      tag: 'div'
      attrs: class: root
      content: tree
