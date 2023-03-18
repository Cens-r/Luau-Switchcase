local switch = function(expression)
	return function (cases)
		local casesMatched = 0
		local open, closed = false, false
		
		local defaultFunction
		
		for _, case in cases do
			if closed then
				break
			end
			
			if case.CHECKS and case.OPERATION then
				if open then
					if case.OPERATION == "close" then
						closed = true
						open = false
					end
					
					case.FUNCTION()
					casesMatched += 1
					continue
				end
				
				for _, check in case.CHECKS do
					if check == expression then	
						if case.OPERATION == "close" then
							closed = true
						end
						
						if case.OPERATION == "open" then
							open = true
						end
						
						case.FUNCTION()
						casesMatched += 1
						break
					end
				end
			else
				defaultFunction = case.FUNCTION
			end
		end
		
		if not closed and defaultFunction then
			defaultFunction()
			casesMatched += 1
		end
		return casesMatched
	end
end



local case
case = function (...)
	local args = {...}
	if type(args[1]) == "table" and args[1].type == "case" then
		for index = 2, #args do
			table.insert(args[1].checks, args[index])
		end
		return args[1]
	end

	local newCase = {
		type = "case",
		checks = {...},
		case = case
	}

	function newCase:close(caseFunction)
		return {CHECKS = self.checks, FUNCTION = caseFunction, OPERATION = "close"}
	end

	function newCase:open(caseFunction)
		return {CHECKS = self.checks, FUNCTION = caseFunction, OPERATION = "open"}
	end

	return newCase
end



local default = function ()
	local defaultCase = {
		type = "default"
	}
	function defaultCase:close(defaultFunction)
		return {FUNCTION = defaultFunction}
	end
	
	function defaultCase:open(defaultFunction)
		return {FUNCTION = defaultFunction}
	end
	
	return defaultCase
end

return {switch, case, default}