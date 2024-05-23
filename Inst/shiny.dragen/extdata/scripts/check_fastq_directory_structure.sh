#!/bin/bash

# # Display help message and exit
# function help() {
#   echo "Usage: $0 [-i <input_directory>]"
#   echo "Checks if the input directory has the expected structure for fastq files."
#   echo ""
#   echo "Options:"
#   echo "  -i, --input_path <input_directory>: The directory to check. Must contain subdirectories with"
#   echo "                       names that match the pattern [A-Za-z0-9]+_[A-Za-z0-9]+\.[A-Za-z0-9]+"
#   echo "                       and exactly two .fastq.gz files per subdirectory."
#   echo "  -h, --help  Display this help message and exit."
#   exit 0
# }
# 
# # Parse input path argument
# while getopts ":i:h" opt; do
#   case $opt in
#     -i|--input_path)
#       input_dir=$OPTARG
#       ;;
#     -h|--help )
#       help
#       ;;
#     \?)
#       echo "Invalid option: -$OPTARG" >&2
#       help
#       ;;
#     :)
#       echo "Option -$OPTARG requires an argument." >&2
#       help
#       ;;
#   esac
# done
# 
# # Set default input directory
# if [ -z "$input_dir" ]; then
#   input_dir="/media/DATA/fastq/fastq"
# fi

input_dir=$1

# Check if the input directory exists
if [ ! -d "$input_dir" ]; then
  echo "Error: Input directory does not exist."
  exit 1
fi

# Loop through each subdirectory in the input directory
for subdir in "$input_dir"/*; do
  foldername=$(basename $subdir)
  # Check if the subdirectory is a directory
  if [ ! -d "$foldername" ]; then
    continue
  fi

  # Check if the subdirectory name matches the expected pattern
  if [[ ! "$foldername" =~ ^[A-Z]{1}[0-9]{2}_[A-Za-z0-9]+\.[A-Za-z0-9]+$ ]]; then
    echo "Error: Subdirectory name does not match expected pattern: $foldername"
    exit 1
  fi

  # Check if there are exactly two .fastq.gz files in the subdirectory
  num_fastq_files=$(find "$foldername" -maxdepth 1 -type f -name "*.fastq.gz" | wc -l)
  if [ "$num_fastq_files" -ne 2 ]; then
    echo "Error: Expected 2 .fastq.gz files in subdirectory, found $num_fastq_files: $foldername"
    exit 1
  fi
done

# If we made it this far, the input directory has the expected structure
echo "Input directory has the expected structure."