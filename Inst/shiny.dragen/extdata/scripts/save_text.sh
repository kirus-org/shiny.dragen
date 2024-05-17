#!/bin/bash

# Default values for input arguments
text=""
output_folder="."
file_name=""

# Function to display help
function display_help() {
  echo "Usage: $0 -t TEXT -o OUTPUT_FOLDER -m FILE_NAME"
  echo "Save the provided text as a file in the specified output folder."
  echo ""
  echo "Options:"
  echo "  -t, --text TEXT      The text to save as a file"
  echo "  -o, --output_folder  The output folder to save the file"
  echo "  -m, --file_name      The name of the file to save"
  echo "  -h, --help           Display this help message"
}

# Parse input arguments
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -t|--text)
      text="$2"
      shift
      ;;
    -o|--output_folder)
      output_folder="$2"
      shift
      ;;
    -m|--file_name)
      file_name="$2"
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

# Check if text, output folder, and file name are provided
if [ -z "$text" ] || [ -z "$output_folder" ] || [ -z "$file_name" ]; then
  echo "Please provide text, output folder, and file name."
  display_help
  exit 1
fi

# Save text as file
echo "$text" > "$output_folder/$file_name"
echo "File '$file_name' saved in '$output_folder'."