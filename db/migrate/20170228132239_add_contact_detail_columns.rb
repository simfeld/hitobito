class AddContactDetailColumns < ActiveRecord::Migration
  def change
    add_column :events, :required_contact_details, :string
    add_column :events, :optional_contact_details, :string
  end
end
