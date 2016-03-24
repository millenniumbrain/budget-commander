Sequel.migration do
  up do
    create_table(:budgets_tags) do
      primary_key :id
      foreign_key :tag_id
      foreign_key :budget_id
    end
  end

  down do
    drop_table(:tags_budgets)
  end
end
