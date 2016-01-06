# include ::AttachedImagesActions
module AttachedImages
  module Actions

    LIST = %w[
      image_crop_16x9
      image_crop_4x3
      image_crop_1x1

      image_rotate_left
      image_rotate_right

      image_delete
    ]

    def image_crop_16x9
      path = @attached_image.image_crop_16x9(params)
      render json: { ids: { '@main-image--v16x9' => path + rnd_num  } }
    end

    def image_crop_4x3
      path = @attached_image.image_crop_4x3(params)
      render json: { ids: { '@main-image--v4x3' => path + rnd_num } }
    end

    def image_crop_1x1
      path = @attached_image.image_crop_1x1(params)
      render json: { ids: { '@main-image--v1x1' => path + rnd_num } }
    end

    def image_rotate_left
      @attached_image.image_rotate_left
      redirect_to :back
    end

    def image_rotate_right
      @attached_image.image_rotate_right
      redirect_to :back
    end

    def image_delete
      @attached_image.image_destroy!
      redirect_to :back
    end

    private

    def rnd_num
      "?#{ Time.now.to_i }"
    end

  end # Actions
end # AttachedImages