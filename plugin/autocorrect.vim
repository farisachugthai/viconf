" ============================================================================
    " File: autocorrect.vim
    " Author: Faris Chugthai
    " Description: Autocorrect
    " Last Modified: Nov 02, 2019
" ============================================================================

" Unrelated:
  if !exists('g:loaded_custom_remotes')
    call remotes#init()
    let g:loaded_custom_remotes = 1
  else
    finish
  endif

" Guard:
  " Dont load if you spell checking isnt on. Also dont load if you dont know
  " what spell checking is.
  if has('spell')
    if &spell == v:false
      finish
    endif
  else
    finish
  endif

" Wordlist:
inorea Arent Aren't
inorea Cant Can't
inorea Couldnt Couldn't
inorea Didint Didn't
inorea Didnt Didn't
inorea Doesnt Doesn't
inorea Dont Don't
inoreab Hasnt Hasn't
inorea Havent Haven't
inorea idk I don't know
inorea Isnt Isn't
inorea Itd It'd
inoreab Itis It Is
inorea Itll It Will
inoreab Itwas It Was
inorea Ive I've
inorea Lets Let's
inoreab Shouldnt Shouldn't
inorea Shouldve Should've
inorea Thats That's
inoreab Themself Themselves
inorea Theyll They'll
inorea Theyve They've
inorea Theyre They're
inoreab Thgat That
inoreab Thge The
inoreab Thme Them
inoreab Thna Than
inoreab Thna Than
inoreab Thne Then
inorea Wont Won't
inoreab Woudl Would
inorea Wouldnt Wouldn't
inorea Wouldve Would've
inorea Youll You'll
inorea Youre You're
inoreab Youve You've
inorea arent aren't
inorea cant can't
inoreab couldnt couldn't
inoreab didint didn't
inoreab didnt didn't
inorea doesnt doesn't
inorea dont don't
inorea hasnt hasn't
inorea havent haven't
inorea http http://
inorea im I'm
inorea isnt isn't
inorea itd it'd
inoreab itis it is
inorea itll it will
inoreab itwas it was
inoreab iused used
inoreab iwll will
inoreab iwth with
inorea ive I've
inoreab jsut just
inoreab konw know
inorea lets let's
inoreab shouldnt shouldn't
inorea shouldve should've
inoreab thats that's
inoreab themself themselves
inoreab theyll they'll
inoreab theyve they've
inorea theyre they're
inoreab thgat that
inoreab thge the
inoreab thier their
inoreab thigsn things
inoreab thme them
inoreab thna than
inoreab thna than
inoreab thne then
inoreab thnigs things
inoreab thnig thing
inorea wont won't
inoreab woudl would
inorea wouldnt wouldn't
inorea wouldve would've
inoreab yoiu you
inorea youll you'll
inorea youre you're
inorea youve you've
inoreab yuor your
inoreab yuo you
