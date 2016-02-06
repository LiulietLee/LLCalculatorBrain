# LLCalculatorBrain
This is a little stuff that be used to figure out string equation.

## Installation
Just move LLCalculatorBrain.swift to your project.

## Usage
You can see example by downloading Example.zip
```
let calculatorBrain = LLCalculatorBrain()

let equation = "tan(2*3^(3+2-3.123)/12.2)+sin(1)+cos(2)" // Or something like this
let result = calculatorBrain.calculateThisEquation(equation) // result = 3.87854961240333
```
There MUST BE a "(" behind sin, cos and tan.

### Error Code
* Error 1: Divide by zero
* Error 2: Wrong equation

## TO DO
* sqrt
* More Error Catch
