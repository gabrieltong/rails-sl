# encoding: UTF-8
class CardDecorator < Draper::Decorator
  delegate_all

  def text_used
  	object.decorator_class.checked.include?(object) ? '已使用' : '未使用'
  end

  def weui_line_though_class
  	object.decorator_class.checked.include?(object) ? 'line-through' : ''
  end
end
