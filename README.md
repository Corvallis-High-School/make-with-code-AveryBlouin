
# BF Interpreter in Lua
This is a simple interpreter for an esoteric language abbreviated BF. I can't write the actual name due to school policy, unfortunately.
The grammar of this language has only eight tokens: +-><[],.
Anything you can write in another language can be written in BF. The test code for this project features a BF interpreter written inside of itself.

## Usage
This interpreter is broken into three separate classes: the lexer, parser, and interpreter. I know this is completely pointless because BF is such a simple language that it can be implemented in x86 in 69 bytes, but I just felt like writing a proper recursive descent parser the way you'd see it in a normal language.
Anyways, the lexer class takes the program you're trying to run in text form, and converts it to tokens. The parser takes a lexer that's already tokenized some code and parses it into an abstract syntax tree. Then, the interpreter takes a parser as it's input and can run its code.
Specifically:
##### Lexxing
```
local LexerClass = require("lexer")
local mylexer = LexerClass.new(MY_PROGRAM_INPUT)
mylexer:lex() -- runs the lexer and converts to tokens
```
##### Parsing
```
local ParserClass = require("parser")
local myparser = ParserClass.new(mylexer)
myparser:parse() -- runs the parser and converts to ast
```
##### Interpreting (running)
```
local InterpreterClass = require("interpreter")
local myinterpreter = ParserClass.new(myparser)
myinterpreter:run() -- runs the program
```
### Console simulator and providing input
Most BF interpreters allow you to provide input after the source code via an exclamation point. My interpreter supports this, so you could do ``+[>,]<[.<] !input text `` and it'd output ``txet tupni``.
However, if you want the user to be able to provide input while the game is running, don't use the exclamation mark, and my console mode simulator will be used. Name is self explanatory, it tries to simulator being in console mode so the user can provide input.
