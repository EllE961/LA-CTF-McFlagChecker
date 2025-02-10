scoreboard players operation Global yin = Global Param1
scoreboard players operation Global xin = Global Param0
scoreboard players set Global foo 0
scoreboard players set Global f2_scratch0 1
execute if score Global xin matches 1 if score Global yin matches 1 run function chall:line028/execute3
execute if score Global f2_scratch0 matches 1.. if score Global xin matches 1 if score Global yin matches 0 run function chall:line028/else4
execute if score Global f2_scratch0 matches 1.. if score Global xin matches 0 if score Global yin matches 1 run function chall:line028/else5
execute if score Global f2_scratch0 matches 1.. run scoreboard players set Global foo 0
scoreboard players operation Global ReturnValue = Global foo