" Vim syntax file
" Language:	RepyV2 aka r2py aka Restricted Python, version 2
"               as used by Seattle Testbed, https://seattle.poly.edu/
" Maintainer:	@aaaaalbert on GitHub
" Last Change:	2017-03-17
" Credits:	This syntax file is based on
"               - Vim Python syntax module (version 2009-10-13) by
"               - Zvezdan Petkovic <zpetkovic@acm.org>
"		- Neil Schemenauer <nas@python.ca>
"		- Dmitry Vasiliev
"               and heavily inspired by Joao Moreno's
"               - `repy.vim` Syntax Coloring for Restricted Python
"               - (version 1.1 from 2009-02-19)
"               Thank you!

" Use the Python highlighting rules to start with
ru! syntax/python.vim

" Remove `import`, `from`
syn clear pythonInclude

" Redefine to remove exec, global, lambda, print, with, yield and Python3 stuff
syn clear pythonStatement

if !exists("python_no_builtin_highlight")
  syn keyword pythonStatement	False, None, True
  syn keyword pythonStatement	as assert break continue del
  syn keyword pythonStatement	pass return
  syn keyword pythonStatement	class def nextgroup=pythonFunction skipwhite
  syn keyword pythonConditional	elif else if
  syn keyword pythonRepeat	for while
  syn keyword pythonOperator	and in is not or
  syn keyword pythonException	except finally raise try

  " TODO Forbid decorators. Currently we just reuse `python.vim`'s
  " TODO definition, but highlight them like Errors. See HiLink section.
  "syn match   pythonDecorator	"@" display nextgroup=pythonFunction skipwhite

  " built-in constants
  " 'False', 'True', and 'None' are also reserved words in Python 3.0
  syn keyword pythonBuiltin	False True None
  syn keyword pythonBuiltin	NotImplemented Ellipsis __debug__
  " built-in functions
  " REMOVED: all, any, classmethod, compile, delattr, enumerate, eval,
  "          getattr, globals, hasattr, hash, help, id, input, iter, locals,
  "          property, reversed, setattr, staticmethod, vars, __import__
  "          basestring, callable, execfile, file, raw_input, reload,
  "          unichr, unicode
  "          apply, buffer, coerce, intern
  syn keyword pythonBuiltin	abs any bin bool chr classmethod
  syn keyword pythonBuiltin	complex dict dir divmod
  syn keyword pythonBuiltin	filter float format
  syn keyword pythonBuiltin	frozenset
  syn keyword pythonBuiltin	hex int isinstance
  syn keyword pythonBuiltin	issubclass len list map max
  syn keyword pythonBuiltin	min next object oct ord pow
  syn keyword pythonBuiltin	range repr round set
  syn keyword pythonBuiltin	slice sorted str
  syn keyword pythonBuiltin	sum super tuple type vars zip
  syn keyword pythonBuiltin	cmp
  syn keyword pythonBuiltin	long reduce
  syn keyword pythonBuiltin	xrange

  " RepyV2 additional keywords
  syn keyword pythonBuiltin	gethostbyname getmyip
  syn keyword pythonBuiltin	sendmessage listenformessage
  syn keyword pythonBuiltin	openconnection listenforconnection
  syn keyword pythonBuiltin	openfile listfiles removefile
  syn keyword pythonBuiltin	exitall getruntime randombytes sleep log
  syn keyword pythonBuiltin	createthread createlock getthreadname
  syn keyword pythonBuiltin	createvirtualnamespace getresources
  syn keyword pythonBuiltin	getlasterror
  " TODO These are RepyV2 object methods really
  syn keyword pythonBuiltin	close readat writeat
  syn keyword pythonBuiltin	recv send getmessage getconnection
  syn keyword pythonBuiltin	acquire release evaluate
endif

" Add in Repy exceptions
if !exists("python_no_exception_highlight")
  syn keyword pythonExceptions	RepyException RepyArgumentError CodeUnsafeError
  syn keyword pythonExceptions	ContextUnsafeError ResourceUsageError
  syn keyword pythonExceptions	ResourceExhaustedError ResourceForbiddenError
  syn keyword pythonExceptions	FileError FileNotFoundError FileInUseError
  syn keyword pythonExceptions	SeekPastEndOfFileError FileClosedError
  syn keyword pythonExceptions	LockDoubleReleaseError NetworkError
  syn keyword pythonExceptions	NetworkAddressError AlreadyListeningError
  syn keyword pythonExceptions	DuplicateTupleError CleanupInProgressError
  syn keyword pythonExceptions	InternetConnectivityError AddressBindingError
  syn keyword pythonExceptions	ConnectionRefusedError LocalIPChanged
  syn keyword pythonExceptions	SocketClosedLocal SocketClosedRemote
  syn keyword pythonExceptions	SocketWouldBlockError
  syn keyword pythonExceptions	TCPServerSocketInvalidError TimeoutError
endif

syn keyword r2pyForbidden exec global lambda print with yield
syn keyword r2pyForbidden import from
syn keyword r2pyForbidden all any classmethod compile delattr enumerate eval
syn keyword r2pyForbidden getattr globals hasattr hash help id input
syn keyword r2pyForbidden iter locals property reversed setattr staticmethod
syn keyword r2pyForbidden vars __import__
syn keyword r2pyForbidden basestring callable execfile file raw_input reload
syn keyword r2pyForbidden unichr unicode
syn keyword r2pyForbidden apply buffer coerce intern


if version >= 508 || !exists("did_python_syn_inits")
  if version <= 508
    let did_python_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  " XXX Marking a decorator as Error doesn't work like that
  HiLink pythonDecorator	Error
  HiLink r2pyForbidden		Error

  delcommand HiLink
endif

let b:current_syntax = "python"

" vim:set sw=2 sts=2 ts=8 noet:
