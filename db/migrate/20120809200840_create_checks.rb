class CreateChecks < ActiveRecord::Migration
  def change
    create_table :checks do |t|
      t.string :metric
      t.decimal :warning
      t.decimal :critical
      t.integer :duration, default: 60
      t.boolean :repeat, default: false
      t.integer :interval, default: 60
      t.text :handlers, default: ['campfire'].to_json
      t.string :state
      t.string :last_value
      t.timestamps
    end
  end
end
