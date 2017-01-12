# AttachedImage

1.
  > rake attached_images_engine:install:migrations

2.

```ruby
  class User < AR
    has_many :attached_images
  end

  class Post < AR
    include ::AttachedImages::ItemModel
  end

  class AttachedImage < ActiveRecord::Base
    include ::AttachedImages::Base
  end
```

3.

```
= render template: 'attached_images/new', locals: { item: @product }
```

4.

CSS

#= require attached_images/attached_images

#= require crop_tool/crop_tool
#= require crop_tool/jcrop/jquery.Jcrop
#= require the_sortable_tree/sortable_ui/base

JS

//= require jquery2
//= require jquery-ui
//= require jquery_ujs

//= require jQuery-File-Upload/jquery.iframe-transport
//= require jQuery-File-Upload/jquery.fileupload

#= require notifications/vendors/toastr
#= require notifications

#= require attached_images/attached_images
#= require JODY/base
#= require ./jody_notificator_init

#= require crop_tool/crop_tool
#= require crop_tool/jcrop/jquery.Jcrop

#= require the_sortable_tree/jquery.ui.nestedSortable
#= require the_sortable_tree/sortable_ui/base

```
@JodyNotificator.clean = ->
  Notifications.clean()

@JodyNotificator.error = (error) ->
  Notifications.show_error(error)

@JodyNotificator.errors = (errors) ->
  Notifications.show_errors(errors)

@JodyNotificator.flashs = (flashs) ->
  Notifications.show_flash(flashs)

@JodyNotificator.flash = (method, _msg) ->
  flashs = {}
  flashs[ method ] = _msg
  Notifications.show_flash(flashs)
```

5.

```
$(document).on "ready page:load", ->
  TheSortableTree.SortableUI.init()
  AttachedImages.init()
  CropTool.init()
```

6.

```
= yield :crop_tool

.ptz_div-0.p20.mb30
  = render template: 'attached_images/new', locals: { item: @product }

= render template: 'attached_images/list', locals: { item: @product }
```
