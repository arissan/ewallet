module ApplicationHelper

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
