nocache = "?#{ ::Time.now.to_i }"
id      = @attached_image.id

json.set! :html_content, {
  attrs: {
    replace: {
      ".js--attached-images--#{ @itype }-img-#{ id }" => { src: @path + nocache },
    }
  }
}