# BinocularStereoComputerVision
## Performing Dense correspondence matching and Depth Image Generation using matlab
### University of Nottingham

## Setting up the enviroment:
For this project the following set up was used:
- Matlab 9.5 	R2018b

## Installation steps:
- Run the code in the ```Matlab``` software.

## Project Description
### Abstract
**Dense correspondence matching** and **disparity maps** are one of the most common topics in Computer Vision due to the variety of applications. This project present an approach to fill up the disparity map (horizontal disparity) by applying **gradients** to the input images of any size. Additionally,it merges the concepts of patch matching (find k nearest neighbors) and normalized correlation to compare the best correspondence to generate a efficient mapping and a simple way to generate it. The algorithm is composed of 4 basic steps. Increase the size of the given images, apply the method based-gradient features, use patches in both images to compare them, and use the normalized correlation to identify the best correspondence matching for a given patch.

### Introduction
There are many dense correspondence matching methods,the most popular ones are: **Basic stereo matching (pixel by pixel), Histograms of oriented gradients, Dynamic programming, graphs**. However, the majority of them need a depth understanding and do not result in a time high performance
methods. **Patching matching** correspondence is frequently use to compare similar images. Now let's consider to compare one patch from an image with k patches from the other image, these comparison will take place with the following neighbors in the horizontal axis. As shown in the following image:

![](ImgReadme/Patches.png) 

### Methology
Assuming 2 rectified images (image left and image right).Determine the size of both of them before setting the patch size, this one is depended on the dimensions of the images **(higher the resolution greater the patch size)**. The **patch size** must be **odd and equal on sides**, the reason is to locate the centre of it in the position of the desired pixel to be analyzed. Then two additional matrices are created for each image with bigger dimensions (2 times the patch size in all the dimensions) than the originals, this is to avoid ’ifstatements’ inside the loop iterations and optimize the speed performance of the coding. The rectified images will be inserted in position (patch offset, patch offset) for the upperleft edge. 

Apply the **Gradients-Based Features** approach to extract useful information of both images. Once the gradients magnitude and the direction of the bigger images are obtained,patches will be located at the first pixel of the image (which is inside the bigger image) in both images. As shown in Image:
2.
![](ImgReadme/patch_init_pos.png) 

For every patch of the right image, there will be **2 times the patch offset comparisons** with different patches from the left image. These similarities will be scored using the matching process Normalised Correlation, see equation 1,and only the best result will be taken into account. The final step is to determine the column position of the best score and subtract it to the current column position of the right image. The result will be stored in the position right images pixel position.

## Project Outcome
The following results were made in a 375x450 image dimension. The disparity map was calculated with
**different patch** sizes and as expected the output changes with all of them. 

![Los 5 ositos](ImgReadme/Output_diff_patch_size.png) 

Additionally, the times of the were proportional to the patch siz as shown in the following graph. However, there is a intermediate patch size which has the best output and time, in this case it is the 31x31 patch size for 375x450 input images.

![La grafica](ImgReadme/graph.png)


