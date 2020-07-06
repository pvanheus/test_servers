#!/bin/bash

if [[ $# -ne 2 ]] ; then
	echo "Usage: run_bwa.sh <fastq1> <fastq2>" >&2
	exit 1
fi

GENOME=MN908947_3_Wuhan-Hu-1.fasta
if [[ ! -f ${GENOME}.amb ]] ; then 
	bwa index ${GENOME}
fi

OUTPUT_FILE=$(basename $1 | sed 's/_.*//' ).sam
bwa mem ${GENOME} $1 $2 >$OUTPUT_FILE
