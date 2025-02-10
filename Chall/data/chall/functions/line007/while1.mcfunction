scoreboard players operation Global f1_scratch0 = Global x
scoreboard players operation Global f1_scratch0 %= c2 Constant
scoreboard players operation Global Param0 = Global f1_scratch0
scoreboard players operation Global f1_scratch1 = Global y
scoreboard players operation Global f1_scratch1 %= c2 Constant
scoreboard players operation Global Param1 = Global f1_scratch1
function chall:f2
scoreboard players operation Global m = Global bar
scoreboard players operation Global m *= Global ReturnValue
scoreboard players operation Global foobar += Global m
scoreboard players operation Global bar *= c2 Constant
scoreboard players operation Global barfoo /= c2 Constant
scoreboard players operation Global x /= c2 Constant
scoreboard players operation Global y /= c2 Constant
execute if score Global barfoo matches 1.. run function chall:line007/while1