# DT Kernels
Modern kernels only require a patched device tree blob (.dtb) to configure multiple 1-wire busses.  
* https://www.raspberrypi.org/forums/viewtopic.php?f=44&t=107894 (thanks Maag!)


# Pre-DT kernels (OBSOLETE)
The provided kernel is 3.12.26+ from Raspbian with the 4x 1-wire patch applied. Copying kernel-d33z.img and config.txt to /boot/ on your rpi sdcard should be all that is necessary to install it. 

To roll your own kernel, use the .txt patch in this folder and this link:
http://elinux.org/Raspberry_Pi_Kernel_Compilation

