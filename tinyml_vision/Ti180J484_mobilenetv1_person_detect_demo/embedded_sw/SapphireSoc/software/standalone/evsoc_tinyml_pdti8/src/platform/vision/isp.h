#define ABS(x)       (x < 0 ? -x : x)

void rgb2grayscale (volatile uint32_t in_array [], volatile uint32_t out_array [], uint32_t width, uint32_t height) {
   uint8_t red, green, blue, grayscale;

   for (int i=0; i<(width*height); i++) {
      red   = ( in_array [i])        & 0xff;
      green = ((in_array [i]) >> 8)  & 0xff;
      blue  = ((in_array [i]) >> 16) & 0xff;

      grayscale     = (30*red + 59*green + 11*blue)/100;
      out_array [i] = (grayscale << 16) + (grayscale << 8) + (grayscale);
   }

   return;
}

void sobel_edge_detection (volatile uint32_t in_array [], volatile uint32_t out_array [], uint32_t width, uint32_t height) {
//   char sobel_Gx [3][3] = {
//      -1,  0,  1,
//      -2,  0,  2,
//      -1,  0,  1
//   };

//   char sobel_Gy [3][3] = {
//       1,  2,  1,
//       0,  0,  0,
//      -1, -2, -1
//   };

// P0 P1 P2
// P3 P4 P5
// P6 P7 P8

   uint8_t window_pixels [9];
   int32_t sum_Gx, sum_Gy;
   uint32_t mag;
   uint32_t threshold = 100; //100;

   //Assume input is grayscale image
   //Process based on LSB only
   for (unsigned int y=0; y<height; y++) {
      for (unsigned int x=0; x<width; x++) {
         //3x3 Kernel
         for (int n=-1; n<2; n++) {       //-((kernel_height-1)/2) to ((kernel_height-1)/2)
            for (int m=-1; m<2; m++) {    //-((kernel_width-1)/2) to ((kernel_width-1)/2)
               //Border windows - Zero padding
               if (m+x < 0 || n+y < 0 || m+x >= width || n+y >= height) {
                  window_pixels [(m+1) + ((n+1)*3)] = 0;
               } else {
                  window_pixels [(m+1) + (n+1)*3] = in_array [(x+m) + ((y+n)*width)] & 0xff;
               }
            }
         }

         sum_Gx = - window_pixels [0] - (window_pixels [3] * 2) - window_pixels [6] + window_pixels [2] + (window_pixels [5] * 2) + window_pixels [8];
         sum_Gy =   window_pixels [0] + (window_pixels [1] * 2) + window_pixels [2] - window_pixels [6] - (window_pixels [7] * 2) - window_pixels [8];

         //Magnitude approximation
         mag = ABS (sum_Gx) + ABS (sum_Gy);

         //Global Thresholding - Binarization
         if (mag > threshold) {
            out_array [x + (y*width)] = 0x00ffffff;
         } else {
            out_array [x + (y*width)] = 0x00000000;
         }
      }
   }

   return;
}

void binary_erosion (volatile uint32_t in_array [], volatile uint32_t out_array [], uint32_t width, uint32_t height) {

   uint8_t window_pixels [9];
   uint8_t erode_pixel;

   //Assume input is grayscale binary image (pixel value 0 or 255)
   //Process based on LSB only
   for (unsigned int y=0; y<height; y++) {
      for (unsigned int x=0; x<width; x++) {
         //3x3 Kernel
         for (int n=-1; n<2; n++) {       //-((kernel_height-1)/2) to ((kernel_height-1)/2)
            for (int m=-1; m<2; m++) {    //-((kernel_width-1)/2) to ((kernel_width-1)/2)
               //Border windows - Zero padding
               if (m+x < 0 || n+y < 0 || m+x >= width || n+y >= height) {
                  window_pixels [(m+1) + ((n+1)*3)] = 0;
                  //window_pixels [m+1][n+1] = 0;
               } else {
                  window_pixels [(m+1) + (n+1)*3] = in_array [(x+m) + ((y+n)*width)] & 0xff;
                  //window_pixels [m+1][n+1] = (in_array [x+m][y+n]) & 0xff;
               }
            }
         }

         //Output pixel is 255 if all window pixels are 255; otherwise output pixel is assigned to 0
         erode_pixel = window_pixels[0] & window_pixels[1] & window_pixels[2] & window_pixels[3] & window_pixels[4] & window_pixels[5] & \
                       window_pixels[6] & window_pixels[7] & window_pixels[8];

//         erode_pixel = 0xff;
//         for (int i=0; i<9; i++) {
//            erode_pixel = erode_pixel & window_pixels[i];
//         }

         if (erode_pixel == 0) {
            out_array [x + (y*width)] = 0x00000000;
         } else {
            out_array [x + (y*width)] = 0x00ffffff;
         }
      }
   }

   return;
}

void binary_dilation (volatile uint32_t in_array [], volatile uint32_t out_array [], uint32_t width, uint32_t height) {

   uint8_t window_pixels [9];
   uint8_t dilate_pixel;

   //Assume input is grayscale binary image (pixel value 0 or 255)
   //Process based on LSB only
   for (unsigned int y=0; y<height; y++) {
      for (unsigned int x=0; x<width; x++) {
         //3x3 Kernel
         for (int n=-1; n<2; n++) {       //-((kernel_height-1)/2) to ((kernel_height-1)/2)
            for (int m=-1; m<2; m++) {    //-((kernel_width-1)/2) to ((kernel_width-1)/2)
               //Border windows - Zero padding
               if (m+x < 0 || n+y < 0 || m+x >= width || n+y >= height) {
                  window_pixels [(m+1) + ((n+1)*3)] = 0;
                  //window_pixels [m+1][n+1] = 0;
               } else {
                  window_pixels [(m+1) + (n+1)*3] = in_array [(x+m) + ((y+n)*width)] & 0xff;
                  //window_pixels [m+1][n+1] = (in_array [x+m][y+n]) & 0xff;
               }
            }
         }

         //Output pixel is 255 if one of window pixels are 255; otherwise output pixel is assigned to 0
         dilate_pixel = window_pixels[0] | window_pixels[1] | window_pixels[2] | window_pixels[3] | window_pixels[4] | window_pixels[5] | \
                        window_pixels[6] | window_pixels[7] | window_pixels[8];

//         dilate_pixel = 0;
//         for (int i=0; i<9; i++) {
//            dilate_pixel = dilate_pixel | window_pixels[i];
//         }

         if (dilate_pixel == 0) {
            out_array [x + (y*width)] = 0x00000000;
         } else {
            out_array [x + (y*width)] = 0x00ffffff;
         }
      }
   }

   return;
}