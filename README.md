# LuauSwitchCase 
A basic switch-case module for Roblox Luau! Matches a given expression value to a case, then executes the case's function. If a case is not found then it will execute the default case if one was provided.   

***Disclaimer: This module is NOT faster than doing if-else statements or using key-function dictionaries!***

# Setup
> Setup will probably change in the future to a single command

You can setup the SwitchCase module by requiring the module at the top of your script and unpacking the returned table.  
*`PathToSwitchCase` should be the location where you've installed the SwitchCase module!*  
```lua
local PathToSwitchCase = game:GetService("ReplicatedStorage"):WaitForChild("SwitchCase")
local switch, case, default = table.unpack(require(PathToSwitchCase))

-- And as of v1.1.0
local switch, case, default = require(PathToSwitchCase)()
```

# Features
- Combine multiple expression checks into a single case (Multi-Argument Cases)
- Chain Cases (Case-to-Case Format)
- Support for both `break` and non-`break` functions.

### Break Functions
Most of the time you want to break from the switch loop when the expression value is matched to a case. This stops the switch statement in its tracks and tells it that nothing else needs to be checked/ran.  
Thats what the `close` function is used for! When the case is matched it lets the switch statement know to run the given function and exit the loop.
```lua
-- Syntax Example
case():
close(function)

-- As of v1.1.0
case():
close(function, args...)
```

### Non-Break Functions
In some cases you might not want to break out of the switch loop when your case is matched. Instead when matched, all cases (until another break function) will run.
That's when you'd use the `open` function, it lets the switch statement know it doesn't need to check cases any longer and to just run each function until it finds a break function.
```lua
-- Syntax Example
case():
open(function)

-- As of v1.1.0
case():
open(function, args...)
```

# Examples
### Single-Argument Cases
```lua
local x = 2

switch (x) {
 case(1):
  close(function ()
   print("X is 1")
  end);
  
 case(2):
  close(function ()
   print("X is 2")
  end);
  
  default:
   close(function ()
    print("Invalid X")
   end);
}

-- Prints: X is 2
```

### Multi-Argument Cases
Note: This is much faster than case-to-case format
```lua
local x = 2

switch (x) {
 case(1, 2):
  close(function ()
   print("X is either 1 or 2")
  end);
  
 case(3, 4):
  close(function ()
   print("X is either 3 or 4")
  end);
  
  default:
   close(function ()
    print("Invalid X")
   end);
}

-- Prints: X is either 1 or 2
```

### Case-to-Case Format
```lua
 local x = 2

switch (x) {
 case(1):
 case(2):
  close(function ()
   print("X is either 1 or 2")
  end);
  
 case(3, 4):
 case(5, 6):
  close(function ()
   print("X is either 3, 4, 5, or 6")
  end);
  
  default:
   close(function ()
    print("Invalid X")
   end);
}

-- Prints: X is either 1 or 2
```
