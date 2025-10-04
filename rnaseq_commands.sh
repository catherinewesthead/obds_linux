#Fastqc code:
fastqc /project/sedm6772/linux/2_rnaseq/1_fastq/fastq_pair/cd4_rep1_read1.fastq.gz -o /project/sedm6772/linux/3_analysis/1_fastqc/

fastqc /project/sedm6772/linux/2_rnaseq/1_fastq/fastq_pair/cd4_rep1_read2.fastq.gz -o /project/sedm6772/linux/3_analysis/1_fastqc/

#multiqc code
mutliqc /project/sedm6772/linux/3_analysis/1_fastqc/cd4_rep1_read1_fastqc.zip /project/sedm6772/linux/3_analysis/1_fastqc/cd4_rep1_read2_fastqc.zip -o /project/sedm6772/linux/3_analysis/reports

#copying files from ssh to my local computer 
scp obds:/project/sedm6772/linux/3_analysis/1_fastqc/cd4_rep1_read1_fastqc.html .

# alias to easily enter mamba environment: 

alias load_mamba='source /project/$USER/mamba_installation/conda/etc/profile.d/conda.sh && source /project/$USER/mamba_installation/conda/etc/profile.d/mamba.sh && mamba activate base && mamba activate obds-rnaseq' 

# writing a command for slurm: requires creation of a .sh file with the following content (this is a template that would require editing depending on the requirements of the command

#!/bin/bash
##########################################################################
## A script template for submitting batch jobs. To submit a batch job,
## please type
##
##    sbatch script_name.sh
##
## Please note that anything after the characters "#SBATCH" on a line
## will be treated as a Slurm option.
##########################################################################

## Specify a partition. Check available partitions using sinfo Slurm command.
#SBATCH --partition=short

## The following line will send an email notification to your registered email
## address when the job ends or fails.
#SBATCH --mail-type=END,FAIL

## Specify the amount of memory that your job needs. This is for the whole job.
## Asking for much more memory than needed will mean that it takes longer to
## start when the cluster is busy.
#SBATCH --mem=10G

## Specify the number of CPU cores that your job can use. This is only relevant for
## jobs which are able to take advantage of additional CPU cores. Asking for more
## cores than your job can use will mean that it takes longer to start when the
## cluster is busy.
#SBATCH --ntasks=8

## Specify the maximum amount of time that your job will need to run. Asking for
## the correct amount of time can help to get your job to start quicker. Time is
## specified as DAYS-HOURS:MINUTES:SECONDS. This example is one hour.
#SBATCH --time=0-01:00:00

## Provide file name (files will be saved in directory where job was ran) or path
## to capture the terminal output and save any error messages. This is very useful
## if you have problems and need to ask for help.
#SBATCH --output=hisat2_%x.out
#SBATCH --error=hisat2_%x.err
## ################### CODE TO RUN ##########################
# Load modules (if required - e.g. when not using conda)
# module load R-base/4.3.0

# Execute these commands

#the command to run mapping to the genome looks like this (\ important when writing a continuous command over multiple lines)

hisat2 --threads 8 \
-x /project/shared/linux/5_rnaseq/hisat2_index/grcm39 \
-1 /project/sedm6772/linux/2_rnaseq/1_fastq/fastq_pair/cd4_rep1_read1.fastq.gz \
-2 /project/sedm6772/linux/2_rnaseq/1_fastq/fastq_pair/cd4_rep1_read2.fastq.gz \
--rna-strandness RF \
--summary-file stats.txt \
-S /project/sedm6772/linux/3_analysis/aln-pe.sam

# it is important to match the number of threads to the --ntasks= specified!

# read mapping makes sam files - these need to be converted to bam files for further steps
# this required the following slurm script
#!/bin/bash
##########################################################################
## A script template for submitting batch jobs. To submit a batch job,
## please type
##
##    sbatch script_name.sh
##
## Please note that anything after the characters "#SBATCH" on a line
## will be treated as a Slurm option.
##########################################################################

## Specify a partition. Check available partitions using sinfo Slurm command.
#SBATCH --partition=short

## The following line will send an email notification to your registered email
## address when the job ends or fails.
#SBATCH --mail-type=END,FAIL

## Specify the amount of memory that your job needs. This is for the whole job.
## Asking for much more memory than needed will mean that it takes longer to
## start when the cluster is busy.
#SBATCH --mem=10G

## Specify the number of CPU cores that your job can use. This is only relevant for
## jobs which are able to take advantage of additional CPU cores. Asking for more
## cores than your job can use will mean that it takes longer to start when the
## cluster is busy.
#SBATCH --ntasks=4

## Specify the maximum amount of time that your job will need to run. Asking for
## the correct amount of time can help to get your job to start quicker. Time is
## specified as DAYS-HOURS:MINUTES:SECONDS. This example is one hour.
#SBATCH --time=0-01:00:00

## Provide file name (files will be saved in directory where job was ran) or path
## to capture the terminal output and save any error messages. This is very useful
## if you have problems and need to ask for help.
#SBATCH --output=samtools_%x.out
#SBATCH --error=samtools_%x.err
## ################### CODE TO RUN ##########################
# Load modules (if required - e.g. when not using conda)
# module load R-base/4.3.0
# Execute these commands


samtools view --threads 4 -b aln-pe.sam > aln-pe.bam &&
samtools sort --threads 4 aln-pe.bam > sorted_aln-pe.bam &&
samtools index sorted_aln-pe.bam &&
samtools flagstat sorted_aln-pe.bam > sorted_aln-pe.flagstat &&
samtools idxstats sorted_aln-pe.bam > sorted_aln-pe.idxstats

# multiqc can be used to visualise outputs
# to run multiqc the command is simple and can be conducted on the cluster 
multiqc <file path> e.g., /project/sedm6772/limux/3_analysis 
# this command should find relevant files


#!/bin/bash
##########################################################################
## A script template for submitting batch jobs. To submit a batch job,
## please type
##
##    sbatch script_name.sh
##
## Please note that anything after the characters "#SBATCH" on a line
## will be treated as a Slurm option.
##########################################################################

## Specify a partition. Check available partitions using sinfo Slurm command.
#SBATCH --partition=short

## The following line will send an email notification to your registered email
## address when the job ends or fails.
#SBATCH --mail-type=END,FAIL

## Specify the amount of memory that your job needs. This is for the whole job.
## Asking for much more memory than needed will mean that it takes longer to
## start when the cluster is busy.
#SBATCH --mem=10G

## Specify the number of CPU cores that your job can use. This is only relevant for
## jobs which are able to take advantage of additional CPU cores. Asking for more
## cores than your job can use will mean that it takes longer to start when the
## cluster is busy.
#SBATCH --ntasks=1

## Specify the maximum amount of time that your job will need to run. Asking for
## the correct amount of time can help to get your job to start quicker. Time is
## specified as DAYS-HOURS:MINUTES:SECONDS. This example is one hour.
#SBATCH --time=0-01:00:00

## Provide file name (files will be saved in directory where job was ran) or path
## to capture the terminal output and save any error messages. This is very useful
## if you have problems and need to ask for help.
#SBATCH --output=featurecounts_.out
#SBATCH --error=featurecounts_.err
## ################### CODE TO RUN ##########################
# Load modules (if required - e.g. when not using conda)
# module load R-base/4.3.0

# Execute these commands


featureCounts -t exon -g gene_id -p -a /project/sedm6772/linux/2_rnaseq/2_genome/Mus_musculus.GRCm39.115.gtf.gz -o counts.txt \
/project/sedm6772/linux/3_analysis/sorted_aln-pe.bam



