Config = {}

Config.Elevators = {
    MissionRow = {
        -- locked = true, -- disables the whole elevator
        {
            display = "2 | Dach",
            coords = vector3(473.3159, -983.5985, 43.6923),
        },
        {
            display = "1 | Verwaltung",
            coords = vector3(473.3159, -983.5985, 35.6838),
        },
        {
            display = "0 | Erdgeschoss",
            coords = vector3(473.3159, -983.5985, 30.7104),
            allowedJobs = { 'police' }, -- who can enter the elevator on this floor
        },
        {
            display = "-1 | Zellen / Garage",
            coords = vector3(473.3159, -983.5985, 26.3918),
            -- exitJobs = { 'police' }, -- who can travel to this floor
        },
    }
}