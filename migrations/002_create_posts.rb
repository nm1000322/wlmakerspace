Sequel.migration do
  up do
    create_table(:posts) do
      primary_key :id

      String :title
      String :url
      String :content
      Time :date
      String :type


    end
  end

  down do
    drop_table(:posts)
  end
end