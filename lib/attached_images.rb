require "attached_images/version"
require "attached_images/config"

require "image_tools"
require "crop_tool"

module AttachedImages
  class Engine < Rails::Engine
    config.autoload_paths << "#{ config.root }/app/controllers/concerns/"
    config.autoload_paths << "#{ config.root }/app/models/concerns/"
  end
end

_root_ = File.expand_path('../../', __FILE__)
require "#{ _root_ }/config/routes"