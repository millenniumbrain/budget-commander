Sequel.migration do
  up do
    create_table :users do
      primary_key :id
      String :_id, :null => false
      String :email, :null => false, :unique => true
      String :password_hash, :null => false
      String :avatar, :default => ''
      String :phone_number
      String :access_token, :unique => true
      String :twilio_client_token, :unique => true
      DateTime :created_at
      DateTime :updated_at
    end
  end

  down do
    drop_table :users
  end
end
