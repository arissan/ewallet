module ApplicationHelper

def emf(obj)
	return if obj.errors.blank?

	res= "<ul>"
	obj.errors.full_messages.each do |v|
		res+= "<li>#{v.humanize}</li>"
	end
	res+= "</ul>"
	raw(res)
end

def set_debit(tx_type, amount)
	if(tx_type == 'Transfer' || tx_type == 'Withdrawal')
		amount.round(2)
	else
		'-'
	end
end

def set_credit(tx_type, amount)
	if(tx_type == 'Deposit')
		amount.round(2)
	else
		'-'
	end
end

end
