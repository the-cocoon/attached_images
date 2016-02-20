# include ::AttachedImages::Base
module AttachedImages
  module Base
    extend ActiveSupport::Concern

    included do
      include ::ImageTools

      attr_accessor :file_need_to_be_processed
      before_save   :set_file_need_to_be_processed

      before_save   :file_generate_file_name, if: ->(o) { o.file_need_to_be_processed? }
      after_commit  :file_build_variants

      prefix = ::AttachedImages.config.storage_prefix

      has_attached_file :file,
                        default_url: "/default_images/#{ prefix }/attached_images/:style.gif",
                        path:        ":rails_root/public/uploads/#{ prefix }/attached_images/:holder_type/:holder_id/:id/:style/:filename",
                        url:         "/uploads/#{ prefix }/attached_images/:holder_type/:holder_id/:id/:style/:filename"

      # do_not_validate_attachment_file_type :file
      validates_attachment_content_type :file, content_type: /image/

    end # included

    def file_need_to_be_processed?
      file? && file_updated_at_changed?
    end

    def set_file_need_to_be_processed
      self.file_need_to_be_processed = file_need_to_be_processed?
      nil
    end

    def file_generate_file_name
      attachment = self.file
      file_name  = attachment.instance_read(:file_name)
      file_name  = "attached_image_#{ Time.now.to_i }." + ::ImageTools.file_ext(file_name)
      attachment.instance_write :file_name, file_name
    end

    def file_build_variants
      if file_need_to_be_processed
        src = file.path

        ###########################
        # VARIANTS
        ###########################

        # 16x9
        v1600x900 = file.path :v1600x900
        v1280x720 = file.path :v1280x720
        v640x360  = file.path :v640x360

        create_path_for_file v1600x900
        create_path_for_file v1280x720
        create_path_for_file v640x360

        # 4x3
        v1024x768 = file.path :v1024x768
        v800x600  = file.path :v800x600
        v640x480  = file.path :v640x480

        create_path_for_file v1024x768
        create_path_for_file v800x600
        create_path_for_file v640x480

        # 1x1
        v500x500  = file.path :v500x500
        v100x100  = file.path :v100x100

        create_path_for_file v500x500
        create_path_for_file v100x100

        ###########################
        # ~ VARIANTS
        ###########################

        # src prepare
        manipulate({ src: src, dest: src, larger_side: 1600 }) do |image, opts|
          image = auto_orient image
          image = optimize    image
          image = strip       image
          image = biggest_side_not_bigger_than(image, opts[:larger_side])
        end

        # 16x9
        manipulate({ src: src, dest: v1600x900, larger_side: 1600 }) do |image, opts|
          image = smart_rect image, 1600, 900, { repage: false }
          image
        end

        manipulate({ src: v1600x900, dest: v1280x720 }) do |image, opts|
          image = strict_resize image, 1280, 720
          image
        end

        manipulate({ src: v1280x720, dest: v640x360 }) do |image, opts|
          image = strict_resize image, 640, 360
          image
        end

        # 4x3
        manipulate({ src: src, dest: v1024x768, larger_side: 1024 }) do |image, opts|
          image = smart_rect image, 1024, 768, { repage: false }
          image
        end

        manipulate({ src: v1024x768, dest: v800x600 }) do |image, opts|
          image = strict_resize image, 800, 600
          image
        end

        manipulate({ src: v800x600, dest: v640x480 }) do |image, opts|
          image = strict_resize image, 640, 480
          image
        end

        # 1x1
        manipulate({ src: src, dest: v500x500, larger_side: 500 }) do |image, opts|
          image = to_square image, 500, { repage: false }
          image
        end

        manipulate({ src: v500x500, dest: v100x100 }) do |image, opts|
          image = to_square image, 100
          image
        end

        # recalculate src size & save
        self.file_need_to_be_processed = false
      end
    end

    def crop_16x9 params
      crop_params = params[:crop].symbolize_keys

      src       = file.path
      v1600x900 = file.path :v1600x900
      v1280x720 = file.path :v1280x720
      v640x360  = file.path :v640x360

      manipulate({ src: src, dest: v1600x900 }.merge(crop_params)) do |image, opts|
        scale = image[:width].to_f / opts[:img_w].to_f
        image = crop image, opts[:x], opts[:y], opts[:w], opts[:h], { scale: scale, repage: false }
        image = strict_resize image, 1600, 900
        image
      end

      manipulate({ src: v1600x900, dest: v1280x720 }) do |image, opts|
        image = strict_resize image, 1280, 720
        image
      end

      manipulate({ src: v1280x720, dest: v640x360 }) do |image, opts|
        image = strict_resize image, 640, 360
        image
      end

      file.url(:v1600x900, timestamp: false)
    end

    def crop_4x3 params
      crop_params = params[:crop].symbolize_keys

      src       = file.path
      v1024x768 = file.path :v1024x768
      v800x600  = file.path :v800x600
      v640x480  = file.path :v640x480

      manipulate({ src: src, dest: v1024x768 }.merge(crop_params)) do |image, opts|
        scale = image[:width].to_f / opts[:img_w].to_f
        image = crop image, opts[:x], opts[:y], opts[:w], opts[:h], { scale: scale, repage: false }
        image = strict_resize image, 1024, 768
        image
      end

      manipulate({ src: v1024x768, dest: v800x600 }) do |image, opts|
        image = strict_resize image, 800, 600
        image
      end

      manipulate({ src: v800x600, dest: v640x480 }) do |image, opts|
        image = strict_resize image, 640, 480
        image
      end

      file.url(:v1024x768, timestamp: false)
    end

    def crop_1x1 params
      crop_params = params[:crop].symbolize_keys

      src      = file.path
      v500x500 = file.path :v500x500
      v100x100 = file.path :v100x100

      manipulate({ src: src, dest: v500x500 }.merge(crop_params)) do |image, opts|
        scale = image[:width].to_f / opts[:img_w].to_f
        image = crop image, opts[:x], opts[:y], opts[:w], opts[:h], { scale: scale, repage: false }
        image = strict_resize image, 500, 500
        image
      end

      manipulate({ src: v500x500, dest: v100x100 }) do |image, opts|
        image = strict_resize image, 100, 100
        image
      end

      file.url(:v500x500, timestamp: false)
    end

    def image_rotate_left
      return false unless file?

      image_variants = all_image_variants.push(file.path)

      image_variants.each do |image_path|
        manipulate({ src: image_path, dest: image_path }) do |image, opts|
          rotate_left image
        end
      end
    end

    def image_rotate_right
      return false unless file?

      image_variants = all_image_variants.push(file.path)

      image_variants.each do |image_path|
        manipulate({ src: image_path, dest: image_path }) do |image, opts|
          rotate_right image
        end
      end
    end

    def all_image_variants
      [
        # 16x9
        file.path(:v1600x900),
        file.path(:v1280x720),
        file.path(:v640x360),

        # 4x3
        file.path(:v1024x768),
        file.path(:v800x600),
        file.path(:v640x480),

        # 1x1
        file.path(:v500x500),
        file.path(:v100x100)
      ]
    end

    def destroy_all!
      destroy_file( all_image_variants )
      destroy!
    end
  end # Base
end
