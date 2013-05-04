module UsersHelper
  def has_email?
    !current_user.email.nil?
  end

  def self?(user)
    current_user == user
  end

end
