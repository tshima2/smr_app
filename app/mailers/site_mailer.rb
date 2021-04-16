class SiteMailer < ApplicationMailer
  default from: 'smoothrunning@example.com'

  def destroy_mail(emails, name)
    @site_name = name
    emails.each do |email|
      mail(to: email,subject: I18n.t('views.messages.delete_site'))
    end
  end
end
