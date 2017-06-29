#!/bin/bash

# Arguments
MASK=$1
IMAGE=$2
RESULT=$3
WALLPAPER_WIDTH=$4
WALLPAPER_HEIGHT=$5
WALLPAPER_COLOR=$6

# Variables for calculation
MASK_WIDTH="$(convert $MASK -ping -format "%w" info:)"
MASK_HEIGHT="$(convert $MASK -ping -format "%h" info:)"
IMAGE_HEIGHT="$(convert $IMAGE -ping -format "%h" info:)"

# Variables for temporary names
TEMP_IMAGE="temp_image.png"
TEMP_BOLT="temp_bolt.png"
TEMP_WALLPAPER="temp_wallpaper.png"

# Check for image size issues
if [ $IMAGE_HEIGHT -lt $MASK_HEIGHT ]
then
	echo "Warning: Image is too small, proceeding anyway, but result may be blurry"
fi

# Build the wallpaper if needed
if [ -n "$WALLPAPER_WIDTH" ] && [ -n "$WALLPAPER_HEIGHT" ]
then
	echo "Info: Creating wallpaper background"

	# Get the average color of the background image if a wallpaper color is not passed
	if [ -z "$WALLPAPER_COLOR" ]
	then
		echo "Info: Obtaining average image color"
		WALLPAPER_COLOR="$(convert $IMAGE -resize 1x1 -ping -format '%[pixel:p{0,0}]' info:-)"
	fi

	convert -size ${WALLPAPER_WIDTH}x${WALLPAPER_HEIGHT} xc:${WALLPAPER_COLOR} $TEMP_WALLPAPER
fi

echo "Info: Scaling image"
convert $IMAGE -geometry x${MASK_HEIGHT} $TEMP_IMAGE # Scale the image to better match the mask height
echo "Info: Applying mask to image"
composite -compose Dst_In -gravity center $MASK $TEMP_IMAGE -alpha Set $TEMP_BOLT # Apply the mask
echo "Info: Cropping resulting image to mask size"
convert $TEMP_BOLT -gravity center -crop ${MASK_WIDTH}x${MASK_HEIGHT}+0+0 +repage $TEMP_BOLT # Crop the final image to be the size of the mask

# Build the final wallpaper if needed
if [ -n "$WALLPAPER_WIDTH" ] && [ -n "$WALLPAPER_HEIGHT" ]
then
	echo "Info: Creating wallpaper"
	composite -gravity center $TEMP_BOLT $TEMP_WALLPAPER $RESULT # Overlay the created bolt on the wallpaper
	rm $TEMP_BOLT
	rm $TEMP_WALLPAPER
else
	mv $TEMP_BOLT $RESULT
fi

echo "Info: Removing temporary files"
rm $TEMP_IMAGE # Remove the scaled background image