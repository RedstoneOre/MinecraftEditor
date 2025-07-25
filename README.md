|&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;|![Minecraft Editor](MinecraftEditor.png)|&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;|
|-|-|-|
<!--[中文(简体)](docs/README.zh_cn.md)-->

# Minecraft IDE
### Edit files just like playing minecraft
\(Cannot save yet\)

## Installation
This project can only be runned on Linux
```sh
git clone https://github.com/RedstoneOre/MinecraftEditor.git

```

## Usage
```sh
cd MinecraftEditor
./editor <file>
```

## Operation

Use w,a,s,d to move

Use i,j,k,l to move focus

Use 1~9 to select slot in hotbar

Use \[ to dig, \] to place, \\ to interact

Use ^C to Interrupt

## Structures

```
#]   #  -
[#   -  #
```
a piston, interact the `#` to extend
```
#-]  #  -
     |  |
[-#  -  #
```
a extended piston, interact to contract
+ one piston can have multiple heads

## Progress

- [ ] File Operations
- - [x] Basic file reading (char 0~127 now)
- - [ ] Multiple file reading
- - - [x] Support
- - [ ] File Saving
- - [ ] Save Reading
- - [ ] Save Saving
- [ ] Arguments Reading
- - [ ] \(Almost Nothing Done\)
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
- - - [x] Display Cache
- - [x] Free Headers Including
- [ ] Modding
- - [ ] \(Nothing Done\)
