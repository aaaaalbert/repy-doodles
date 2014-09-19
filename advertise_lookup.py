import sys

if len(sys.argv) == 1:
  print """advertise_lookup.py -- 
  resolve a key to a value on the Seattle advertise services

Usage:
  python advertise_lookup.py ONE_ID [ ANOTHER_ID... ]
"""

from repyportability import *
add_dy_support(locals())

advertise = dy_import_module("advertise.r2py")

for identifier in sys.argv[1:]:
  try:
    print "'" + identifier + "' maps to", advertise.advertise_lookup(identifier)
  except advertise.AdvertiseError:
    print "(Error looking up " + identifier +")"

