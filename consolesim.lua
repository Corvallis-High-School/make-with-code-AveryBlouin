local function cls()
    if os.execute("cls") then return end
    os.execute("clear")
end

local console = {}
console.__index = console

function console:readchar()
    local char = table.remove(self.buffer,1)
    if char then return char end

    local read = io.read("*l")
    if read == "" then read = "\0" end

    self.text = self.text.. read

    for c in string.gmatch(read,".") do
        table.insert(self.buffer,c)
    end

    cls()
    io.write(self.text)

    return table.remove(self.buffer,1)
end

function console:display(txt)
    self.text = self.text.. txt
    io.write(txt)
end

function console.new()
    local self = {}

    self.text = "Console mode simulator\nReturn must be pressed after typing a character (can't do anything about that),\nleaving empty will result in a null character.\nInputting extra characters will add them to a buffer.\n\n"
    self.buffer = {}

    cls()
    io.write(self.text)

    return setmetatable(self,console)
end

return console