import os
import sys
import argparse
import SimpleITK as sitk


def dcm2im(input, output):
    reader = sitk.ImageSeriesReader()
    dcm_files = reader.GetGDCMSeriesFileNames(input)
    reader.SetFileNames(dcm_files)
    image = reader.Execute()
    os.makedirs(os.path.dirname(output), exist_ok=True)
    sitk.WriteImage(image, output)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--input', metavar='input', type=str, help='Folder with DICOM images', required=True)
    parser.add_argument('--output', metavar='output', type=str, help='Output image file path.', required=True)
    args = parser.parse_args()

    dcm2im(args.input, args.output)