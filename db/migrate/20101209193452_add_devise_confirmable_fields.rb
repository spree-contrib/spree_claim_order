class AddDeviseConfirmableFields < ActiveRecord::Migration
  def self.up
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :confirmation_token, :string

    User.all.each do |user|
      unless user.email =~ /example.[net|com]/
        user.confirmation_sent_at = user.created_at
        user.save
      end
    end
  end

  def self.down
    remove_column :users, :confirmed_at
    remove_column :users, :confirmation_sent_at
    remove_column :users, :confirmation_token
  end
end
