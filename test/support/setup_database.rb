require "active_record"

ActiveRecord::Base.configurations = {'test' => {adapter: 'sqlite3', database: ':memory:'}}
ActiveRecord::Base.establish_connection :test

class CreateAllTables < ActiveRecord::Migration
  def self.up
    create_table(:teams) do |t|
      t.string :name
    end

    create_table(:users) do |t|
      t.integer :team_id
      t.string :first_name
      t.string :last_name
    end

    create_table(:comments) do |t|
      t.integer :user_id
      t.string :body
    end

    create_table(:reactions) do |t|
      t.integer :user_id
      t.integer :comment_id
    end
  end
end

ActiveRecord::Migration.verbose = false
CreateAllTables.up
