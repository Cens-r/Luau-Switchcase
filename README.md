# LuauSwitchCase 
A basic switch-case module for Roblox Luau!

# Setup
> Setup will probably change in the future to a single command

You can setup the SwitchCase module by requiring the module at the top of your script and unpacking the returned table.  
*`PathToSwitchCase` should be the location where you've installed the SwitchCase module!*  
```lua
local PathToSwitchCase = game:GetService("ReplicatedStorage"):WaitForChild("switchcase")
local switch, case, default = table.unpack(require(PathToSwitchCase))
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
  
  default():
   close(function ()
    print("Invalid X")
   end)
}

-- Prints: X is 2
```

### Multi-Argument Cases
```lua
local x = 2

switch (x) {
 case(1, 2):
  close(function ()
   print("X is either 1 or 2")
  end)
  
 case(3, 4):
  close(function ()
   print("X is either 3 or 4")
  end);
  
  default():
   close(function ()
    print("Invalid X")
   end)
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
  end)
  
  default():
   close(function ()
    print("Invalid X")
   end)
}

-- Prints: X is either 1 or 2
```
