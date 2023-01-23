class CreateHashtagQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :hashtag_questions do |t|
      t.references :hashtag, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
