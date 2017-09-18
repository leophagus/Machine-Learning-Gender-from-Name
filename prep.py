#!/usr/bin/python

# Simple script to process NY Baby names data csv file and create input data for NN
# The csv file came from "Most Popular Baby Names by Sex and Mother's Ethnic Group, New York City", 
# https://catalog.data.gov/dataset/most-popular-baby-names-by-sex-and-mothers-ethnic-group-new-york-city-8c742
# Marked as Public info. Found it by just googling for baby names :)
# 2017-09-17 20:16:06  leo 
import csv

# ethKey is overridden to 0. Dont want to model ethnicity yet
def writeDat (datF, fnameAdj, ethKey, genKey):
  for c in fnameAdj:
    v = 1 + ord(c) - ord('A')
    if v < 0:
      v = 0
    datF. write (str(v))
    datF. write (',')
  y = 1 + 0 * 2 + genKey
  datF. write (str (y))
  datF. write ('\n')

with open ('ny_names.csv' , 'rt') as csvfile:

  maxFnameLen = 10
  maxEthLen = 14
  genDict = {}
  ethDict = {}

  datF = open('out_noinv_g.dat', 'wt')

  reader = csv.DictReader (csvfile)
  for row in reader:
    gen = row['Gender']
    eth = row['Ethnicity'][0:maxEthLen]
    fname = row['Child\'s First Name']

    if gen not in genDict:
      genDict [gen] = len(genDict)
    if eth not in ethDict:
      ethDict[eth] = len(ethDict)

    # reverse, uppercase, blank-pad, pick first n bytes. Doesnt ofer any advantage
    #fnameAdj = '{0: <{l}}'.format(fname[::-1], l=maxFnameLen)[0:maxFnameLen].upper()

    fnameAdj = '{0: <{l}}'.format(fname[::], l=maxFnameLen)[0:maxFnameLen].upper()

    writeDat (datF, fnameAdj, ethDict [eth], genDict [gen])

  print 'Done. #gen ', len (genDict), ' #eth ', len (ethDict) 
  print genDict
  print ethDict
  datF. close ()

