local parser = {}
parser.__index = parser

function parser:get()
    return self.tokens[self.index]
end

function parser:eat()
    local token = self:get()
    self.index = self.index + 1
    return token
end

function parser:delimit(finish,callback)
    local tokens = {}

    while self:get() ~= finish do
        table.insert(tokens,callback(self))
    end
    self:eat()
    return tokens
end

function parser:parseLoop()
    local tokens = self:delimit("]",self.parseOperation)
    return {
        type = "LOOP",
        body = {
            type = "BLOCK",
            body = tokens,
        },
    }
end

function parser:parseOperation()
    local token = self:eat()

    -- elseif chain here because there's only two possible invalid tokens
    if token == "[" then
        token = self:parseLoop()
    elseif token == "]" then
        error("Unexpected end of loop.")
    elseif token == "<EOF>" then
        error("Unexpected end of file.")
    end

    return token
end

function parser:parse()
    local tokens = self:delimit("<EOF>",self.parseOperation)
    return {
        type = "BLOCK",
        body = tokens,
    }
end

function parser.new(tokens)
    local self = {}
    self.tokens = tokens
    self.index = 1
    table.insert(tokens,"<EOF>")

    return setmetatable(self,parser)
end

return parser