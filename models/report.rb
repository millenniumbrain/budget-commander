class Report < Sequel::Model(:reports)
  many_to_one :user
end
