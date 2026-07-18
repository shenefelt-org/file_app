class CreateUploadedFiles < ActiveRecord::Migration[8.1]
  def change
    create_table :uploaded_files do |t|
      t.references :user, null: false, foreign_key: true
      t.string :original_name
      t.string :saved_name

      t.timestamps
    end
  end
end
