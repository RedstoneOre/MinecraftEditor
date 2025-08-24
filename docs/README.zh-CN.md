|![Empty Image](empty.png)|![Minecraft IDE](../MinecraftIDE.png)|![Empty Image](empty.png)|
|-|-|-|

[English](../README.md) [Homepage](..)

# Minecraft IDE
### 像玩 Minecraft 一样编辑文件

## 安装
此项目只能在 Linux 上运行
```sh
git clone https://github.com/RedstoneOre/MinecraftIDE.git

```

## 使用方法
```sh
cd MinecraftIDE
./mcide <file>
```
[详细的参数用法](arguments/zh-CN.txt)

## 操作

使用 w,a,s,d 或者方向键 移动

使用 i,j,k,l 移动焦点

使用 e 打开/关闭背包

使用方向键在背包中控制光标

在背包中使用 \[ 左键, \] 右键

使用 1~9 选择快捷栏中的插槽/在背包中和该物品栏交换物品

使用 \[ 挖掘，\] 放置/交互

使用 ^C 中断

## 结构

```
#] # -
[# - #
```
一个活塞，与 `#` 交互使其扩展
```
#-] # -
    | |
[-# - #
```
一个伸展的活塞，与活塞交互使其收缩
+ 一个活塞可以有多个活塞头
