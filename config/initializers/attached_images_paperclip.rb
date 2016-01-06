module Paperclip
  module Interpolations
    def id attachment, style
      attachment.instance.id
    end

    def klass attachment, style
      attachment.instance.class.to_s.downcase
    end

    def holder_id attachment, style
      attachment.instance.holder_id
    end

    def holder_type attachment, style
      attachment.instance.holder_type.downcase
    end

    def attached_image_id attachment, style
      attachment.instance.id
    end
  end
end