class User < ActiveRecord::Base

  def find_by_nickname(database_name, nickname)
    @users = view(database_name, "users/by_nickname", :key => nickname)
    @users.row[0]
  end
end