# encoding: UTF-8
class CardDecorator < Draper::Decorator
  delegate_all

  def text_used
  	object.decorator_class.checked.include?(object) ? '已使用' : '未使用'
  end

  def weui_line_though_class
  	object.decorator_class.checked.include?(object) ? 'line-through' : ''
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
