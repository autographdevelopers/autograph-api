class RenameNotesToLessonNotes < ActiveRecord::Migration[5.2]
  def change
    rename_table :notes, :lesson_notes
  end
end
