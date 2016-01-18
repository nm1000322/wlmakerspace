Sequel.migration do
  up do
    create_table(:users) do
      primary_key :id

      String :email
      String :password
      String :firstname
      String :lastname
      Integer :perm
    end
  end

  down do
    drop_table(:users)
  end
end