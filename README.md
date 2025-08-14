# Digital Image Processing Using Verilog

## Overview

A Verilog-based digital image processor implementing multiple image enhancement and transformation operations using behavioral modeling. The system supports eight operations, selectable via a 3-bit operation code, and utilizes Block RAM (BRAM) for image data storage and retrieval. MATLAB is used for `.coe` file generation and conversion between image formats.

## Supported Operations

| Operation Code (`[2:0]`) | Operation |
|--------------------------|-----------|
| `000` | Brightness Increase |
| `001` | Brightness Decrease |
| `010` | Grayscale |
| `011` | Red Filter |
| `100` | Green Filter |
| `101` | Blue Filter |
| `110` | Thresholding |
| `111` | Inversion |

## Key Features

* Implementation of core image processing algorithms using Verilog behavioral modeling.
* Use of **Block RAM (BRAM)** for efficient pixel-level data handling within the testbench.
* Parameterized design allowing easy addition of new image processing operations.
* MATLAB integration for `.coe` file generation and image conversion.

## BRAM Generation in Xilinx Vivado

1. Create a new BRAM IP in Vivado.
2. Rename if necessary.
3. Set data width to **24 bits** (8 bits each for red, green, and blue channels).
4. Set depth slightly greater than the total number of pixels in the image (e.g., for a `500×400` image, depth > `200,000`).

## Output Samples

**Original Image**
![Original Image](https://github.com/user-attachments/assets/b23d90f7-80ad-4608-91c4-bc640b687187)

**Brightness Increase**
![Brightness_up Image](https://github.com/user-attachments/assets/51736f94-fa1e-4657-8401-a43160f95b25)

**Brightness Decrease**
![Brightness_down Image](https://github.com/user-attachments/assets/f5688ee7-8b9c-4c1a-92cf-a48a5b64b3b1)

**Grayscale**
![Grayscale Image](https://github.com/user-attachments/assets/a543c585-ad08-46d1-ab9f-95baa7345257)

**Red Filter**
![Red Image](https://github.com/user-attachments/assets/84a21c2d-acfc-4222-95f7-ef95673ac61d)

**Green Filter**
![Green Image](https://github.com/user-attachments/assets/c2a499a6-ec96-494d-8623-6377d9bcfb25)

**Blue Filter**
![Blue Image](https://github.com/user-attachments/assets/52493e46-31ee-4ddc-85a9-5500bdd92873)

**Thresholding**
![Threshold image](https://github.com/user-attachments/assets/05a40329-f97f-4d1e-a2d5-cf0506875ac7)

**Inversion**
![Inverted Image](https://github.com/user-attachments/assets/ae74ee55-b005-4123-925b-0720c0309614)

## Tools and Technologies

* **Hardware Description Language:** Verilog (Behavioral Modeling)
* **Hardware Design Tool:** Xilinx Vivado
* **Memory Module:** Block RAM (BRAM)
* **Image Conversion Tool:** MATLAB
