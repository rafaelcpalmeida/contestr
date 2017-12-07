class CreateEvaluations < ActiveRecord::Migration[5.1]
  def change
    create_table :evaluations do |t|
      t.belongs_to :project, index: true
      t.belongs_to :user, index: true
      t.string :maintainability
      t.string :security
      t.string :reliability
      t.string :releasability
      t.string :language
      t.string :build_result
      t.string :run_result
      t.string :execution_time
      t.string :execution_memory
      t.timestamps
    end
  end
end
