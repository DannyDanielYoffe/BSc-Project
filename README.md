# BSc-Project
Designing an Image Sensor Array for Hardware Implemented Neural Network Applications”.
Project was submitted as part of the requirements for the bachelor’s degree in the Faculty of Engineering, Bar-Ilan University
For full information see "Designing_an_Image_Sensor_Array_for_Hardware_Implemented_Neural_Network_Applications.pdf"  PDF file.

This project aimed to design a novel model of weight based current-division-capable photo sensing device (Weight-Based CAPD), implemented within an image sensing array and utilizing spatial connectivity and real-time feedback. 

Stage 1:
Input variables into Virtuoso Masetro simulation using:
  1. for Image Sensing: "image_sense_1_csv_variable_input.m"
  2. for Image Sensing with real-time feedback: "feedback_1_csv_variable_input.m"

Stage 2:
Copy into Virtuoso Schematic corresponding connectivity labels between WBCAPD (15x15) array and 4T Pixel (16x16) array (2 layer rectangular pyramid):
  1.1. For Image Sensing Simulation: ROW 1-4 'WBCAPD_input_edge_detection_label_names.xls'
  1.2. For Image Sensing Simulation with real-time feedback: ROW 6-9 'WBCAPD_input_edge_detection_label_names.xls'
  2.   Pixel control signal labels: 'pixel_control_16x16.xls'

stage 3: 
Run Simulations and save as CSV files:
  1. Image Sense simulation save as: 'is_results.csv'
  2. Image Sense with real-time feedback simulation save as: 'fb_results.csv'

Stage 4:
run "csv_to_image_v2_edge_detection.m" to perform edge detection algorithm
