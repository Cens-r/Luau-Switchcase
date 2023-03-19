local switch = function (expression)
	return function (cases)
		local defaultFunction
		local open, closed = false, false

		for _, case in cases do
			if open then
				case.FUNCTION()
				continue
			end

			local caseType = case["TYPE"]
			local caseChecks = case["CHECKS"]
			local operation = case["OPERATION"]

			if caseType == "default" then
				defaultFunction = case.FUNCTION
				continue
			end

			if caseChecks and caseType == "case" then
				for _, check in caseChecks do
					if check == expression then
						if operation == "close" then
							closed = true
						elseif operation == "open" then
							open = true
						end

						case.FUNCTION()
						break
					end
				end
			end
		end

		if not closed and defaultFunction then
			defaultFunction()
		end
	end
end

local function closeOperation(self, caseFunction)
	return {TYPE = self["type"], CHECKS = self["checks"], FUNCTION = caseFunction, OPERATION = "open"}
end

local function openOperation(self, caseFunction)
	return {TYPE = self["type"], CHECKS = self["checks"], FUNCTION = caseFunction, OPERATION = "open"}
end

local case
case = function (...)
	local args = {...}
	local pcase = args[1] -- Potential case object

	if type(pcase) == "table" and pcase["type"] == "case" then
		local checkLength = #pcase.checks
		for index = 2, #args do
			checkLength += 1
			pcase[checkLength] = args[index]
		end
		return pcase
	end

	return {
		-- Case Properties
		type = "case",
		checks = args,

		-- Case Functions
		case = case,
		close = closeOperation,
		open = openOperation
	}
end

local default = {
	type = "default",
	close = closeOperation,
	open = openOperation
}

return {switch, case, default}