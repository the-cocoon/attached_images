json.set! :keep_alerts, true

json.set! :flash, {
  notice: "Изображение удалено"
}

json.set! :html_content, {
  destroy: [ ".js--attached-images--node-#{ @attached_image.id }" ]
}