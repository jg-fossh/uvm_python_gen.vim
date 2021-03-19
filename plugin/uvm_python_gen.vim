" Vim Plugin for UVM-Python Automatic Shell Code Generation
" Language:     Vim
" Maintainer:   Jose R Garcia
" Version:      0.20
" Modified:     2017-11-03 14:37

let s:save_cpo = &cpo
set cpo&vim

" set Author in the header
if exists("g:author")
    let s:author = g:author
else
    let s:author = $USER
endif

" set email address in the header
if exists("g:email")
    let s:email = g:email
else
    let s:email = s:author . "@xxxx.com"
endif

" set company in the header
if exists("g:company")
    let s:company = g:company
else
    let s:company = ""
endif

" comment line
let s:uvm_linecomment    = "# "
let s:uvm_seprateline    = "#####################################################################################"
let s:uvm_copyright      = "All rights reserved."
let s:uvm_filename       = "File name      : " . expand("%:t")
let s:uvm_author         = "Author         : " . s:author
let s:uvm_company        = "Company        : " . s:company
let s:uvm_email          = "Email          : " . s:email
let s:uvm_created        = "Created        : " . strftime ("%Y-%m-%d %H:%M:%S")
let s:uvm_modified       = "Modified       : " . strftime ("%Y-%m-%d %H:%M:%S")
let s:uvm_project        = "Project name   : "
let s:uvm_module         = "Class(es) name : "
let s:uvm_description    = "Description    : "
let s:uvm_additional_comments = "Additional Comments: "

" List of all types
let s:type_list = ["agent","config","driver","env","monitor","sequence","test","top","item","interface"]

" normalize the path
" replace the windows path sep \ with /
function <SID>NormalizePath(path)
    return substitute(a:path, "\\", "/", "g")
endfunction

" Returns a string containing the path of the parent directory of the given
" path. Works like dirname(3). It also simplifies the given path.
function <SID>DirName(path)
    let l:tmp = <SID>NormalizePath(a:path)
    return substitute(l:tmp, "[^/][^/]*/*$", "", "")
endfunction

" Default templates directory
let s:default_template_dir = <SID>DirName(<SID>DirName(expand("<sfile>"))) . "templates"
" let s:default_template_dir = "/home/jota/.config/nvim/templates"

" Makes a single [variable] expansion, using [value] as replacement.
"
function <SID>TExpand(variable, value)
    silent execute "%s/{:" . a:variable . ":}/" .  a:value . "/g"
endfunction

" Puts the cursor either at the first line of the file or in the place of
" the template where the %HERE% string is found, removing %HERE% from the
" template.
"
function <SID>TPutCursor()
    0  " Go to first line before searching
    if search("{:HERE:}", "W")
        let l:column = col(".")
        let l:lineno = line(".")
        silent s/{:HERE:}//
        call cursor(l:lineno, l:column)
    endif
endfunction

" Load the template, and read it
function <SID>TLoadCmd(template)
    if filereadable(a:template)
        " let l:tFile = a:template
        if a:template != ""
            execute "r " . a:template
            " call <SID>TExpandVars()
            " call <SID>TPutCursor()
            setlocal nomodified
        endif
    else
        echo "ERROR! Can not find" . a:template
    endif

endfunction

"
"  Look for global variables (if any), to override the defaults.
"
function! UVM_CheckGlobal ( name )
  if exists('g:'.a:name)
    exe 'let s:'.a:name.'  = g:'.a:name
  endif
endfunction    " ----------  end of function C_CheckGlobal ----------

" make a header
function s:UVMAddHeader()
    call append (0,  s:uvm_seprateline)
    call append (1,  s:uvm_linecomment . " " . s:uvm_copyright)
    call append (2,  s:uvm_linecomment)
    call append (3,  s:uvm_linecomment . " " . s:uvm_filename)
    call append (4,  s:uvm_linecomment . " " . s:uvm_author)
    call append (5,  s:uvm_linecomment . " " . s:uvm_company)
    call append (6,  s:uvm_linecomment . " " . s:uvm_email)
    call append (7,  s:uvm_linecomment . " " . s:uvm_created)
    call append (8,  s:uvm_linecomment . " " . s:uvm_modified)
    call append (9,  s:uvm_linecomment . " " . s:uvm_project)
    call append (10,  s:uvm_linecomment . " " . s:uvm_module)
    call append (11, s:uvm_linecomment . " " . s:uvm_description)
    call append (12, s:uvm_linecomment)
    call append (13, s:uvm_linecomment . " " . s:uvm_additional_comments)
    call append (14, s:uvm_linecomment)
    call append (15, s:uvm_seprateline)

    " call <SID>TPutCursor()
    echo "Successfully added the header!"
endfunction

