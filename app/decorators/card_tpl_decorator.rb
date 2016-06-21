class CardTplDecorator < Draper::Decorator
  delegate_all

  def color_state
  	translate = I18n.t("card_tpl.state.#{state}")
    case state
    when 'active'
    	"<span style='color: green'>#{translate}</span>"
    when 'inactive'
    	"<span style='color: red'>#{translate}</span>"	
    when 'paused'
    	"<span style='color: orange'>#{translate}</span>"	
    else
    	''
    end.html_safe
  end

  def indate_text
    if object.fixed?
      "#{I18n.t('indate_type.fixed')}(#{indate_from}~#{indate_to})"
    elsif object.dynamic?
      "#{I18n.t('indate_type.dynamic')}(领取后#{indate_after}天后有效)"
    end
  end
  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

end
