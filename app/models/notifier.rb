class Notifier < ActionMailer::Base

  default :from => "contato@agendatech.com.br"

  def envia_email (contato)

    mail( :subject => "Contato agendatech",
          :to =>  ["andersonlfl@gmail.com", "alots.ssa@gmail.com"]
        )
    @contato = contato
    
  end

end
