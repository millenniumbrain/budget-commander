Sequel.migration do
  up do
    create_table :users do
      primary_key :id
      Bignum :uid
      String :email, :null => false, :unique => true
      String :password_hash, :null => false
      String :avatar, :default => ''
      String :phone_number
      DateTime :created_at
      DateTime :updated_at
    end
  end

  down do
    drop_table :users
  end
end
