import seash_exceptions
import command_callbacks
import os

module_help = """
RunTests Module

This module uploads the contents of a directory of your choice,
and then runs all of the files as Seattle Unit Tests.
Don't forget to upload the testrunner beforehand!

user@target !> upload testrunner.r2py
user@target !> runtests /path/to/tests/directory
Uploading .....
Running .....
user@target !> show log
"""



def upload_directory_and_run_tests(input_dict, environment_dict):
  """This function serves to upload every file in a user-supplied 
  source directory to all of the vessels in the current target group.
  It essentially calls seash's `upload` function repeatedly, each 
  time with a file name taken from the source directory.
  After that, all of the test cases are started on the vessel
  (one by one).

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
    raise seash_exceptions.UserError("Error: Source directory '" + source_directory + "' is not a directory.\nDid you mean to use the 'upload' command instead?")

  # Alright --- user input and seash state seem sane, let's do the work!
  # These are the files we will need to upload:
  file_list = os.listdir(source_directory)

  # Now upload all the test files
  for filename in file_list:
    # We construct the filename-to-be uploaded from the source dir, 
    # the OS-specific path separator, and the actual file name. 
    # This is enough for `upload_target` to find the file.
    path_and_filename = source_directory + os.sep + filename
    if not os.path.isdir(path_and_filename):
      print "Uploading '" + path_and_filename + "'..."
      # Construct an input_dict containing command args for seash's 
      # `upload FILENAME` function.
      # XXX There might be a cleaner way to do this.
      faked_input_dict = {"upload": {"name": "upload", 
        "children": {path_and_filename: {"name": "filename"}}}}
      command_callbacks.upload_filename(faked_input_dict, environment_dict)
    else:
      print "Skipping sub-directory '" + filename + "'. You may upload it separately."

  # Lastly, run the tests
  file_list.sort()
  for filename in file_list:
    print "Starting '" + filename + "'"
    # Construct an input_dict containing command args for seash's 
    # `start FILENAME` function.
    # XXX There might be a cleaner way to do this.
    faked_input_dict = {"start": {"name": "start",
      "children": {"testrunner.r2py": {"name": "filename",
      "children": {filename: {"name": "args", "children":{}}}}}}}
    command_callbacks.start_remotefn_arg(faked_input_dict, environment_dict)
    



command_dict = {
  "runtests": {
    "name": "runtests",
    "callback": upload_directory_and_run_tests,
    "summary": "Run all tests from the specified directory",
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



