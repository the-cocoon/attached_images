# ::AttachedImages::Routes.mixin(self)

module AttachedImages
  class Routes
    def self.mixin mapper
      mapper.extend ::AttachedImages::DefaultRoutes
      mapper.send :attached_images_routes
    end
  end # Routes

  module DefaultRoutes
    def attached_images_routes
      resources :attached_images do
        patch :crop_16x9
        patch :crop_4x3
        patch :crop_1x1

        patch :rotate_left
        patch :rotate_right

        collection do
          post :rebuild
        end
      end
    end
  end # DefaultRoutes
end
