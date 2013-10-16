- added tab bar icons, made the highlighted color appropriate for the social media site
- made look cleaner by keeping the background for the whole app white
- color-coordinated other parts of the searching screen (pink/blue text, pink/blue spinner)




ASYNC:
problem right now is images are being recycled because they're stored in the cells
- need to store all data in an array then go through that

- internetimageview will call method in target every time it completes a download
- flickr or instagram will count the number of downloads with this method and compare it to the number of downloads it should have (from [photos count])
- internetimageview will also store all photos in an array
- when it's done downloading all photos, the tableview will display the images in the array, and the method in flickr/instagram that checks when it's done will call reload data
- this way the table cells will have the right heights because it can look at the image's height since the image is in an array