|![Empty Image](docs/empty.png)|![Minecraft IDE](MinecraftIDE.png)|![Empty Image](docs/empty.png)|
|-|-|-|

[中文(简体)](docs/README.zh-CN.md) [Homepage](.)

# Minecraft IDE
### Edit files just like playing minecraft
\(Cannot save as a save yet\)

## Installation
This project can only be runned on Linux
```sh
git clone https://github.com/RedstoneOre/MinecraftIDE.git

```

## Usage
```sh
cd MinecraftIDE
./mcide <file>
```
See [arguments](docs/arguments/en_US.txt) for argument usage details

## Operation

Use w,a,s,d or arrow keys to move

Use i,j,k,l to move focus

Use 1~9 to select slot in hotbar

Use \[ to dig, \] to place/interact

Use ^C to interrupt

## Structures

```
#]   #  -
[#   -  #
```
a piston, interact with the `#` to extend
```
#-]  #  -
     |  |
[-#  -  #
```
a extended piston, interact with the `#` to contract
+ one piston can have multiple heads

## Progress

- [ ] File Operations
- - [x] Basic file reading (char 0~127 now)
- - [x] Multiple file reading
- - [x] File Saving
- - [x] Multiple file saving
- - [ ] Save Reading
- - [ ] Save Saving
- [x] Arguments Reading
- - [x] Editor
- - [ ] Simple Mode
- - [ ] Help
- [ ] Editing
- - [x] Map
- - [x] Moving
- - [x] Mining
- - [x] Placing
- - [x] Entities
- - - [x] Support
- - - [x] Item Type
- - - [ ] Battary Type
- - - [x] Creating & Deleting
- - - [ ] Entity Moving
- - [ ] Inventory
- - - [x] Support
- - - [x] Displaying
- - - [ ] Item Operating
- - - [x] Pick
- - - [ ] Drop
- [ ] Optimize
- - [ ] Multi-threading
- - - [x] Input thread
- - - [ ] Async Print
- - - [ ] Entity thread
- - [x] Display Cache
- - [x] Free Headers Including
- [ ] Modding
- - [ ] \(Nothing Done\)
