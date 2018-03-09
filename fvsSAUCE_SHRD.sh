#!/bin/bash

#fvsSAUCE_SHRD.sh $subject

#SAUCE: created to launch freeview in any place you want 
#      : because I can have my cake and eat it too

SUBJ=$1
DATADIR=/Volumes/data/fs_subjects/${SUBJ}anat/ 

cd $DATADIR

freeview -v \
mri/T1.mgz \
mri/wm.mgz \
mri/brainmask.mgz \
mri/aseg.mgz:colormap=lut:opacity=0.2 \
-f \
surf/lh.white:edgecolor=blue \
surf/lh.pial:edgecolor=red \
surf/rh.white:edgecolor=blue \
surf/rh.pial:edgecolor=red