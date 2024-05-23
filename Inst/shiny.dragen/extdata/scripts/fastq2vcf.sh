#!/bin/bash
############################################################
# Help                                                     #
############################################################
Help()
{
   # Display Help
   echo "Processing of a list of Fastq (multiple samples) to VCF."
   echo
   echo "-h     Print this Help."
   echo "-r     Path to the reference genome."
   echo "Syntax: scriptTemplate [-f|i|o|r]"
   echo "options:"
   echo "-f     Path to fastqList.csv."
   echo "-i     Path to input_dir."
   echo "-o     Path to output_dir."
   echo "-r     Path to the reference genome."
#   echo "prefix        Prefix to output_dir."
   echo
   echo "Usage: "
   echo
   echo " ./fastq2vcf.sh -f fastq-list.csv -o output_dir -r reference_genome"
   echo
}

################################################################################
# Process the input options. Add options as needed.                            #
################################################################################

unset -v path_fastqList
unset -v path_input_dir
unset -v path_output_dir
unset -v path_reference_genome

# Get the options
while getopts ":h:f:i:o:r:" option; do
    case $option in
         h) # display Help
            Help
            exit;;
         f) # fastq-list.csv path
            path_fastqList=${OPTARG};;
         i) # path to input-directory
            path_input_dir=$OPTARG;;
         o) # path to output-dir
            path_output_dir=${OPTARG};;
         r) # path to reference genome
            path_reference_genome=${OPTARG};;
         \?) # Invalid option
            echo "Error: Invalid option: -$OPTARG" >&2
            exit;;
    esac
done

################################################################################
# Mandotary arguments                                                           #
################################################################################

if [ -z "$path_fastqList" ] ; then
        echo 'Missing -f argument for fastq-list.csv file' >&2
        exit 1
fi
if  [ -z "$path_output_dir" ]; then
         echo 'Missing -o argument for output directory' >&2
         exit 1
fi
if [ -z "$path_reference_genome" ]; then
    echo 'Missing -r argument for reference genome' >&2
    exit 1
fi
################################################################################
# Main program                                                                 #
################################################################################

pattern="RGID,RGSM,RGLB,Lane,Read1File,Read2File"

header=$(head -n1 $path_fastqList)

## check if fast-list is in correct format
if [[ "$path_fastqList" =~ \.csv$ ]] && [[ "$header" =~ "$pattern" ]]
then
    #echo "fastq-list file is in correct format"

    RGSM=$(cat $path_fastqList | cut -f2 -d, | tail -n +2)
    #echo $RGSM
    for sample in $RGSM
    do
       if ! test -d "$path_output_dir/$sample" 
        then
            mkdir "$path_output_dir/$sample"            
       fi
      #echo "$path_output_dir/$sample : exists"
      nohup echo "$sample : $(date '+%d/%m/%Y %H:%M:%S')"
      #echo $(date '+%d/%m/%Y %H:%M:%S')
      SECONDS=0
      sleep 2
       # nohup dragen -f \
       # -r $path_reference_genome \
       # --fastq-list-sample-id $sample \
       # --fastq-list $path_fastqList \
       # --enable-variant-caller true \
       # --output-directory $path_output_dir/$sample \
       # --output-file-prefix $sample \
       # --enable-duplicate-marking true \
       # --enable-map-align-output true
       duration=$SECONDS
       nohup echo "=================================================================="
       nohup echo "$((duration / 60)) minutes and $((duration % 60)) seconds elapsed."
       nohup echo "=================================================================="

    done
else
    echo "fastq-list file is not in correct format"

fi