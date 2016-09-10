import sys
import urllib
for line in sys.stdin:
  print urllib.unquote(line)