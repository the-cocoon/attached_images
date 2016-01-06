json.set! :keep_alerts, true

json.set! :flash, {
  warning: "При загрузке возникли ошибки"
}

json.errors @attached_image.localized_errors