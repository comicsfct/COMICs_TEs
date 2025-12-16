#!/bin/bash
# source "/mnt/comics-data/mb.soares/miniconda3/etc/profile.d/conda.sh"
# conda activate base
samples_folder=$1 # path/to/folder with .fastq samples
output_file=$2 # path/to/output folder

# For Paired-end
total_samples=$(ls ${samples_folder}*_1.fastq | wc -l)


echo "============================"
echo "Total Samples to Align: ${total_samples}"
echo "============================"

counter=1

for file in ${samples_folder}*_1.fastq; do

       # find files with suffix .fastq for the alignment
       filename=$(basename -- "$file")
       echo ${filename%_*}
       path=$(dir -- "$file")
		
		# Skip the unwanted file
#		if [[ "$filename" == "SRR1299319_1.fastq" ]]; then
#			echo "Skipping $filename"
#			((counter++))
#			continue
#		fi

       echo "(${counter} / ${total_samples}) mapping paired-end reads: ${file%_*}_1.fastq ${file%_*}_2.fastq"

       STAR --runThreadN 16  \
       --genomeDir  "/mnt/comics-data/COMICSlab/genomes/human/GRCh38.primary_assembly/STAR_index/" \
		--limitSjdbInsertNsj 6000000 \
		--alignIntronMax 500000 \
		--alignMatesGapMax 500000 \
		--alignEndsType EndToEnd \
       --outFileNamePrefix ${output_file}/${filename%_*}_ \
       --outFilterMultimapNmax 1 \
		--outFilterMismatchNmax 999 \
		--outFilterMismatchNoverLmax 0.03 \
		--seedMultimapNmax 20000 \
		--outSAMattributes All \
		--outSAMmultNmax 1 \
       --outSAMtype BAM SortedByCoordinate \
       --readFilesIn ${file%_*}_1.fastq ${file%_*}_2.fastq 
 
      ((counter++))

done

# For single end
# total_samples=$(ls ${samples_folder}*.fastq | wc -l)


# echo "============================"
# echo "Total Samples to Align: ${total_samples}"
# echo "============================"

# counter=1

# ulimit -n 100000

# for file in ${samples_folder}*.fastq; do

        # # find files with suffix .fastq for the alignment
        # filename=$(basename -- "$file")
        # echo ${filename}
        # # path=$(dir -- "$file")

        # echo "(${counter} / ${total_samples}) mapping single-end reads: ${filename}"

        # STAR --runThreadN 32  \
        # --genomeDir  "/mnt/comics-data/COMICSlab/genomes/human/GRCh38.primary_assembly/STAR_index/" \
		# --limitSjdbInsertNsj 6000000 \
		# --alignIntronMax 500000 \
		# --alignMatesGapMax 500000 \
		# --alignEndsType EndToEnd \
        # --outFileNamePrefix ${output_file}/${filename%_*}_ \
        # --outFilterMultimapNmax 1 \
		# --outFilterMismatchNmax 999 \
		# --outFilterMismatchNoverLmax 0.03 \
		# --seedMultimapNmax 20000 \
		# --outSAMattributes All \
		# --outSAMmultNmax 1 \
        # --outSAMtype BAM SortedByCoordinate \
        # --readFilesIn ${file} 
 
       # ((counter++))

# done