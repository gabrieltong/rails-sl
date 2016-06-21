# encoding: UTF-8
class CardDecorator < Draper::Decorator
  delegate_all

  def text_used
  	object.decorator_class.checked.include?(object) ? '已使用' : '未使用'
  end

  def weui_line_though_class
  	object.decorator_class.checked.include?(object) ? 'line-through' : ''
  end

  def state_zh
    if acquirable?
      '空闲'
    elsif checked?
      '已核'
    elsif acquired?
      '已领'  
    elsif locked?
      "占用 (#{locked_by_card.try(:title)})"
    elsif expired?
      '作废'
    else
      ''
    end
  end
end
