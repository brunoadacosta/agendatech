#encoding: utf-8
require 'image_twitter'

class AuthenticationsController < ApplicationController
  def index
    @authentications = current_user.authentications if current_user 
  end

  def create  
    omniauth = request.env["omniauth.auth"] 
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])  
    # user is already registered
    if authentication  
      flash[:notice] = "Signed in successfully."  
      sign_in_and_redirect(:user, authentication.user)  
    elsif current_user  
      current_user.authentications.create(:provider => omniauth['provider'], :uid => omniauth['uid'])  
      flash[:notice] = "Authentication successful."  
      redirect_to authentications_url  
    # new user  
    else  
      # TODO : email must be unique in devise...
      info = omniauth['info']
      user = User.new :email => info['nickname'], :nickname => info['nickname'], :image => info['image'] 
      user.authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
      user.save!       
            
      # download user image
      Plugins.new_image_twitter.download info['nickname']      
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:user, user)
    end    
  end

  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentications_url
  end

  def failure
    flash[:notice] = "Não foi possível autenticar."
    redirect_to root_path
  end  
end
