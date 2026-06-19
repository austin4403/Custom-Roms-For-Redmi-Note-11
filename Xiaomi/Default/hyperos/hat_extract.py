#!/usr/bin/python
# -*- coding: utf-8 -*-
'''
This script is for project AL1512
HAT platform will invoke it
'''
import os

''' Get the version name '''
#pathlist = os.listdir('./')
#for filename in pathlist:
#    if filename.endswith('rar'):
#        version_name = filename.strip('.rar')

''' Enter the version folder '''
#folder_name = version_name + '_DCC'
#print folder_name
#result = os.path.exists(folder_name)
#if result != True:
#    print "[Error]Can't find the extract fold! Please check if unrar successful!"
#    exit(-1)
#os.chdir(folder_name)
#print os.getcwd()


''' Get the inside version package name'''
pathlist = os.listdir('./')
for filename in pathlist:
    if filename.startswith('all_image'):
        part_name = filename
if part_name:
    ''' Unzip the inside version package name,and check if extract OK'''
    result = os.system("unzip " + part_name)
    if result == 0:
        print "extract OK"
else:
    print "[error] can't find all_images.zip"
    exit(-1)
