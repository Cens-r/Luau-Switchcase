# Luau Switchcase
A basic switchcase module for Luau, with reusability at the core of its design.
Due to design choice, it succeeds where a lot of other switchcase implementations fail, making it potentially viable for use in specific contexts.

# Usage
```luau
-- Require the module:
local S = require(PATH.TO.MODULE)

-- For readability sake:
local switch, case, default, proceed = S.switch, S.case, S.default, S.proceed
type Switch<T> = S.Switch<T>

type output = {result: string}
local function GenerateOutput(result: string)
  return function (out: output)
    out.result = result
  end
end

-- Create your switchcase statement
local statement: Switch<output> = switch {
  case(1, 2, 3) {
    GenerateOutput("Low"),
    proceed
  };
  case(4, 5, 6) {
    GenerateOutput("Medium")
  };
  case(7, 8, 9) {
    GenerateOutput("High"),
    function (out: output, arg: number)
      if arg < 9 then return end
      out.result = "Very High"
    end
  };
  default {
    GenerateOutput("None")
  };
}

-- Use your statement:
local out: output

out = statement:resolve(1)
print(out.result) -- Expected: "Medium" (due to pass-through)

out = statement:resolve(4)
print(out.result) -- Expected: "Medium"

out = statement:resolve(9)
print(out.result) -- Expected: "Very High"

out = statement:resolve(0)
print(out.result) -- Expected: "None"
```

# Benchmarking
When focusing on the reusability of switchcases using this module, they perform significantly better due to structure reuse.

![image](https://github.com/user-attachments/assets/47b10ae8-cf9f-40f5-803e-3907fb04c847)
```luau
--[[
This file is for use by Benchmarker (https://boatbomber.itch.io/benchmarker)

|WARNING| THIS RUNS IN YOUR REAL ENVIRONMENT. |WARNING|
--]]

local o_switch, o_case, o_default = require(game.ServerStorage.SwitchCase_OLD)()

local S = require(game.ServerStorage.SwitchCase_NEW)
local n_switch, n_case, n_default, n_proceed = S.switch, S.case, S.default, S.proceed

local VALUE = 5
local COUNT = 100

local function PASS() return end
return {
	Functions = {
		-- Version 1.1.0
		["OLD"] = function(Profiler)
			for i = 1, COUNT do
				o_switch (VALUE) {
					o_case(1, 2, 3):close(PASS);
					o_case(4, 5, 6):close(PASS);
					o_case(7, 8, 9):close(PASS);
					o_default:close(PASS);
				}
			end
		end,
		
		-- Version: 2.1.0
		["NEW"] = function(Profiler)
			local statement = n_switch {
				n_case(1, 2, 3) { PASS };
				n_case(4, 5, 6) { PASS };
				n_case(7, 8, 9) { PASS };
				n_default { PASS };
			}
			for i = 1, COUNT do
				statement:resolve(VALUE)
			end
		end,
	},
}
```
