# DOC:
# We use Helper Methods for tree building,
# because it's faster than View Templates and Partials

# SECURITY note
# Prepare your data on server side for rendering
# or use h.html_escape(node.content)
# for escape potentially dangerous content
module AttachedImagesTreeHelper
  module Render
    class << self
      attr_accessor :h, :options

      def render_node(h, options)
        @node = options[:node]
        @h, @options = h, options

        "
          <li data-node-id='#{ @node.id }' class='js--attached-images--node-#{ @node.id }'>
            <div class='ptz--div-0 p10'>

              <div class='ptz--table w100p'>
                <div class='ptz--tr'>
                  <div class='ptz--td w100p vam'>
                    #{ attached_image_block }
                  </div>

                  <div class='ptz--td w30px tac'>
                    #{ handler }
                  </div>
                </div>
              </div>

            </div>

            #{ children }
          </li>
        "
      end

      def attached_image_block
        h.render(template: 'attached_images/attached_image_block', locals: { image: @node })
      end

      def handler
        "<div class='the-sortable-tree--handler p5'>
          <i class='fa fa-arrows fs16'></i>
        </div>"
      end

      def children
        unless options[:children].blank?
          "<ol class='the-sortable-tree--nested-set'>#{ options[:children] }</ol>"
        end
      end

    end
  end
end
