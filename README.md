# LA-CTF-McFlagChecker

**rev/McFlagChecker** – a reverse engineering challenge from LC CTF. In this challenge, you are provided with a Minecraft datapack that implements an obfuscated flag-checking routine. Your goal is to reverse the datapack’s transformations in order to recover the correct flag input.

---

## Overview

The datapack performs a series of nontrivial mathematical and bitwise operations on a 40-element register array. During its forward pass, the datapack applies multiple transformations, including arithmetic operations, bitwise XOR operations, modular exponentiation, and finally a modular matrix multiplication. The final output is then compared against a target set of registers. Your challenge is to reverse these operations to determine the original input that produces the given output.

---

## Challenge Details

### Datapack Workflow

1. **Input Registers:**  
   The challenge begins with an array of 40 numbers that encode the flag (typically represented as ASCII values). These numbers, when interpreted as characters, form the flag string (for example, something that might start with "lactf{...}") and by default it is [0] *40.

2. **Forward Transformations:**  
   The datapack applies several layers of transformations:
   
   - **Linear Congruential Transformation:**  
     A variable is repeatedly transformed by multiplying by 97, adding 129, and then taking the result modulo 256. This process is used to generate dynamic values for subsequent operations.
   
   - **Bitwise XOR Operation:**  
     Each register value is combined with a dynamically generated value using a bitwise XOR. This operation is performed bit-by-bit, ensuring that the transformation is nontrivial to reverse.
   
   - **Modular Exponentiation:**  
     After the XOR, each value is transformed by raising a fixed base (6) to the power of the current value, with the result taken modulo 251. This step further obscures the relationship between the input and the output.
   
   - **Modular Matrix Multiplication:**  
     Finally, the datapack mixes the register values by multiplying them with a 40×40 matrix (3D array but we can drop y value since it all Zeros) that can be found in reset.mcfunction:
```
data merge block 0 0 0 {RecordItem:{id:"minecraft:stone",Count:1b,tag:{Storage: 22}}}
data merge block 0 0 1 {RecordItem:{id:"minecraft:stone",Count:1b,tag:{Storage: 31}}}
data merge block 0 0 2 {RecordItem:{id:"minecraft:stone",Count:1b,tag:{Storage: 224}}}
data merge block 0 0 3 {RecordItem:{id:"minecraft:stone",Count:1b,tag:{Storage: 191}}}
data merge block 0 0 4 {RecordItem:{id:"minecraft:stone",Count:1b,tag:{Storage: 160}}}
data merge block 0 0 5 {RecordItem:{id:"minecraft:stone",Count:1b,tag:{Storage: 143}}}
data merge block 0 0 6 {RecordItem:{id:"minecraft:stone",Count:1b,tag:{Storage: 101}}}
data merge block 0 0 7 {RecordItem:{id:"minecraft:stone",Count:1b,tag:{Storage: 173}}}
data merge block 0 0 8 {RecordItem:{id:"minecraft:stone",Count:1b,tag:{Storage: 255}}}
data merge block 0 0 9 {RecordItem:{id:"minecraft:stone",Count:1b,tag:{Storage: 239}}}
data merge block 0 0 10 {RecordItem:{id:"minecraft:stone",Count:1b,tag:{Storage: 140}}}
data merge block 0 0 11 {RecordItem:{id:"minecraft:stone",Count:1b,tag:{Storage: 63}}}
data merge block 0 0 12 {RecordItem:{id:"minecraft:stone",Count:1b,tag:{Storage: 139}}}
data merge block 0 0 13 {RecordItem:{id:"minecraft:stone",Count:1b,tag:{Storage: 17}}}
data merge block 0 0 14 {RecordItem:{id:"minecraft:stone",Count:1b,tag:{Storage: 22}}}
data merge block 0 0 15 {RecordItem:{id:"minecraft:stone",Count:1b,tag:{Storage: 206}}}
etc..
```
  referred to as the block data that spawn in the game in same index location:
![Blocks that contain the data](img/blockData.png)

 This final transformation diffuses the information across all 40 registers.

3. **Output Comparison:**  
   The resulting registers are compared against a predetermined target array that can be found at the end of check_flag.mcfunction:
```
execute unless score Global Reg0 matches 137 run scoreboard players set Global var4 0
execute unless score Global Reg1 matches 193 run scoreboard players set Global var4 0
execute unless score Global Reg2 matches 59 run scoreboard players set Global var4 0
execute unless score Global Reg3 matches 168 run scoreboard players set Global var4 0
execute unless score Global Reg4 matches 164 run scoreboard players set Global var4 0
execute unless score Global Reg5 matches 129 run scoreboard players set Global var4 0
etc..
```
   To solve the challenge, you must reverse these operations to determine the original input that yields the target output.

---

## Provided Code Explanation

The challenge comes with two conceptual components: the backward pass (the reversal process) and the forward pass (the original datapack logic). Below is an explanation of these components without including any actual code.

### 1. Forward Pass (Original Datapack Functions but in py)