function! UVMPYENV(name)
    let l:template = s:default_template_dir . "/uvm_env.py"
    let l:uppername = toupper(a:name)
    let l:lowername = tolower(a:name)

    call s:UVMAddHeader()
    call <SID>TLoadCmd(l:template)
    call <SID>TExpand("NAME", a:name)
    call <SID>TExpand("UPPERNAME", l:uppername)
    call <SID>TExpand("LOWERNAME", l:lowername)
    call <SID>TPutCursor()
endfunction

function! UVMPYTEST(name)
    let l:uvm_file_template = "uvm_test.py"
    let l:template          = s:default_template_dir . "/" . l:uvm_file_template
    let l:uppername         = toupper(a:name)
    let l:lowername         = tolower(a:name)

    call s:UVMAddHeader()
    call <SID>TLoadCmd(l:template)
    if (a:name == "base")
        " let a:name_temp = "tc_" . a:name
        let a:name_temp   = "base_test"
        let a:parent_name = "uvm_test"
    else
        " let a:name_temp = a:name . "_test"
        let a:name_temp   = "test"
        let a:parent_name = "tc_base"
    endif
    call <SID>TExpand("NAME", a:name_temp)
    call <SID>TExpand("PARENT", a:parent_name)
    call <SID>TExpand("UPPERNAME", a:uppername)
    call <SID>TExpand("LOWERNAME", a:lowername)
    call <SID>TPutCursor()
endfunction

function! UVMPYAGENT(name)
    let l:uvm_file_template = "uvm_agent.py"
    let l:template          = s:default_template_dir . "/" . l:uvm_file_template
    let l:uppername         = toupper(a:name)
    let l:lowername         = tolower(a:name)

    call s:UVMAddHeader()
    call <SID>TLoadCmd(template)
    call <SID>TExpand("NAME", a:name)
    call <SID>TExpand("UPPERNAME", l:uppername)
    " call <SID>TExpand("LOWERNAME", l:lowername)
    call <SID>TPutCursor()
endfunction

function! UVMPYDRIVER(name)
    let l:uvm_file_template = "uvm_driver.py"
    let l:template          = s:default_template_dir . "/" . l:uvm_file_template
    let l:uppername         = toupper(a:name)
    let l:lowername         = tolower(a:name)
    let l:transaction       = a:name . "_trans"

    call s:UVMAddHeader()
    call <SID>TLoadCmd(l:template)
    call <SID>TExpand("NAME", a:name)
    call <SID>TExpand("UPPERNAME", l:uppername)
    call <SID>TExpand("LOWERNAME", l:lowername)
    call <SID>TExpand("TRANSACTION", l:transaction)
    call <SID>TPutCursor()
endfunction

function! UVMPYMON(name)
    let l:uvm_file_template = "uvm_monitor.py"
    let l:template          = s:default_template_dir . "/" . l:uvm_file_template
    let l:uppername         = toupper(a:name)
    let l:lowername         = tolower(a:name)
    let l:transaction       = a:name . "_trans"

    call s:UVMAddHeader()
    call <SID>TLoadCmd(l:template)
    call <SID>TExpand("NAME", a:name)
    call <SID>TExpand("UPPERNAME", l:uppername)
    call <SID>TExpand("LOWERNAME", l:lowername)
    call <SID>TExpand("TRANSACTION", l:transaction)
    call <SID>TPutCursor()
endfunction

function! UVMPYSEQ(name)
    let l:uvm_file_template = "uvm_sequence.py"
    let l:template          = s:default_template_dir . "/" . l:uvm_file_template
    let l:uppername         = toupper(a:name)
    let l:lowername         = tolower(a:name)
    let l:transaction       = a:name . "_trans"

    call s:UVMAddHeader()
    call <SID>TLoadCmd(l:template)
    call <SID>TExpand("NAME", a:name)
    call <SID>TExpand("UPPERNAME", l:uppername)
    call <SID>TExpand("LOWERNAME", l:lowername)
    call <SID>TExpand("TRANSACTION", l:transaction)
    call <SID>TPutCursor()
endfunction

function! UVMPYTRANS(name)
    let l:uvm_file_template = "uvm_transaction.py"
    let l:template          = s:default_template_dir . "/" . l:uvm_file_template
    let l:uppername         = toupper(a:name)
    let l:lowername         = tolower(a:name)

    call s:UVMAddHeader()
    call <SID>TLoadCmd(l:template)
    call <SID>TExpand("NAME", a:name)
    call <SID>TExpand("UPPERNAME", l:uppername)
    call <SID>TExpand("LOWERNAME", l:lowername)
    call <SID>TPutCursor()
endfunction

