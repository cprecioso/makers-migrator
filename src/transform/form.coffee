module.exports = (formUrl) ->
  (tree) ->
    [
      tree
      {
        tag: "a"
        attrs:
          class: "button form"
          href: formUrl
          target: "_blank"
        content: "Formulario"
      }
    ]
