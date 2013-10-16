Vanessa Ronan
CS181H - Mobile Software Development

Updates to Scrapbook App
October 16, 2013

 BACKEND UPDATES
-----------------
1. Photo storage
Before:  Database stores the row id, URL, title, and description for each scrapbook item.  App downloads photo from its URL each time it needs to display.  App is slow to open (because it needs to download all scrapbook item photos) and slow to transition between views.
After: The photos themselves are stored in the app's Documents directory, and a path to each photo is stored in the database instead of the URL.  App opens immediately and transitions at a normal speed.

2. Photo downloading
Before:  Photos download on the main thread and freezes the view.  The user can't do anything (scroll, switch tabs, etc.) while searching for Flickr or Instagram photos.
After:  Photos download asynchronously and UI does not freeze at all.  All photos are downloaded before any are displayed and a loading spinner spins to show that it's downloading them.  Photos are stored in an array and the table view uses each photo's height to make the table cell the right height.

 FRONTEND UPDATES
------------------
1. Photo search tab bar icons
Before:  Tabs say Flickr and Instagram without pictures.
After:  Tabs say Flickr and Instagram with their respective pictures (Note the "Facebook f" is the same as the f in Flickr).

2. Photo search tab bar icon colors
Before:  Highlighted tab is the default iOS7 blue.
After:  Highlighted tab is Flickr pink for Flickr and Instagram blue for Instagram.

3. Photo search color scheme
Before:  Background of each tab is the color of the site it's searching on (pink for Flickr, blue for Instagram).  "GO" button is also this color, with white text.  Text in search box and progress spinner are gray.
After:  Background of each tab is white for a cleaner look, more consistent with the rest of the app.  Text in search box is pink/blue, button background is white with pink/blue text, progress spinner is pink/blue.  "GO" button turns gray when tapped.

4. Cells of scrapbook items in My Scrapbook
Before:  Photos are placed in the default imageView of a table cell and title is placed in the default textLabel of table cell.  Description is not shown in cell.
After:  Cells contain a custom view that shows the photo on the left 40% of the cell and the text and description on the right 60%.  Title text is larger and black, description text is smaller and gray.  There's an arrow on the right side of the cell indicating you can touch it to see a detailed view.

5. Detail view
Before: Large photos take up entire view and user can't see title or description.
After: Large photos are scaled down so title and description can be seen below them.

6. App icon
Before:  No icon.
After:  Icon showing off iOS7.