class RenameEmployeePrivilegeSet < ActiveRecord::Migration[5.1]
  def change
    rename_table :employee_privilege_sets, :employee_privileges
  end
end
