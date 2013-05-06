# -*- coding: utf-8 -*-
class UserMailer < ActionMailer::Base
  default from: "qinfanpeng@gmail.com"

  def get_password(email, random_password, url)
    @random_password = random_password
    @url = url
    mail(to: email, subject: '找回密码')
  end
end
