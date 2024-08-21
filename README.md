# Kodnotes.nvim

A brain dead simple note taking system; made for my own personal use.
Supports nothing but linking and grepping.

Files in a folder that link to each other, what more could you need?

For some god forsaken reason if you want to use this plugin; telescope and ripgrep 
is a required dependency (used for searching through notes to insert links).

Set vim.g.kodnotes_root if you want to change where the notes are located (by default in ~/notes)

Oh, and its less than a hundred lines of lua code, so maybe maintain a fork yourself if you're gonna use it?
Wouldn't be too difficult, and it'd be a hell of a lot more reliable than relying on lil old me.

The plugin creates these commands:
**:KodnotesNewNote** creates a new note; with the current time as title
**:KodnotesFollowLink** follows a [[link]] under the cursor
**:KodnotesInsertLink** allows you to search your notes and insert a link to a particular one
**:KodnotesNewNoteDir** allows you to make a new note under the specificied subdirectory.
**:KodnotesNewLitNote** allows you to make a new note under the "literature_notes" subdirectory (a utility command for my system)

