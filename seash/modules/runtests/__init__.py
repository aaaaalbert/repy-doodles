import seash_exceptions
import command_callbacks
import os

module_help = """
RunTests Module

This module runs unit test cases you uploaded to a
vessel. For this to work, `uploaddir` all of the
test files you'd like to have run, then upload the
`testrunner` script, and call the `runtests`
function to run all of the files contained in the
tests directory. The vessel log then contains the
test outcomes and errors.

user@target !> uploaddir /path/to/tests/directory
user@target !> upload testrunner.r2py
user@target !> runtests /path/to/tests/directory
user@target !> show log
"""



def run_tests(input_dict, environment_dict):
  """Run all the tests in the vessel (one by one), based on the
  list of files in the directory supplied as our argument.

  A note on the input_dict argument:
  `input_dict` contains our own `command_dict` (see below), with 
  the `"[ARGUMENT]"` sub-key of `children` renamed to what 
  argument the user provided. In our case, this will be the source 
  dir to read from. (If not, this is an error!)
  """
  # Check user input and seash state:
  # 1, Make sure there is an active user key.
  if environment_dict["currentkeyname"] is None:
    raise seash_exceptions.UserError("""Error: Please set an identity before using 'runtests'!
Example:

 !> loadkeys your_user_name
 !> as your_user_name
your_user_name@ !>
""")

  # 2, Make sure there is a target to work on.
  if environment_dict["currenttarget"] is None:
    raise seash_exceptions.UserError("""Error: Please set a target to work on before using 'runtests'!
Example
your_user_name@ !> on browsegood
your_user_name@browsegood !> 
""")

  # 3, Complain if we don't have a source dir argument
  try:
    source_directory = input_dict["runtests"]["children"].keys()[0]
  except IndexError:
    raise seash_exceptions.UserError("""Error: Missing operand to 'runtests'

Please specify a source directory, e.g.
your_user_name@browsegood !> runtests a_local_directory

""")


  # Sanity check: Does the source dir exist?
  if not os.path.exists(source_directory):
    raise seash_exceptions.UserError("Error: Source directory '" + source_directory + "' does not exist.")

  # Sanity check: Is the source dir a directory?
  if not os.path.isdir(source_directory):
    raise seash_exceptions.UserError("Error: Source directory '" + source_directory + "' is not a directory.")

  # Alright --- user input and seash state seem sane, let's do the work!
  # Iterate over all files; keep trying if the vessel is still running the
  # previous test; stop on KeyboardInterrupt.
  # These are the files we will need to run:
  file_list = os.listdir(source_directory)
  file_list.sort()
  for filename in file_list:
    print "Starting '" + filename + "'"
    # Construct an input_dict containing command args for seash's 
    # `start FILENAME` function.
    # XXX There might be a cleaner way to do this.
    faked_input_dict = {"start": {"name": "start",
      "children": {"testrunner.r2py": {"name": "filename",
      "children": {filename: {"name": "args", "children":{}}}}}}}
    try:
      while True:
        try:
          command_callbacks.start_remotefn_arg(faked_input_dict, environment_dict)
          break
        except Exception, e:
          # XXX repyportability meddles with the proper NMClientException
          # XXX Also, command_callbacks.* never raises exceptions :-(
          # XXX We'd need to poll the vessel status or similar...
          if "Vessel has already been started" in str(e):
            print "Retrying..."
            sleep(5)
    except KeyboardInterrupt:
      break




command_dict = {
  "runtests": {
    "name": "runtests",
    "callback": run_tests,
    "summary": "Run tests from the specified directory",
    "help_text": module_help,
    "children": {
      "[ARGUMENT]": {
        "name": "source_directory",
        "callback": None,
        "children": {},
      }
    }
  }
}


moduledata = {
  'command_dict': command_dict,
  'help_text': module_help,
  'url': None,
}



