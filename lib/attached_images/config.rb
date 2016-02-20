module AttachedImages
  def self.configure(&block)
    yield @config ||= AttachedImages::Configuration.new
  end

  def self.config
    @config
  end

  # Configuration class
  class Configuration
    include ActiveSupport::Configurable

    config_accessor :storage_prefix
  end

  configure do |config|
    config.storage_prefix = ''
  end
end

# config/initializers/attached_images.rb

# AttachedImages.configure do |config|
#   config.storage_prefix = 'my_project'
# end

# AttachedImages.config.storage_prefix