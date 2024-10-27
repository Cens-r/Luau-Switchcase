--!strict

local function UniqueType(name: string)
	return setmetatable({name = name}, { __tostring = function (self) return self.name end })
end

local TYPES = table.freeze({
	SWITCH = UniqueType("Switch"),
	CASE = UniqueType("Case")
})
local FLAGS = {
	ImplicitExitBehavior = true, 	-- Determines whether a case exits by default when it ends
}

type CaseCallback<T> = (out: T, arg: any) -> ()

export type Case<T> = {
	__type: any,									-- Object type: CASE
	arguments: {any}, 						-- Array of arguments associated with case
	content: {CaseCallback<T>}, 	-- Content to be ran when case is met
}

local DEFAULT_INDENTIFIER = {}
local function CASE_BEHAVIOR_MODIFIER()
	local method: CaseCallback<any>
	method = function ()
		return method
	end :: any
	return method
end

local EXIT = CASE_BEHAVIOR_MODIFIER()
local PROCEED = CASE_BEHAVIOR_MODIFIER()

type Resolve<T> = (switch: Switch<T>, value: any) -> T
local function ResolveSwitch<T>(switch: Switch<T>, value: any): T
	local out: T = ({} :: any)

	local index: number = switch.__map[value] or switch.__map[DEFAULT_INDENTIFIER]
	if not index then return out end
	
	local complete: boolean
	local size: number = switch.__size
	repeat
		local content = switch.__contents[index]
		if not content then break end

		complete = FLAGS.ImplicitExitBehavior

		for _, callback in content do
			if (callback == EXIT) or (callback == PROCEED) then
				complete = (callback == EXIT)
				break
			end
			callback(out, value)
		end
		index += 1
	until (index > size) or complete

	return out
end

export type Switch<T> = {
	__type: any,											-- Object type: SWITCH
	__size: number,										-- Number of cases in the switch statement
	__contents: {{CaseCallback<T>}}, 	-- Contents are in order case index
	__map: {[any]: number}, 					-- Argument map for O(1) lookups: argument to case index
	resolve: Resolve<T>
}

return table.freeze({
	types = TYPES,
	flags = FLAGS,

	exit = EXIT,
	proceed = PROCEED,

	switch = function <T>(cases: {Case<T>}): Switch<T>
		if (typeof(cases) ~= "table") or (#cases <= 0) then
			error("No valid case list! An array of cases must be provided.")
		end

		local map, contents = {}, {}
		for index, case in cases do
			if typeof(case) ~= "table" or case.__type ~= TYPES.CASE then
				error("List must only contain objects of the case type!")
			end

			if case.arguments ~= DEFAULT_INDENTIFIER then
				for _, argument in case.arguments do
					if map[argument] then
						error("Attempt to pass in duplicate arguments for cases!")
					end
					map[argument] = index
				end
			else
				map[DEFAULT_INDENTIFIER] = index
			end
			contents[index] = case.content
		end

		return {
			__type = TYPES.SWITCH,
			__size = #contents,
			__contents = contents,
			__map = map,
			resolve = ResolveSwitch
		}
	end,
	case = function <T>(...: any)
		local args = {...}
		if #args <= 0 then
			error("You must supply atleast one argument for your case!")
		end
		return function <T>(content: {CaseCallback<T>}): Case<T>
			return {
				__type = TYPES.CASE,
				arguments = args,
				content = content
			}
		end
	end,
	default = function <T>(content: {CaseCallback<T>}): Case<T>
		return {
			__type = TYPES.CASE,
			arguments = DEFAULT_INDENTIFIER,
			content = content 
		}
	end
})
