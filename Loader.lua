local Games = {
    ["2862098693"] = "Project%20Delta"
}

local GameId = tostring(game.GameId)

if Games[GameId] then
    Game = Games[GameId]
else
    Game = "Universal"
end

loadstring(game:HttpGet(("https://raw.githubusercontent.com/tatar0071/IonHub/main/Games/%s.lua"):format(Game)))()
