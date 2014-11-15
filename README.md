![Buftabline](http://ap.github.io/vim-buftabline/screenshot.png)
================================================================

Buftabline takes over the `tabline` and renders the buffer list in it instead
of a tab list. It is designed with the ideal that it should Just Work, and has
no configurable behaviour: drop it into your configuration and you’re done.


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
understand why this is, you have to understand that the display in Vim has
3 layers of indirection:

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


Buftabline vs. X
----------------

As of Nov 15, 2014, here is how Buftabline compares with some other plugins
of which I am aware that they offer related functionality, roughly in order
of their age.


* [MiniBufExpl](http://www.vim.org/scripts/script.php?script_id=159)

  Obviously no rundown can be complete without the veteran of buffer list
  plugins, Mini Buffer Explorer. There are two major differences:

  1. Buftabline uses the tabline while MiniBufExpl renders to a special buffer
     in a split. The tabline is newer than MiniBufExpl, and unlike a buffer, it
     is guaranteed to stick to the top of the screen within Vim, unaffected by
     any splits.

  2. Because Buftabline uses the tabline, it cannot offer any functionality
     relating to the management of buffers: all it does is show you the list.

     OTOH, this also makes Buftabline very lightweight from a user perspective:
     Vim has plenty of facilities for managing buffers and with Buftabline you
     will be using those same as without it. Buftabline need not aspire to be
     your sole interface to Vim’s buffers.

* [buftabs](http://www.vim.org/scripts/script.php?script_id=1664)

  Buftabs is what you get when you try to implement Buftabline on a Vim that
  does not yet have the `tabline`. It can only render your tabs near or at the
  bottom of the Vim screen, and you have the choice between trading in your
  `statusline` for the list, or having it flicker “behind” the command line. If
  MiniBufExpl is too heavy for you, buftabs is the best you can do in absence
  of the `tabline`.

  I used this for a long time.

* [Airline](http://www.vim.org/scripts/script.php?script_id=4661)

  If you already use Airline, you do not need Buftabline: the functionality
  comes built in – see `:help airline-tabline`.

  If you do not already use Airline, you may not want to: it is far heavier
  than Buftabline, to the point of dragging down performance. C.f.
  [Pretty statuslines vs cursor speed][badperf]

* [BufLine](http://www.vim.org/scripts/script.php?script_id=4940)

  This is very similar in scope and strategy to Buftabline, but not nearly as
  simple. The code is more than 5 times as long. There are lots of options and
  mappings so despite its limited scope compared to something like MiniBufExpl
  or Airline, it feels like a Big Plugin – one that requires a large up-front
  commitment. And subjective though this is, I will call its default colours
  ugly (while the ones in Buftabline depend entirely on your colorscheme), nor
  does it make any attempt to harmonise with the user colorscheme.

* [WinTabs](https://github.com/zefei/vim-wintabs)

  This is another Big Plugin, though much, much better. It supports Vim tabs
  in addition to buffers, and tries to implement a functionality that is not
  native to Vim tabs: scoping buffers to certain tabs. This means it also
  needs to hook into sessions in order to support them, which it does. All in
  all, if you want to use Vim tabs, this is probably the best plugin for you –
  Buftabline will be too simplistic for your preferences.

<!-- vim: et fenc=utf8
-->

[windows]: http://vimdoc.sourceforge.net/htmldoc/windows.html
[badperf]: https://www.reddit.com/r/vim/comments/2lw1fd/pretty_statuslines_vs_cursor_speed/
