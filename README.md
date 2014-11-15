![Buftabline](http://ap.github.io/vim-buftabline/screenshot.png)
================================================================

Buftabline takes over the `tabline` and renders the buffer list in it instead
of a tab list. It is designed with the ideal that it should Just Work, and has
no configurable behaviour: drop it into your configuration and you’re done.

There are comparisons with several alternative plugins in the documentation.

Buffer basics
-------------

If you don’t know anything about buffers, the minimum you have to know is that
a buffer in Vim essentially means a file, and if you set `hidden`, Vim can keep
files open without necessarily displaying them on screen. You can then use the
`:bnext` and `:bprev` commands to change which buffer is being displayed in the
current window, and `:ls` to look at the list of buffers.

If this is all news to you, you should probably add this to your configuration:

    set hidden
    nnoremap <C-N> :bnext<CR>
    nnoremap <C-P> :bprev<CR>

For the full story, read [`:help windows.txt`][windows].


Why this and not Vim tabs?
--------------------------

Vim tabs are not very useful except in very particular circumstances. To
understand why you have to understand the display in Vim has 3 layers of
indirection:

1. Buffers correspond to files. Not necessarily to files on disk, but in
   potentiality; i.e. a buffer becomes the content of a file when you do `:w`

2. Windows correspond to rectangular areas on the screen, each of which is
   associated with one buffer. But any window can be associated with any
   buffer, and any buffer with any window.

   You can change which buffer is shown in a window at any time, and you can
   split and resize windows to create any on-screen arrangement you want.

   So you could have 3 windows showing the same buffer, e.g. to have different
   areas of a file visible at once. But note that while windows are always
   associated with a buffer, a buffer need not be associated with any window –
   or more concretely, a file can be loaded but not currently shown on screen.

3. Tabs correspond to screens, i.e. to an arrangement of windows. In other
   windowing environments the corresponding concept is often called a viewport,
   or a virtual desktop. Each window belongs to one particular tab. But note
   that a buffer can be shown in any window (or no window at all), so any file
   can appear any number of times in any number of tabs. Tabs and files do not
   have anything to do with each other.

Now it is possible to open just one full-screen window in each tab, and in each
window edit a different buffer, in effect associating tabs with files. But this
only works if you stay away from any other window or buffer management, i.e. if
you never create splits and never touch the buffer list. Even then there are
parts of Vim (such as the help function and the netrw Explorer) that expect to
be working with windows, not tabs, and so can easily inadvertently shatter the
illusion.

Now, if you consider what Vim tabs actually are, i.e. viewports, there only
very limited circumstances in which you will ever need such functionality, if
at all.

What the typical user wants when they think of as tabs is simply the ability to
open multiple files and then flip between them, which in Vim means they want
buffers – not tabs.


<!-- vim: et fenc=utf8
-->

[windows]: http://vimdoc.sourceforge.net/htmldoc/windows.html
