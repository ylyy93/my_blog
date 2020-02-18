---
layout: post
title: Everything on Vim
date: 2020-02-17 15:58 -0800
categories: Coding
tags: [Linux]
---

### Modes
| Name  | Description  |
|---|---|
| `normal`  |  For navigation and manipulation of text. This is the mode that vim will usually start in, which you can usually get back to with ESC. |
| `insert`  |  For inserting new text. The main difference from vi is that many important "normal" commands are also available in insert mode - provided you have a keyboard with enough meta keys (such as Ctrl, Alt, Windows-key, etc.). |
| `visual`  |  For navigation and manipulation of text selections, this mode allows you to perform most normal commands, and a few extra commands, on selected text.	 |
| `select`  |  Similar to visual, but with a more MS Windows-like behavior. |


### Useful Shortcuts
In short, remember `y`(copy),`p`(paste),`d`(cut).

#### Normal mode
`h`: move left
`j`: move down
`k`: move up
`l`: move right
`w`: start of words
`e`: end of words
`b`: jump back by workds
`0`: start of line
`$`: end of line
`G`: Go To command


##### Editing
`cc`: change (replace) an entire line
`cw`: change (replace) to the end of word
`c$`: change (replace) to the endo of line
`s`: delete character at cursor and subsitute text
`S`: delete line      at cursor and subsitute text
`u`: undo
`.`: repeat last command

##### Cut and Paste
`yy`: yank (copy) a line
`2yy`: yank two lines
`yw`: yank word
`y$`: yank to end of line
`p`: paste hte clipboard after cursor
`P`: paste before the cursor
`dd`: delete a line
`dw`: delete current word
`x`: delete currect character

##### Search/Replace
/`pattern`: search
`?pattern`: search backword
`:%s/old/new/gc`: replace all old with new throughout file with confirmation

#### Insert mode
`i`: start insert mode
`ESC`: exsit insert mode

#### Visual mode
`v`: start visual mode
`V`: start Linewise visual mode
`Ctrl+v`: start visual block mode
`Esc`: exit visual mode

## References
- [Learning the vi Editor/Vim/Modes](https://en.wikibooks.org/wiki/Learning_the_vi_Editor/Vim/Modes)
