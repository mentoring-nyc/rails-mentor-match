class RemoveChallengesModel < ActiveRecord::Migration
  def change
    drop_table :challenges
  end
end
