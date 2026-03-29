# snov_elevators

Configurable elevator system for FiveM. Allows players to teleport between predefined floors using a context menu. Supports job-based access restrictions per elevator.

## Features

- Unlimited configurable elevators with multiple floors each
- Context menu floor selection via ox_lib
- Optional job restrictions per elevator
- Keybind interaction (default: E)
- Screen fade transition between floors
- Automatic version check

## Dependencies

- [ox_lib](https://github.com/overextended/ox_lib)
- [es_extended (ESX)](https://github.com/esx-framework/esx_core)

## Installation

1. Place `snov_elevators` in your resources folder.
2. Add `ensure snov_elevators` to your `server.cfg`.
3. Configure your elevators in `config.lua`.

## Configuration

Edit `config.lua` to define elevators. Each elevator is a named table containing floor entries with display name, coordinates, and optional job restrictions.

```lua
Config.Elevators = {
    MyElevator = {
        {
            display = "Floor 2",
            coords = vector3(x, y, z),
        },
        {
            display = "Floor 1",
            coords = vector3(x, y, z),
            allowedJobs = { 'police' }, -- optional
        },
    }
}
```
