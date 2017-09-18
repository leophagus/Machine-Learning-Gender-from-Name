import sys

#for line in sys.stdin:
while (1):
  #fname = 'JAHNAVI'
  fname = raw_input()
  maxFnameLen = 10
  maxEthLen = 14
  #fnameAdj = '{0: <{l}}'.format(fname[::-1], l=maxFnameLen)[0:maxFnameLen].upper()
  fnameAdj = '{0: <{l}}'.format(fname[::], l=maxFnameLen)[0:maxFnameLen].upper()
  sys.stdout. write (fnameAdj + ' ')
  for c in fnameAdj:
    v = 1 + ord(c) - ord('A')
    if v < 0:
      v = 0
    #datF. write (str(ord(c) - 32))
    sys.stdout.write (str(v) + ' ')
  sys.stdout.write ('\n')