The forward pass comprises several functions that carry out the following operations:

- **Value Transformation (Linear Congruential Generator):**  
  A function multiplies an input value by 97, adds 129, and takes the result modulo 256. This produces a dynamically changing value that is used in subsequent operations.

- **Bitwise XOR Operation:**  
  The datapack uses a dedicated routine to compute the bitwise XOR of two numbers on a bit-by-bit basis. This routine essentially iterates through each bit of the two input numbers and reconstructs the result of the XOR.

- **Modular Exponentiation:**  
  Another function computes the modular exponentiation of 6 raised to the power of a given value, with the result taken modulo 251. This operation significantly alters the distribution of values in the register array.

- **Modular Matrix Multiplication:**  
  Finally, a matrix multiplication is performed where the 40-element register array is multiplied by a 40×40 matrix (the block data), with all operations performed modulo 251. This step mixes all the register values together.

The forward pass processes the original register array (which encodes the flag) through these steps, ultimately producing a set of registers that are compared to a target. Your task is to reverse these steps to recover the original flag.

### 2. Backward Pass (Reversal Process)

The backward pass involves undoing each step of the forward transformations:

- **Matrix Inversion:**  
  The final step of the forward pass is a modular matrix multiplication using a 40×40 matrix. To reverse this, the matrix is inverted modulo 251. Multiplying the target output by this inverted matrix recovers an intermediate vector.

- **Reversing Modular Exponentiation:**  
  Since the forward pass applied modular exponentiation with base 6 (i.e., computing 6 raised to some power modulo 251), the reversal requires solving the discrete logarithm problem. In other words, for each element of the intermediate vector, you must determine the exponent that produces that element when 6 is raised to it modulo 251.

- **XOR Mask Reversal:**  
  Prior to the exponentiation, the forward pass applied a bitwise XOR between each register value and a mask. This mask is generated through a linear congruential process (multiplying by 97, adding 129, modulo 256). By regenerating this mask, you can XOR the recovered values to obtain the original register values.

The end result of the backward pass is the recovery of the original 40-element register array, which can be converted into the flag string.

---

## How to Approach the Challenge

1. **Analyze the Datapack:**  
   Begin by converting the Minecraft datapack’s `.mcfunction` files (Minecraft assembly) like this:
```
scoreboard players operation Global y = Global Param1
scoreboard players operation Global x = Global Param0
scoreboard players set Global f3_scratch0 1
execute if score Global x > Global y run function chall:line019/execute2
execute if score Global f3_scratch0 matches 1.. run scoreboard players operation Global ReturnValue = Global y
```
 into a more readable format (for example, by rewriting them in a high-level language). This will help you understand the sequence and nature of the transformations.

2. **Reconstruct the Forward Pass:**  
   Carefully simulate the forward pass by following each transformation step. Understanding how the original flag is processed is crucial for devising a reversal strategy.

3. **Implement the Backward Pass:**  
   Reverse each transformation in the exact opposite order of the forward pass:
   - Start by undoing the matrix multiplication using modular matrix inversion.
   - Next, reverse the modular exponentiation by solving the discrete logarithm problem.
   - Finally, regenerate and apply the XOR mask to recover the original register values.

4. **Recover the Flag:**  
   Once you have the original register array, convert the ASCII values into characters to reveal the flag.

---

# Final Answer

After successfully reversing the transformations applied by the Minecraft datapack, we recover the original register values:

**Recovered input registers (Decimal values):**
```
[108, 97, 99, 116, 102, 123, 121, 52, 89, 95, 116, 104, 49, 115, 95, 102, 108, 52, 103, 95, 103, 49, 118, 51, 115, 95, 121, 48, 117, 95, 52, 95, 100, 49, 52, 109, 48, 110, 100, 125]
```

**Converting the Decimal values to ASCII characters:**
```
lactf{y4Y_th1s_fl4g_g1v3s_y0u_4_d14m0nd}
```
This confirms that our backward pass correctly reconstructed the original flag used as input to the datapack.

---

# Useful Commands for the Challenge

During the challenge, you can use the following Minecraft commands to interact with the datapack and test different inputs:

### **Core Commands**
- **Check the flag:**  
  Use `/function chall:check_flag` to run the flag-checking function in the datapack.

- **Reset the challenge state:**  
  Use `/function chall:reset` to reset the challenge, useful if something goes wrong.

- **Reload the datapack:**  
  Use `/reload` to reload the Minecraft world’s datapacks if you change the datapack code.

### **Custom Testing Commands**
- **Set a custom flag input for testing:**  
  Use `/function chall:setter` to manually test a custom flag input (change the regs values in setter.mcfunction).

### **Scoreboard Debugging Commands**
- **Retrieve the value of a specific register (e.g., reg0):**  
  Use `/scoreboard players get Global reg0` to print the current value stored in `reg0`.

- **Manually set a register value (e.g., reg0 to 100):**  
  Use `/scoreboard players set Global reg0 100` to set `reg0` to 100 for debugging purposes.

