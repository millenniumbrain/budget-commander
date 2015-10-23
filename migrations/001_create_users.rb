Sequel.migration do
  up do
    create_table :users do
      primary_key :id
      String :email, :null => false
      String :name, :length => 20, :null => false, :unique => true
      String :password_hash
      String :avatar, :default => ''
      DateTime :created_at
      DateTime :updated_at
    end
  end

  down do
    drop_table :users
  end
end
