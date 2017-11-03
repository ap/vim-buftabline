cd .vim
args LICENSE README.md doc/buftabline.txt plugin/buftabline.vim
e README.md
sb doc/buftabline.txt
resize 6
/\*buftabline-intro\*
norm ztk
wincmd w
/Buftabline vs\. X
norm zt}}
