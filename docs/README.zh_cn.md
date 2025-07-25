|&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;|![Minecraft IDE](MinecraftIDE.png)|&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;|
|-|-|-|
[English](../README.md)

# Minecraft IDE
### 像玩 Minecraft 一样编辑文件
\(目前还不能保存\)

## 安装
此项目只能在 Linux 上运行
```sh
git clone https://github.com/RedstoneOre/MinecraftEditor.git

```

## 使用方法
```sh
cd MinecraftEditor
./editor <file>
```

## 操作

使用 w,a,s,d 移动

使用 i,j,k,l 移动焦点

使用 1~9 选择快捷栏中的插槽

使用 \[ 挖掘，\] 放置，\\ 交互

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
