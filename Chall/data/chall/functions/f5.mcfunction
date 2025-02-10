scoreboard players operation Global c = Global Param2
scoreboard players operation Global b = Global Param1
scoreboard players operation Global a = Global Param0
scoreboard players set Global d 1
scoreboard players set Global i 1
execute if score Global i <= Global b run function chall:line049/for006
scoreboard players operation Global ReturnValue = Global d