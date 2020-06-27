module ApplicationHelper

def transactions_path(item_id=nil)
	return dashboard_stock_subjects_index_path(item_id: item_id) if stock_signed_in?
	return dashboard_team_subjects_index_path(item_id: item_id) if team_signed_in?
end

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
	if(tx_type == 'Withdrawal')
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
