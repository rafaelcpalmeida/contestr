class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.belongs_to :user, index: true
      t.string :title
      t.text :description
      t.datetime :openTime
      t.datetime :closeTime

      t.timestamps
    end
  end
end
