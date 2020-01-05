GM.Name = "Demon Hunters"
GM.Author = "Prize"
GM.Email = "contact.petersonac@gmail.com"
GM.Website = "N/A"

// Shuffle lists
function shuffle(array)
    -- fisher-yates
    local output = { }
    local random = math.random

    for index = 1, #array do
        local offset = index - 1
        local value = array[index]
        local randomIndex = offset*random()
        local flooredIndex = randomIndex - randomIndex%1

        if flooredIndex == offset then
            output[#output + 1] = value
        else
            output[#output + 1] = output[flooredIndex + 1]
            output[flooredIndex + 1] = value
        end
    end

    return output
end