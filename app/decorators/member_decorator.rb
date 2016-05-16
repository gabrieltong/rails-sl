class MemberDecorator < Draper::Decorator
  delegate_all
  
  def text_sex
  	case sex 
  	when 'male'
  		'男'
  	when 'female'
  		'女'
  	else
  		''
  	end  		
  end
end
