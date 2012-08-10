class CreateChecks < ActiveRecord::Migration
  def change
    create_table :checks do |t|
      t.string :metric
      t.decimal :warning
      t.decimal :critical
      t.integer :duration
      t.boolean :resolve
      t.boolean :repeat
      t.integer :interval

      t.timestamps
    end
  end
end
