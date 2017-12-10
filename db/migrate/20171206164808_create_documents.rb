class CreateDocuments < ActiveRecord::Migration[5.1]
  def change
    create_table :documents do |t|
      t.belongs_to :project, index: true
      t.string :filename
      t.string :content_type
      t.column :file_contents, :binary, :limit => 15.megabyte
      t.timestamps
    end
  end
end
