randomdoor() = rand(1:3)

function otherdoor(door)
    if door == 1
        rand((2,3))
    elseif door == 2
        rand((1,3))
    else
        rand((1,2))
    end
end

otherdoor(doorA, doorB) =  6 - doorA - doorB
