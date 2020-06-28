#!/bin/bash
INPUT_DATA_FOLDER='input_data/dcm'
OUTPUT_DATA_FOLDER='output_data/dcm'

DEVICE=0
ENSEMBLE=true

function usage()
{
    echo "Run file to exectute brain lesion analysis and segmentation tool for computed tomograpphy"
    echo "according to model trained by Monteiro et al."
    echo "Read more in the paper Multi-class semantic segmentation and quantification of traumatic "
    echo "brain injury lesions on head CT using deep learning – an algorithm development and "
    echo "multi-centre validation study"
    echo ""
    echo "./run.sh"
    echo "    -h --help"
    echo "    --input-data-folder=$INPUT_DATA_FOLDER"
    echo "    --output-data-folder=$OUTPUT_DATA_FOLDER"
    echo "    --device=$DEVICE"
    lsecho "    --ensemble=$ENSEMBLE"
    echo ""
}

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -h | --help)
            usage
            exit
            ;;
        --input-data-folder)
            INPUT_DATA_FOLDER=$VALUE
            ;;
        --output-data-folder)
            OUTPUT_DATA_FOLDER=$VALUE
            ;;
        --device)
            DEVICE=$VALUE
            ;;
        --ensemble)
            ENSEMBLE=$VALUE
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done

INPUT_IMAGE='temporary_data/input_image.nii.gz'
OUTPUT_IMAGE='temporary_data/output_image.nii.gz'

echo "Stage 0: Convert DICOM input to nii"
python3 src/utilities/dcm2im.py \
    --input $INPUT_DATA_FOLDER \
    --output $INPUT_IMAGE

echo "Stage 1: Run analysis"
python3 src/console_tool.py \
    --input $INPUT_IMAGE \
    --output $OUTPUT_IMAGE \
    --ensemble $ENSEMBLE \
    --device $DEVICE

echo "Stage 2: Convert nii output results to DICOM"
/workspace/dcmqi-1.2.2-linux/bin/itkimage2segimage \
    --inputImageList $OUTPUT_IMAGE \
    --inputDICOMDirectory $INPUT_DATA_FOLDER \
    --outputDICOM "$OUTPUT_DATA_FOLDER/blast_ct.dcm" \
    --inputMetadata "/app/blast-ct-label-mapping.json"