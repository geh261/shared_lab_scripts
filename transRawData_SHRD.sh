#!/bin/bash

#transRawData_SHRD.sh $teslaUsername
# SAUCE: use to transfer files from tesla to local directory and rename files for preprocessing
# WARNING this code implies you only have one HEAD and BODY coil scan 
# Will need txt file with aquisition number of data you want to transfer (see below for more details)
# Will need location of raw scans and also location for new scans
# TODO: when I have time make sure to include and if then statement for absense of session and name in the files to be transfered 

USERNAMETESLA=$1 

# number of distortion scan pairs
NUMOFAPPA=4
# raw data directory info
DATAROOTRAWDIR=/CBI/UserData/curtislab/
SUBJRAW=RC_RF1_2018-03-01
# new directory info
DATAROOTNEWDIR=/Volumes/data/vRF_shared/
SUBJNEW=RC
SESSION=RF1
# fs subjects directory
DATAFSSUBJ=/Volumes/data/fs_subjects/
# Grabbing scanner session raw data and transfering to new directory
scp $USERNAMETESLA@tesla.cbi.fas.nyu.edu:$DATAROOTRAWDIR/$SUBJRAW/*/\{*2mm.nii.gz,*DISTORTION_AP.nii.gz,*DISTORTION_PA.nii.gz,*+T*.nii.gz,*HeadCoil.nii.gz,*BodyCoil.nii.gz\} $DATAROOTNEWDIR/$SUBJNEW/$SESSION
# create a text file in new directory location:
# name text file ${SUBJNEW}_${SESSION}_rawFile_list.txt and save in $DATAROOTNEWDIR/$SUBJNEW/$SESSION/
# format is acquisition number of body and head coil in one line (first BODY, then HEAD), then distortion scan pair every one line (first AP, then PA), and finally epi acqusition number every one line 
# seperate numbers in same line with comma
# e.g. 
#  1,2
#  3,4
#  5,6
#  07
#  09
#  11
# setting these variables to number new files and for if then statemnt 
numStart=1
NEWFILENUM=0
NEWFILENUMepi=1
# Heading into new direcoty
cd $DATAROOTNEWDIR/$SUBJNEW/$SESSION/
# text file delimiter 
IFS=','
## #  IFS - The Internal Field Separator that is used for word
## #  splitting after expansion and to split lines into words
## #  with  the  read  builtin  command. The default value is
## #  ``<space><tab><newline>''

# Start of while loop to rename raw data in new directory
cat $DATAROOTNEWDIR/$SUBJNEW/$SESSION/${SUBJNEW}_${SESSION}_rawFile_list.txt | while read line
do
	if [ "$NEWFILENUM" -eq 0 ]; then
	    set $line
	    BODY=$1 
		HEAD=$2
		mv $DATAROOTNEWDIR/$SUBJNEW/$SESSION/${SUBJRAW}+${BODY}+BIAS_BodyCoil.nii.gz $DATAROOTNEWDIR/$SUBJNEW/$SESSION/body_receive_field.nii.gz
		mv $DATAROOTNEWDIR/$SUBJNEW/$SESSION/${SUBJRAW}+${HEAD}+BIAS_HeadCoil.nii.gz $DATAROOTNEWDIR/$SUBJNEW/$SESSION/head_receive_field.nii.gz
		NEWFILENUM=$((NEWFILENUM + numStart))
	elif [ "$NEWFILENUM" -ge 1 ] && [ "$NEWFILENUM" -le "$NUMOFAPPA" ]; then	
    	set $line
    	AP=$1 
		PA=$2
		# Renaming distortion files
		mv $DATAROOTNEWDIR/$SUBJNEW/$SESSION/${SUBJRAW}+${AP}+SE_DISTORTION_AP.nii.gz $DATAROOTNEWDIR/$SUBJNEW/$SESSION/blip_rev${NEWFILENUM}.nii.gz
		mv $DATAROOTNEWDIR/$SUBJNEW/$SESSION/${SUBJRAW}+${PA}+SE_DISTORTION_PA.nii.gz $DATAROOTNEWDIR/$SUBJNEW/$SESSION/blip_for${NEWFILENUM}.nii.gz
		NEWFILENUM=$((NEWFILENUM + numStart))
	elif [ "$NEWFILENUM" -gt "$NUMOFAPPA" ]; then
		set $line
		EPI=$1
		#if [ "$NEWFILENUMepi" -le 9 ]; then
		NEWFILENUMepi_float=$(printf "%02.f" $NEWFILENUMepi)
		mv $DATAROOTNEWDIR/$SUBJNEW/$SESSION/${SUBJRAW}+${EPI}+cmrr_mbepi_s4_2mm.nii.gz $DATAROOTNEWDIR/$SUBJNEW/$SESSION/run${NEWFILENUMepi_float}.nii.gz
		NEWFILENUMepi=$((NEWFILENUMepi + numStart))
		#else
		#mv $DATAROOTNEWDIR/$SUBJNEW/$SESSION/${SUBJRAW}+${EPI}+cmrr_mbepi_s4_2mm.nii.gz $DATAROOTNEWDIR/$SUBJNEW/$SESSION/run${NEWFILENUMepi}.nii.gz
		#NEWFILENUMepi=$((NEWFILENUMepi + numStart))
		#fi
	fi
done

# Move T1 and T2 files to fs_subjects directory 
mv $DATAROOTNEWDIR/$SUBJNEW/$SESSION/*+T*.nii.gz $DATAFSSUBJ/${SUBJNEW}src/
