## Usage
```
./cookie-cutter.sh mask.png image.jpg result.png [resultWidth (optional)] [resultHeight (optional)] [resultBackgroundColor (optional)]
```

> The script will find the image's average color and apply that to the background if no background color is supplied. If no width, height, or color is passed, the result with have a transparent background and the same dimensions as the mask.

## Example
```
./cookie-cutter.sh example/star.png example/background.jpg example/icon.png
```
![Icon](example/icon.png)

```
./cookie-cutter.sh example/star.png example/background.jpg example/avatar.png 700 700
```
![Avatar](example/avatar.png)
