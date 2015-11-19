require 'twilio-ruby'
require 'sanitize'

class TwilioController < ApplicationController

  include Webhookable
  after_filter :set_header, :except => [:index]
  skip_before_action :verify_authenticity_token

  def index
    if !params[:num].blank?

      if (params[:num] =~ Rails.application.config.phoneRegEx)==nil
        flash.now[:error] = "Please Enter a valid phone number."
      else
        if !params[:time].blank?
          if (params[:time] =~ Rails.application.config.numrange)==nil
            flash.now[:error] = "Please enter a value between 1 and 1000 for delay in minutes"
          else
            flash.now[:notice] = "Call in progress" 
            MakeCallJob.set(wait_until: params[:time].to_i.minutes.from_now).perform_later(params[:num], Rails.application.config.host_url)
          end
        else
          flash.now[:notice] = "Call in progress" 
          MakeCallJob.perform_later(params[:num], Rails.application.config.host_url)
        end
      end
    end
    respond_to do |format|
      format.html
    end
  end

  # POST ivr/welcome
  def ivr_welcome
    response = Twilio::TwiML::Response.new do |r|
      r.Say 'Please enter a number ranging from 1 to 10 digits and end with the pound sign', :voice=> 'alice'
      r.Gather finishOnKey: '#', timeout: 10, action: menu_path do |g|
        r.Play 'http://linode.rabasa.com/cantina.mp3', loop: 3
      end
    end
    render text: response.text
  end

  def menu_selection
    user_selection = params[:Digits].to_i
    @val=""
    if user_selection==0
      @val = "Invalid Selection. Returning to the main menu."
      twiml_say(@val)
    else
      for i in 1..user_selection
        if i%3==0 && i%5==0
          @val=@val+"Fizz Buzz "
        elsif i%3==0
          @val=@val+'Fizz '
        elsif i%5==0
          @val=@val+'Buzz '
        else
          @val=@val+i.to_s+' '
        end
      end
      twiml_say(@val, true)
    end
  end

  private

  def twiml_say(phrase, exit = false)
    response = Twilio::TwiML::Response.new do |r|
      r.Say phrase, voice: 'alice', language: 'en-GB'
      if exit 
        r.Say "Thank you for calling."
        r.Hangup
      else
        r.Redirect welcome_path
      end
    end

    render text: response.text
  end

end