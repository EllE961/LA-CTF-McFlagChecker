scoreboard players operation Global y = Global Param1
scoreboard players operation Global x = Global Param0
scoreboard players set Global foobar 0
scoreboard players set Global bar 1
scoreboard players operation Global Param0 = Global x
scoreboard players operation Global Param1 = Global y
function chall:f3
scoreboard players operation Global barfoo = Global ReturnValue
execute if score Global barfoo matches 1.. run function chall:line007/while1
scoreboard players operation Global ReturnValue = Global foobar