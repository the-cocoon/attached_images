class AttachedImagesController < AttachedImagesRestrictController
  # before_action :check_user
  # before_action :check_ownership
  # before_action :check_action_permission

  include ::TheSortableTreeController::Rebuild

  before_action :set_item, only: %w[ create ]

  before_action :set_attached_image, only: %w[
    crop_16x9
    crop_4x3
    crop_1x1

    rotate_right
    rotate_left
    destroy
  ]

  def create
    file = params[:file] || params[:attached_image][:file]
    @attached_image = ::AttachedImage.new(holder: @item, file: file, user: current_user)

    if @attached_image.save
      render template: 'attached_images/json/create.success'
    else
      render template: 'attached_images/json/create.errors'
    end
  end

  def crop_16x9
    @itype = :v1600x900
    @path  = @attached_image.crop_16x9(params)
    render template: 'attached_images/json/cropped'
  end

  def crop_4x3
    @itype = :v1024x768
    @path  = @attached_image.crop_4x3(params)
    render template: 'attached_images/json/cropped'
  end

  def crop_1x1
    @itype = :v500x500
    @path  = @attached_image.crop_1x1(params)
    render template: 'attached_images/json/cropped'
  end

  def rotate_left
    @attached_image.image_rotate_left
    render template: 'attached_images/json/rotated'
  end

  def rotate_right
    @attached_image.image_rotate_right
    render template: 'attached_images/json/rotated'
  end

  def destroy
    @attached_image.destroy_all!
    render template: 'attached_images/json/deleted'
  end

  private

  def set_item
    klass = params[:item_type].constantize
    id    = params[:item_id]

    @item = klass.find(id)
  end

  def set_attached_image
    id = params[:id] || params[:attached_image_id]
    @attached_image = ::AttachedImage.find(id)
  end

  # def rnd_num
  #   "?#{ ::Time.now.to_i }"
  # end
end