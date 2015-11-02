# CodeTest

## Things To note that haven't been completed.

Images are being cached on disk up to 50Mb. At this point and due to time limitations, images have not expiration date. If they did then the chache should be cleared every 7 days just to make sure we don't over consume disk memory.

Labels on storyboard are adjusting according to the width of the screen but, they don't adjust in height. Given the time I would make the track title, artist name, and album name to be expandable to 2 lines with autolayout.

HTTPURLResponses and status codes are not being handled so in case of a 400 500 or any other error code, the objects will just not return with no indication to the user.

It would also be good to have a conectivity manager to tell us when we have an internet connection available or not.

Unit testing in this app is limited. I could test for the URLSession making the requests but it would require a mocking framework to go with. The tests are indicative of my ability to do unit testing to a satisfing level.

The application is not available for iOS 8. The use of stack views prevents the app from being executed on an iOS 8 environment. While I still have the knowledge on how to make it look the same without them, It helped reduce the development time by a lot. 
