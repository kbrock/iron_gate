class IronGate::GateController < ApplicationController

  unloadable

  skip_before_filter :deny_not_nice

  def index
    nice=params[:nice]=='true'
    make_nice(nice)
    flash[:notice]="you should #{nice ? 'now' : 'not'} see the site"
    redirect_to '/' 
  end
  
  def open
    params[:nice]='true'
    index
  end
  
  def close
    params[:nice]='false'
    index
  end

  private

  def make_nice(val='true')
    val='false' if val==false
    val='true'  if val==true
    #TODO: make the cookie persistant
    #TODO: could add ip address, or something to make more secure
    cookies['nice']=val
    logger.info("set cookie to #{val}")
  end
end
