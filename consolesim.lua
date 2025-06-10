local function cls()
    if os.execute("cls") then return end
    os.execute("clear")
end

local console = {}
console.__index = console

function console:render()
    cls()
    io.write(self.text)
end

function console:readchar()
    local char = table.remove(self.buffer,1)
    if char then return char end

    local read = io.read("*l")
    if read == "" or read == nil then read = "\0" end

    self.text = self.text.. read
    for c in string.gmatch(read,".") do
        table.insert(self.buffer,c)
    end

    self:render()

    return table.remove(self.buffer,1)
end

function console:display(txt)
    self.text = self.text.. txt
    io.write(txt)
end

function console:addText(txt)
    self.text = self.text.. txt
end

function console:addUserInput(input)
    for c in string.gmatch(input,".") do
        table.insert(self.buffer,c)
    end
end

function console.new(input)
    input = input or ""
    local self = setmetatable({},console)

    self.text = "Console mode simulator\nReturn must be pressed after typing a character (can't do anything about that),\nleaving empty will result in a null character.\nInputting extra characters will add them to a buffer.\n\n"
    self.buffer = {}

    self.text = self.text.. input
    self:addUserInput(input)

    self:render()

    return self
end

return console