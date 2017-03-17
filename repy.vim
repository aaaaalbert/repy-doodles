" Vim syntax file
" Language: Restricted Python
" Maintainer: João Moreno <mail@joaomoreno.com>
" Last Change: 2017-03-17
" Filenames: *.repy
" Version: 1.2
"
" Based on python.vim by Dmitry Vasiliev <dima@hlabs.spb.ru>
" and on https://github.com/SeattleTestbed/docs/blob/e96182c2ef1102af1ab869060958ba11f096bc2e/Programming/PythonVsRepy.md
"
" Thanks:
" Seattle Project and Community: https://seattle.poly.edu/

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

ru! syntax/python.vim

syn clear pythonInclude

syn clear pythonBuiltin

if !exists("python_no_builtin_highlight")

  syn keyword pythonStatement	True False Ellipsis None NotImplemented
  syn keyword pythonStatement	__debug__ __doc__ __file__ _package__
  syn keyword pythonInclude	include

  " additional keywords
  syn keyword pythonStatement  callargs callfunc mycontext socket
  syn keyword pythonStatement  lock

  syn keyword pythonBuiltin	abs apply
  syn keyword pythonBuiltin	basestring bool buffer bytearray bytes
  syn keyword pythonBuiltin	chr classmethod cmp coerce
  syn keyword pythonBuiltin	dict divmod
  syn keyword pythonBuiltin	file filter float format frozenset getattr
  syn keyword pythonBuiltin	hasattr hex
  syn keyword pythonBuiltin	int intern isinstance
  syn keyword pythonBuiltin	issubclass len list long map max
  syn keyword pythonBuiltin	min object oct open ord
  syn keyword pythonBuiltin	pow range
  syn keyword pythonBuiltin	reduce repr
  syn keyword pythonBuiltin	round set setattr
  syn keyword pythonBuiltin	slice str sum tuple
  syn keyword pythonBuiltin	type xrange zip

  " additional keywords
  syn keyword pythonBuiltin listdir removefile sleep settimer canceltimer
  syn keyword pythonBuiltin getruntime gethostbyname_ex getlock
  syn keyword pythonBuiltin randomfloat exitall getmyip recvmess sendmess
  syn keyword pythonBuiltin openconn waitforconn stopcomm

endif

syn keyword repyForbidden all any bin callable compile
syn keyword repyForbidden complex delattr dir enumerate
syn keyword repyForbidden eval execfile globals hash help
syn keyword repyForbidden id input iter locals next property
syn keyword repyForbidden raw_input reload reversed sorted
syn keyword repyForbidden staticmethod super unichr unicode vars
syn keyword repyForbidden __import__ import from


if version >= 508 || !exists("did_python_syn_inits")
  if version <= 508
    let did_python_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink repyForbidden Error
  
  delcommand HiLink
endif

let b:current_syntax = "repy"
