class AttachedImagesCreateAttachedImages < ActiveRecord::Migration
  def change
    create_table :attached_images do |t|
      t.integer    :user_id
      t.references :holder, polymorphic: true

      # file | paperclip
      t.string   :file_file_name
      t.string   :file_content_type
      t.integer  :file_file_size, default: 0
      t.datetime :file_updated_at

      # text description
      t.text :raw_description
      t.text :description

      # images delayed processing status
      t.string :processing, default: :none

      # watermark
      t.boolean :watermark,      default: false
      t.string  :watermark_text, default: ''

      # Nested Set
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth, default: 0
    end
  end
end