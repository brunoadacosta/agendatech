class EventosController < ApplicationController
  uses_tiny_mce :only => [:new,:create]

  def index
    if params[:month]
      @eventos = Evento.por_mes(numero_do_mes(params[:month])).top_gadgets
    else
      if params[:estado]
        @eventos = Evento.por_estado(estados.index(params[:estado])).top_gadgets
      else
        @eventos = Evento.que_ainda_vao_rolar
      end
    end    
  end
  
  def cursos
    @eventos = Evento.que_ainda_vao_rolar(TipoEvento::CURSO)
    render :action => 'index'
  end

  def new
    @evento = Evento.new
  end

  def create
    @evento = Evento.new(params[:evento])
    @evento.aprovado = false
    unless @evento.data_termino?
      @evento.data_termino = @evento.data
    end
    if @evento.save
      flash[:aguarde] = "Obrigado! Seu evento aparecerá na lista em instantes!"
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end

  def show
    @evento = Evento.find_by_cached_slug(params[:id])
    @comentario = Comentario.new
  end

  def tag
    @eventos = Evento.find_tagged_with(params[:id], :order => "data DESC")
    @tag = params[:id]
    render :action => "index"
  end

  def comentar
    @comentario = Comentario.new(params[:comentario])
    @comentario.twitter = current_user.nickname
    if @comentario.save
      flash[:comentario] = "Comentário cadastrado com sucesso!"      
      @evento = Evento.find_by_cached_slug(params[:evento_nome])
      redirect_to evento_path(:ano => @evento.data.year,:id=>@evento)
    else
      render :action => "new"
    end
  end
  
  def lista
    @participantes = []
    evento = Evento.find_by_cached_slug(params[:id])
    evento.gadgets.each do |g|
      begin
        @participantes << User.find(g.user_id).nickname
      rescue
        @participantes << "Twitter nao encontrado => #{g.user_id}"
      end
    end
  end
  
  def facebook
    # testing facebook app
  end

end
