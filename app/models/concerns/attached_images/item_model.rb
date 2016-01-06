# include ::AttachedImages::ItemModel
module AttachedImages
  module ItemModel
    extend ActiveSupport::Concern

    included do
      has_many :attached_images, as: :holder

      def main_image
        attached_images.order('attached_images.lft ASC').try(:first)
      end

      def main_image_url(version = nil)
        main_image                               ? \
        main_image.try(:file).try(:url, version) : \
        AttachedImage.new.file.url(version)
      end

      def main_image_path(version = nil)
        main_image                                ? \
        main_image.try(:file).try(:path, version) : \
        [Rails.root, :public, AttachedImage.new.file.url(:v100x100)].join('/')
      end
    end
  end
end