scoreboard players operation Global y = Global Param1
scoreboard players operation Global x = Global Param0
scoreboard players set Global f3_scratch0 1
execute if score Global x > Global y run function chall:line019/execute2
execute if score Global f3_scratch0 matches 1.. run scoreboard players operation Global ReturnValue = Global y