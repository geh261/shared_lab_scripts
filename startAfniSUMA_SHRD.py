# startAfniSUMA_SHRD $subj4suma
# SAUCE: call this script where you want to launch afni and suma
#      : replace root to where your subjects uma direcotry is located 
#      : you could also update the time between afni and suma command, default at 60 sec in case a large data set is being loaded to afni

import os
import time
import sys

subj4suma=sys.argv[1]

root="/Volumes/data/vRF_tcs/"
SUMAcommand="suma -spec "+str(root)+""+str(subj4suma)+"/"+str(subj4suma)+"anat/SUMA/"+str(subj4suma)+"anat_both.spec -sv "+str(root)+""+str(subj4suma)+"/"+str(subj4suma)+"anat/SUMA/"+str(subj4suma)+"anat_SurfVol+orig.HEAD &"
os.system("afni -niml &")
print("\nWaiting for afni to get set up\n")
time.sleep(30)
print("Waiting.....")
os.system(SUMAcommand)
time.sleep(20)
print(" !!!!! \n To activate connection between SUMA window and afni: press 't' on your keyboard\n !!!!! ")
