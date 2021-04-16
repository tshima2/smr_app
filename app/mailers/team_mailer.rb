class TeamMailer < ApplicationMailer
  default from: 'smoothrunning@example.com'

  def delegate_leader_mail(email, name)
    @email = email
    @team_name = name
    mail to: @email, subject: I18n.t('views.messages.delegate_leader')
  end
end
