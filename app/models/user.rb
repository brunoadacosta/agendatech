class User < ActiveRecord::Base
  has_many :authentications
  has_many :gadgets
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :nickname, :image


  #tem alguma diferenca entre criar o scope e o metodo para a busca. No scope nao tava retornando nil...
  module Scopes
    def por_login_social(nick)
      where("nickname = ?", nick).first
    end
  end

  extend Scopes

  def eventos_que_vai_ou_foi
    Evento.joins(:gadgets).where("gadgets.user_id=?", self.id).where("gadgets.tipo=?", Gadget.tipos[:eu_vou][:nome]).ordenado_por_data
  end

  #refatorar essa parte para uma classe gadgets
  def tem_gadget? evento,tipo
    Gadget.where(:evento_id => evento.id, :user_id => self.id, :tipo => tipo.upcase).exists?
  end
  
  def gadget_para evento,tipo
    Gadget.where(:evento_id => evento.id, :user_id => self.id, :tipo => tipo.upcase).first
  end

end
