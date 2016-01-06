@AttachedImages = do ->
  init: ->
    AttachedImagesFileUploader.init()

    @inited ||= do =>
      doc = $ document

      doc.on 'ajax:success', '.js--attached-images--rotate', (xhr, data, status) ->
        JODY.processor(data)

      doc.on 'ajax:success', '.js--attached-images--delete', (xhr, data, status) ->
        JODY.processor(data)

      doc.on 'click', '@attached-image--manage-switcher', (e) ->
        link   = $ e.currentTarget
        holder = link.parents('@attached-image')

        if $('@attached-image--manage-intro:visible', holder).length
          $('@attached-image--manage-intro', holder).slideUp ->
            $('@attached-image--manage', holder).slideDown()
        else
          $('@attached-image--manage', holder).slideUp ->
            $('@attached-image--manage-intro', holder).slideDown()

        return false

  crop_tool_callback: (data, btn_params) ->
    JODY.processor(data)
    CropTool.finish()

@AttachedImagesFileUploader = do ->
  init: ->
    $('.js--attached-images--multiple-upload-input').fileupload
      type:      'POST'
      dataType:  'JSON'
      paramName: 'file'
      dropZone: $('.js--attached-images--drug-and-drop-files')

      add: (e, uploader) ->
        uploader.submit()

      done: (e, uploader) ->
        data = uploader.result
        JODY.processor(data)

      fail: (e, uploader) ->
        [ xhr, response, status ] = [ null, uploader.jqXHR, uploader.textStatus ]
        JODY.error_processor(xhr, response, status)

      progressall: (e, data) ->
        progress = parseInt data.loaded / data.total * 100, 10
        holder   = $('.js--attached-images--uploading-percent')

        if progress < 100
          size = "#{ progress }%"
          holder.html size
        else
          holder.html ''