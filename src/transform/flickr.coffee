module.exports = (flickrUrl) ->
  (tree) ->
    [
      {
        tag: "div"
        attrs: class: "flickr"
        content: [
          {
            tag: "iframe"
            attrs:
              src: flickrUrl
              frameborder: 0
              allowfullscreen: true
              webkitallowfullscreen: true
              mozallowfullscreen: true
              oallowfullscreen: true
              msallowfullscreen: true
          }
          {
            tag: "div"
            attrs: class: "gallery"
            content: "Galería de imágenes interactiva"
          }
        ]
      }
      tree
    ]
