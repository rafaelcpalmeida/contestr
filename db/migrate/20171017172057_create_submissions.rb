class CreateSubmissions < ActiveRecord::Migration[5.1]
  def change
    create_table :submissions do |t|
      t.belongs_to :user, index: true
      t.belongs_to :project, index: true
      t.string :projectKey
      t.string :title
      t.string :overallResult

      t.timestamps
    end
  end
end
