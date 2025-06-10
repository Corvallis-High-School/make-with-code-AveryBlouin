local LexerClass = require("lexer")
local ParserClass = require("parser")
local InterpreterClass = require("interpreter")

local lexer = LexerClass.new(program)
local parser = ParserClass.new(lexer)
local interpreter = InterpreterClass.new(parser)
interpreter:initialize()

while true do
    io.write("\n> ")
    local inp = io.read("*l")
    if inp == "dbg" then
        print(string.format("Located at [%s]",interpreter.position))
        for i = interpreter.lowestpos, interpreter.highestpos do
            local s = string.format("[%s]: %s",tostring(i),tostring(interpreter.membuff[i]))
            if i == interpreter.position then
                s = "> ".. s
            end
            print(s)
        end
    elseif inp == "clrmem" then
        interpreter:resetMemory()
        print("Memory cleared.")
    else
        lexer:setInput(inp)
        if interpreter.consolesim then
            interpreter.consolesim:addText("\n> "..inp.."\n")
            interpreter.consolesim:render()
        end
        
        lexer:lex()
        parser:parse()
        interpreter:run()
    end
end