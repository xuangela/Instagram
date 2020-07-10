# Project 4 - *Instagram*

**Instagram** is a photo sharing app using Parse as its backend.

Time spent: **25** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can sign up to create a new account using Parse authentication
- [x] User can log in and log out of his or her account
- [x] The current signed in user is persisted across app restarts
- [x] User can take a photo, add a caption, and post it to "Instagram"
- [x] User can view the last 20 posts submitted to "Instagram"
- [x] User can pull to refresh the last 20 posts submitted to "Instagram"
- [x] User can tap a post to view post details, including timestamp and caption.

The following **optional** features are implemented:

- [x] Run your app on your phone and use the camera to take the photo
- [ ] Style the login page to look like the real Instagram login page.
- [ ] Style the feed to look like the real Instagram feed.
- [x] User can use a tab bar to switch between all "Instagram" posts and posts published only by the user. AKA, tabs for Home Feed and Profile
- [x] User can load more posts once he or she reaches the bottom of the feed using infinite scrolling.
- [ ] Show the username and creation time for each post
- [ ] After the user submits a new post, show a progress HUD while the post is being uploaded to Parse
- User Profiles:
  - [ ] Allow the logged in user to add a profile photo
  - [ ] Display the profile photo with each post
  - [ ] Tapping on a post's username or profile photo goes to that user's profile page
- [ ] User can comment on a post and see all comments for each post in the post details screen.
- [ ] User can like a post and see number of likes for each post in the post details screen.
- [ ] Implement a custom camera view.

The following **additional** features are implemented:

- [x] image fit to screen 
- [x] dismissing keyboard when tap a non-text entry box

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Using an external library to make the app look pretty 
2. How to post videos 

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='https://github.com/xuangela/Instagram/blob/master/Gifs/compose%20post%20.gif' title='Compose' width='' alt='Video Walkthrough' />
<img src='https://github.com/xuangela/Instagram/blob/master/Gifs/infinite%20scrolling.gif' title='infinite scrolling' width='' alt='Video Walkthrough' />
<img src='https://github.com/xuangela/Instagram/blob/master/Gifs/login:logout.gif' title='Login/Logout' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [Parse](https://github.com/parse-community/Parse-SDK-iOS-OSX) - online database 
- [DateTools](https://github.com/MatthewYork/DateTools) - date and time handling library


## Notes

Getting the post images to autoformat to the phone was difficult since the table cells were being created before the images were being loaded, which meant that hte table cell didn't believe that it contained a picture. Rather than hardcoding the cell height, implemented dynamic heights by storing the aspect ratio of the post picture as well. 

## License

    Copyright [2020] [Angela Xu]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
