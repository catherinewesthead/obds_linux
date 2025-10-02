/project/sedm6772/linux/3_analysis/rnaseq_commands.sh

#Fastqc code:
fastqc /project/sedm6772/linux/2_rnaseq/1_fastq/fastq_pair/cd4_rep1_read1.fastq.gz -o /project/sedm6772/linux/3_analysis/1_fastqc/

fastqc /project/sedm6772/linux/2_rnaseq/1_fastq/fastq_pair/cd4_rep1_read2.fastq.gz -o /project/sedm6772/linux/3_analysis/1_fastqc/

#multiqc code
mutliqc /project/sedm6772/linux/3_analysis/1_fastqc/cd4_rep1_read1_fastqc.zip /project/sedm6772/linux/3_analysis/1_fastqc/cd4_rep1_read2_fastqc.zip -o /project/sedm6772/linux/3_analysis/reports

#copying files from ssh to my local computer 
scp obds:/project/sedm6772/linux/3_analysis/1_fastqc/cd4_rep1_read1_fastqc.html .
