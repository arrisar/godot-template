extends Node


func snake2camel(string:String)->String:
	var result = PoolStringArray()
	var prev_is_underscore = false
	
	for ch in string:
		if ch=='_':
			prev_is_underscore = true
		else:
			if prev_is_underscore:
				result.append(ch.to_upper())
			else:
				result.append(ch)
			prev_is_underscore = false
	
	return result.join('')


func snake2pascal(string:String)->String:
	var result = snake2camel(string)
	result[0] = result[0].to_upper()
	return result



func camel2snake(string:String)->String:
	var result = PoolStringArray()
	
	for ch in string:
		if ch == ch.to_lower():
			result.append(ch)
		else:
			result.append('_'+ch.to_lower())
	
	return result.join('')


func pascal2snake(string:String)->String:
	var result = PoolStringArray()
	
	for ch in string:
		if ch == ch.to_lower():
			result.append(ch)
		else:
			result.append('_'+ch.to_lower())
	
	result[0] = result[0][1]
	return result.join('')
