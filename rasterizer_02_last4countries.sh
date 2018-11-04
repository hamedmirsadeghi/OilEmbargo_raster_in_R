#!/bin/sh
#$ -cwd           # Set the working directory for the job to the current directory
#$ -pe smp 7            # Request 17 processor cores
#$ -l h_vmem=50G         # Request 2GB of RAM per core used (4GB total)
#$ -l h_rt=100:00:0       # Max. run time of 3 days
#$ -j y                 # Join stdout and stderr
#$ -m be                # When to send alerts b=beginning, e=end, a=abort, s=suspend
#$ -M hamed.mirsadeghi@barcelonagse.eu # email address for alerts

# Load the R module
module load gcc R
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/data/home/mpx383/install/lib
export PATH=$PATH:/data/home/mpx383/install/bin
export INCLUDE=$INCLUDE:/data/home/mpx383/install/include
export UDUNITS2_LIBS=/data/home/mpx383/install/lib
export UDUNITS2_INCLUDE=/data/home/mpx383/install/include

# Pass the job parameters to R for processing
Rscript rasterizer_02_last4countries.R
