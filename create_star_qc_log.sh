#!/bin/bash

# Set the path to your STAR output directory
log_folder=$1
output_file="${log_folder}/STAR_alignment_summary.tsv"

# Header for the output file
echo -e "Sample\tInput_Reads\tUniquely_Reads\tUniquely_Percent\tMulti_Reads\tMulti_Percent\tUnmapped_TooManyMismatch\tUnmapped_TooManyMismatch_Percent\tUnmapped_TooShort\tUnmapped_TooShort_Percent\tUnmapped_Other\tUnmapped_Other_Percent" > "$output_file"

# Iterate through all Log.final.out files
for logfile in "${log_folder}"*_Log.final.out; do
    # Extract sample name from filename
    sample=$(basename "$logfile" | sed 's/_Log\.final\.out$//')

    # Extract each value
    input_reads=$(grep "Number of input reads" "$logfile" | awk '{print $NF}')
    uniquely_mapped_reads=$(grep "Uniquely mapped reads number" "$logfile" | awk '{print $NF}')
    uniquely_mapped_percent=$(grep "Uniquely mapped reads %" "$logfile" | awk '{print $NF}')
	multi_mapped_reads=$(grep "Number of reads mapped to multiple loci" "$logfile" | awk '{print $NF}')
	multi_mapped_percent=$(grep "% of reads mapped to multiple loci" "$logfile" | awk '{print $NF}')
    unmapped_mismatch=$(grep "Number of reads unmapped: too many mismatches" "$logfile" | awk '{print $NF}')
    unmapped_mismatch_percent=$(grep "% of reads unmapped: too many mismatches" "$logfile" | awk '{print $NF}')
    unmapped_short=$(grep "Number of reads unmapped: too short" "$logfile" | awk '{print $NF}')
    unmapped_short_percent=$(grep "% of reads unmapped: too short" "$logfile" | awk '{print $NF}')
    unmapped_other=$(grep "Number of reads unmapped: other" "$logfile" | awk '{print $NF}')
    unmapped_other_percent=$(grep "% of reads unmapped: other" "$logfile" | awk '{print $NF}')

    # Print to the output file
    echo -e "${sample}\t${input_reads}\t${uniquely_mapped_reads}\t${uniquely_mapped_percent}\t${unmapped_mismatch}\t${unmapped_mismatch_percent}\t${unmapped_short}\t${unmapped_short_percent}\t${unmapped_other}\t${unmapped_other_percent}" >> "$output_file"
done

echo "Summary written to: $output_file"