function! UVMPYTOP(name)
    let l:uvm_file_template = "uvm_test_top.py"
    let l:template          = s:default_template_dir . "/" . l:uvm_file_template
    let l:uppername         = toupper(a:name)
    let l:lowername         = tolower(a:name)

    call s:UVMAddHeader()
    call <SID>TLoadCmd(l:template)
    call <SID>TExpand("NAME", a:name)
    call <SID>TExpand("UPPERNAME", l:uppername)
    call <SID>TExpand("LOWERNAME", l:lowername)
    call <SID>TPutCursor()
endfunction

function! UVMPYCONFIG(name)
    let l:uvm_file_template = "uvm_config.py"
    let l:template          = s:default_template_dir . "/" . l:uvm_file_template
    let l:uppername         = toupper(a:name)
    let l:lowername         = tolower(a:name)

    call s:UVMAddHeader()
    call <SID>TLoadCmd(l:template)
    call <SID>TExpand("NAME", a:name)
    call <SID>TExpand("UPPERNAME", l:uppername)
    call <SID>TExpand("LOWERNAME", l:lowername)
    call <SID>TPutCursor()
endfunction

function! UVMInterface(name)
    let l:uvm_file_template = "uvm_interface.py"
    let l:template          = s:default_template_dir . "/" . l:uvm_file_template
    let l:uppername         = toupper(a:name)
    let l:lowername         = tolower(a:name)

    call s:UVMAddHeader()
    call <SID>TLoadCmd(l:template)
    call <SID>TExpand("NAME", a:name)
    call <SID>TExpand("UPPERNAME", a:uppername)
    call <SID>TExpand("LOWERNAME", a:lowername)
    call <SID>TPutCursor()
endfunction

" According to the args, call different methods
"
function! UVMPYGEN(type, name)
" function UVMPYGEN(...)
"     Arguments:
"       a:type = UVM Component
"       a:name = This.Component's name
    if (a:type == "agent")
        call UVMPYAGENT(a:name)
    elseif (a:type == "config")
        call UVMPYCONFIG(a:name)
    elseif (a:type == "interface") || (a:type == "if")
        call UVMPYIF(a:name)
    elseif (a:type == "driver") || (a:type == "drv")
        call UVMPYDRIVER(a:name)
    elseif (a:type == "env")
        call UVMPYENV(a:name)
    elseif (a:type == "monitor") || (a:type == "mon")
        call UVMPYMON(a:name)
    elseif (a:type == "sequence") || (a:type == "seq")
        call UVMPYSEQ(a:name)
    elseif (a:type == "test")
        call UVMPYTEST(a:name)
    elseif (a:type == "top")
        call UVMPYTOP(a:name)
    elseif (a:type == "item") || (a:type == "it")
        call UVMPYTRANS(a:name)
    else
        echo "*** INVALID ARGUMENTS ***"
        echo "Usage:"
        echo "    :UVMPYGEN arg0 arg1"
        echo "Where arg0 is the component type and arg1 is the"
        echo "name of the component"
        echo " "
        echo "  ~~~~~~~~~~~~~~~~~~~~ o ~~~~~~~~~~~~~~~~~~~~~  "
        echo " "
        echo "Types of components available: "
        echo "    agent           - Generate UVM Agent"
        echo "    config          - Generate UVM Config"
        echo "    interface, if   - Generate UVM Interface"
        echo "    driver, drv     - Generate UVM Driver"
        echo "    env             - Generate UVM Env"
        echo "    monitor,  mon   - Generate UVM Monitor"
        echo "    sequence, seq   - Generate UVM Sequence"
        echo "    test            - Generate UVM Test"
        echo "    top             - Generate UVM Top"
        echo "    item / it       - Generate UVM Sequence Item"
    endif
endf

" Return types name as arguments
function ReturnTypesList(A,L,P)
    return s:type_list
endf

" === plugin commands === {{{
command -nargs=0 UVMAddHeader call s:UVMAddHeader()
command -nargs=1 UVMPYENV call UVMPYENV("<args>")
command -nargs=1 UVMPYTEST call UVMPYTEST("<args>")
command -nargs=1 UVMPYAGENT call UVMPYAGENT("<args>")
command -nargs=1 UVMDriver call UVMDriver("<args>")
command -nargs=1 UVMPYMON call UVMPYMON("<args>")
command -nargs=1 UVMPYSEQ call UVMPYSEQ("<args>")
command -nargs=1 UVMPYTRANS call UVMPYTRANS("<args>")
command -nargs=1 UVMPYSEQITEM call UVMPYSEQITEM("<args>")
command -nargs=1 UVMTop call UVMTop("<args>")
command -nargs=1 UVMPYCONFIG call UVMPYCONFIG("<args>")
command -nargs=1 UVMPYIF call UVMPYIF("<args>")
command -nargs=+ -complete=customlist,ReturnTypesList UVMPYGEN call UVMPYGEN(<f-args>)
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
