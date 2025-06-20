local ConsolesimClass = require("consolesim")

local interpreter = {}
interpreter.__index = interpreter

local interpreters = {
    BLOCK = function(self,node)
        for i,v in ipairs(node.body) do
            self:interpretNode(v)
        end
    end,
    LOOP = function(self,node)
        while self.membuff[self.position] > 0 do
            self:interpretNode(node.body)
        end
    end,
    RIGHT = function(self,node)
        self.position = self.position + 1
        if self.position > self.highestpos then
            self.highestpos = self.position
        end
    end,
    LEFT = function(self,node)
        self.position = self.position - 1
        if self.position < self.lowestpos then
            self.lowestpos = self.position
        end
    end,
    INCREASE = function(self,node)
        self.membuff[self.position] = self.membuff[self.position] + 1
    end,
    DECREASE = function(self,node)
        self.membuff[self.position] = self.membuff[self.position] - 1
    end,
    GETCHAR = function(self,node)
        local char = self.consolesim:readchar()
        self.membuff[self.position] = string.byte(char)
    end,
    PUTCHAR = function(self,node)
        self.consolesim:display(string.char(self.membuff[self.position]))
    end,
}

function interpreter:interpretNode(node)
    local handler = interpreters[node.type]
    if handler == nil then error(string.format("Unexpected node '%s'",node.type)) end

    return handler(self,node)
end

function interpreter:run()
    assert(self.parser,"Must provide a parser to the interpreter")
    assert(self.parser.ast,"Parser must have parsed something before it can be interpretered.")

    self.ast = self.parser.ast
    self.userinput = self.parser.userinput
    if #self.userinput > 0 and string.sub(self.userinput, #self.userinput) ~= "\0" then
        self.userinput = self.userinput.."\0"
    end

    if not self.initialized then
        self:initialize()
    end

    self.consolesim:addUserInput(self.userinput)
    return self:interpretNode(self.ast)
end

function interpreter:resetMemory()
    self.membuff = setmetatable({},{__index = function() return 0 end})
    self.highestpos = 1
    self.lowestpos = 1

    self.position = 1

    if self.consolesim then self.consolesim.buffer = {} end
end

function interpreter:initialize()
    self:resetMemory()
    self.consolesim = ConsolesimClass.new()
    
    self.initialized = true
end

function interpreter:setParser(parser)
    self.parser = parser
end

function interpreter.new(parser)
    local self = {}
    self.parser = parser

    return setmetatable(self,interpreter)
end

return interpreter