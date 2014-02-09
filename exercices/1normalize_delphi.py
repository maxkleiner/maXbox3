#!/usr/bin/python

import os, string, time

starttime = time.strftime('%X %x %Z')

xslfile = "normalize.xsl"
inputdir = "compileroutput"
outputdir = "normalized"

buildsetupstring="""
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:variable name="outputmode" select="'normalized'"/>
  <xsl:variable name="outputdir" select="'normalized'"/>
</xsl:stylesheet>
"""

setupfile = file("setupbuild.xsl","w")
setupfile.write(buildsetupstring)
setupfile.close()

if os.path.exists("normalized"):
    command = "rmdir /s /q normalized"
    os.system(command)

command = "mkdir normalized"
os.system(command)

for infile in os.listdir(inputdir):
    command = "saxon " + inputdir + '/' + infile + ' ' + xslfile + " > C:\\xmldoctemp.txt"
    os.system(command)
