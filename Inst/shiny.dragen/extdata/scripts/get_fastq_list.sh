#!/bin/bash

## how to use
## ./get_fastq-list.sh -i /path/to/input/directory -o /path

# Default values for input arguments
input_path=""
output_path="."
output_file="fastq-list.csv"

# Function to display help
function display_help() {
  echo "Usage: $0 -i INPUT_PATH -o OUTPUT_PATH -f OUTPUT_FILE"
  echo "Generate a fastq-list.csv file from the input directory containing the fastq files."
  echo ""
  echo "Options:"
  echo "  -i, --input_path  The input path to the directory containing the fastq files"
  echo "  -o, --output_path  The output path to save the fastq-list.csv file"
  echo "  -f, --output_file  The name of the output file"
  echo "  -h, --help           Display this help message"
}

# Parse input arguments
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -i|--input_path)
      input_path="$2"
      shift
      ;;
    -o|--output_path)
      output_path="$2"
      shift
      ;;
    -f|--output_file)
      output_file="$2"
      shift
      ;;
    -h|--help)
      display_help
      exit 0
      ;;
    *)
      echo "Unknown option: $key"
      display_help
      exit 1
      ;;
  esac
  shift
done

# check if the input path is provided
if [ -z "$input_path" ]; then
    echo "Error: Input path must be provided"
    display_help
    exit 1
fi

# check if the input path exists
if [ ! -d "$input_path" ]; then
    echo "Error: Input path $input_path does not exist."
    display_help
    exit 1
fi

# check if the output path is provided
if [ -z "$output_path" ]; then
    echo "Error: Output path must be provided"
    display_help
    exit 1
fi

# check if the output path is a directory
if [ ! -d "$output_path" ]; then
    echo "Error: Output path $output_path is not a directory."
    display_help
    exit 1
fi

dir=$(ls $input_path | grep -Ev .*json)

output_file="$output_path/$output_file"

echo "RGID,RGSM,RGLB,Lane,Read1File,Read2File" > "$output_file"
#echo "RGID,RGSM,RGLB,Lane,Read1File,Read2File"

total=$(ls $input_path | grep -Ev .*json | wc -l)
count=0

for d in $dir; do
    folder=$(ls $input_path/$d)
    for f in $folder; do
        SM=$(echo $f | cut -d"_" -f1)                                   ##sample ID
        LB=$(echo $f | cut -d"_" -f1,2)                                 ##library ID
        PL="Illumina"                                                    ##platform (e.g. illumina, solid)
        Lane=$(echo $f | awk -F '[_]' '{printf $6}')
        RGID=$(zcat $input_path/$d/$f | head -n1 | sed 's/:/_/g' | cut -d "_" -f10) ##read group identifier 
        PU=$RGID.$LB                                                      ##Platform Unit
        Read1File=$(echo $input_path/$f)
        Read2File=$(echo $Read1File | sed 's/R1_001/R2_001/g')
        echo -e "$RGID,$SM,$LB,$Lane,$Read1File,$Read2File" >> "$output_file"
        echo -e "$RGID,$SM,$LB,$Lane,$Read1File,$Read2File"
    done
    wait
    # Increment the counter and output the progress
    count=$((count + 1))
    progress=$((count * 100 / total))
    echo $progress
done