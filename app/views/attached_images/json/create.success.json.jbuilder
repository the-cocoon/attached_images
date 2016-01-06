json.set! :keep_alerts, true

json.set! :flash, {
  notice: "Изображение успешно загружено"
}

node_item = sortable_tree @attached_image, render_module: AttachedImagesTreeHelper

json.set! :html_content, {
  set_html: {
    ".js--attached-images--count" => @item.attached_images.count
  },
  append: {
    '.js--attached-images--list' => node_item
  }
}
