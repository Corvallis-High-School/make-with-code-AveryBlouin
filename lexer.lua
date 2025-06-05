local TokenList = require("tokens")

local lexer = {}
lexer.__index = lexer

function lexer:lex()
    local tokens = {}
    for i = 1, #self.input do
        local c = self.input:sub(i,i)
        if TokenList[c] then 
            table.insert(tokens,c)
        end
    end
    self.tokens = tokens

    return tokens
end

function lexer.new(input)
    local self = {input = input}
    return setmetatable(self,lexer)
end

return lexer