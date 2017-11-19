class CreateEmployeePrivilegeSets < ActiveRecord::Migration[5.1]
  def change
    create_table :employee_privilege_sets do |t|
      t.references :employee_driving_school, null: false
      t.boolean :can_manage_employees,       null: false, default: false
      t.boolean :can_manage_students,        null: false, default: false
      t.boolean :can_modify_schedules,       null: false, default: false
      t.boolean :is_driving,                 null: false, default: false
      t.boolean :is_owner,                   null: false, default: false

      t.timestamps
    end
  end
end
