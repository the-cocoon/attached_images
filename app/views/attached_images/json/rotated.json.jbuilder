nocache = "?#{ ::Time.now.to_i }"
id      = @attached_image.id
file    = @attached_image.file

json.set! :html_content, {
  attrs: {
    replace: {
      ".js--attached-images--original-img-#{ id }"  => { src: file.url + nocache },
      ".js--attached-images--v1024x768-img-#{ id }" => { src: file.url(:v1024x768) + nocache },
      ".js--attached-images--v1600x900-img-#{ id }" => { src: file.url(:v1600x900) + nocache },
      ".js--attached-images--v500x500-img-#{ id }"  => { src: file.url(:v500x500)  + nocache }
    }
  }
}