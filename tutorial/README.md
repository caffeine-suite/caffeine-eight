# CaffeineEight Tutorial
### How to Write a Turing Complete Language in 50 Minutes

> by Shane Brinkman-Davis
in association with GenUI.co, Imikimi.com

### Tutorial Setup

Install NodeJS.org if you haven't already.

Otherwise, you can copy and run these commands to get set up:
```shell
mkdir tutorial
cd tutorial

echo "{}" > package.json
npm install caffeine-eight

echo "console.log :hello" > Turing.caf
npx caf Turing.caf
# > hello
```

If you want to jump to the end and just try the language:
```shell
git clone https://github.com/caffeine-suite/caffeine-eight.git
cd caffeine-eight
npm install
cd tutorial

npx caf TuringRepl.caf
# Turing>
# (Control-D to exit)

npx caf TuringTest.caf
# store:
#   0:        0
#   1:        1
#   2:        2
#   3:        3
#   4:        0
#   5:        5
# ...
```


### Tools

[CaffeineEight](https://github.com/caffeine-suite/caffeine-eight) is the parser tool used in this demo. It helps you build parsers using [Parsing Expressing Grammars](https://en.wikipedia.org/wiki/Parsing_expression_grammar).

[CaffeineScript](http://CaffeineScript.com) is the language used for this tutorial
* just JavaScript
* with 3x less code
* (could write this whole tutorial in plain JavaScript)
* built on top of CaffeineEight

![](https://raw.githubusercontent.com/wiki/shanebdavis/caffeine-script/CaffeineScriptLogo.png)


# Background

### Turing Complete Langauge

* Computationally Universal
* Proof: Can emulate a Turing machine

  ANY Turing Complete language can perform
  ANY computation

### Turing Machine

![turing machine](https://upload.wikimedia.org/wikipedia/commons/0/03/Turing_Machine_Model_Davey_2012.jpg)
> wikipedia.org/wiki/Turing_machine

##### Data
```
memory        (ARRAY<INTEGER> - infinite!)
location      (INTEGER)
currentState  (INTEGER)
```
##### Finite State Machine
```
states:       (ARRAY<STATE> - finite)

STATE:
  value:      (INTEGER)          value-to-write
  delta:      (-1 or 1)          location-delta
  nextStates: (INTEGER: INTEGER) labeled next-states
```
##### Runtime
```javascript
while 1
  write currentState.value
  location += currentState.value

  _currentValue = memory[location]
  _nextState = currentState.nextStates[_currentValue]
  currentState = states[_nextState]
```

### Turing Complete Languages

* JavaScript
* Java
* Ruby
* C/C++
* Lisp/Scheme
* Go
* Erlang/Elixer

### NOT Turing Complete Languages

* CSS
* HTML
* XML
* JSON

# Bottom Line
### Turing Complete Requirements

1. effectively unbounded memory
1. conditional execution
1. unbounded iteration

# Start the Clock