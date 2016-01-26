# LLCalculatorBrain
This is a little stuff that be used to figure out string equation.

## Installation
Just move LLCalculatorBrain.swift to your project.

## Usage
You can see example by downloading Example.zip
```
let calculatorBrain = LLCalculatorBrain()

let equation1 = "1+1*(2*3/(2-1)^2.5)-4.43" // Or something like this
let result1 = calculatorBrain.calculateThisEquation(equation1)
```
### Error Code
* Error 1: Divide by zero
* Error 2: Wrong equation

## TO DO
* sin, cos and tan
* sqrt
* More Error Catch
