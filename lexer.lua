local TokenList = require("tokens")

local lexer = {}
lexer.__index = lexer

function lexer:lex()
    local userinput = ""
    local tokens = {}
    for i = 1, #self.input do
        local c = self.input:sub(i,i)
        if c == "!" then
            userinput = string.sub(self.input,i+1)
            break
        end

        if TokenList[c] then
            table.insert(tokens,c)
        end
    end
    self.tokens = tokens
    self.userinput = userinput
end

function lexer.new(input)
    local self = {input = input}
    return setmetatable(self,lexer)
end

return lexer