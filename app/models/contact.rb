class Contact < MailForm::Base
  attribute :name,      validate: true
  attribute :email,     validate: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i

  attribute :subject,   validate: true
  attribute :message
  attribute :nickname,  captcha: true

  # Declare the e-mail headers. It accepts anything the mail method
  # in ActionMailer accepts.
  def headers
    {
      subject: "#{subject} - Contato do Site",
      to: 'contato@meucontroledeponto.com.br',
      from: 'info@meucontroledeponto.com.br',
      reply_to: %("#{name}" <#{email}>)
    }
  end
end
