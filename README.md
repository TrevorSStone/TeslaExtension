#Tesla Model S Control
[Link to Extension](https://chrome.google.com/webstore/detail/tesla-model-s-control/beoeghbnbaphdhjgeclajnniaghnfofk)

**I need your help. Unfortunately, I was told by a Tesla employee that I was not allowed to use their images in my application. I replaced all images with ugly placeholder art. If you, or someone you know would be able to help bring some beauty back to the extension please contact me and check out the [reddit thread](http://www.reddit.com/r/teslamotors/comments/1yu9g9/i_created_a_tesla_model_s_chrome_extension_and/) and the Tesla motor club thread**

![Old Version](/screenshots/old/Tesla Model S Home.png?raw=true)
vs 
![New Version](/screenshots/new/Tesla Model S Home.png?raw=true)


This application is for owners of the Tesla Model S.

It provides owners almost all of the features of the official mobile app (plus a few that the app doesn't even provide), but with the convenience of being able to be used from the desktop!

Just log in with your Tesla account username and password (and have mobile enabled on the car) and you're ready to go. All data is only sent to and from Tesla's servers. No user information is stored locally or sent to any third party.

##Building the extension
This extension is built using dart and angulardart. Right now it runs at a fixed 400x600 resolution. 

First install dart from https://www.dartlang.org/

Once installed and configured, go to the project folder and run:
```
pub get
```

Then open the project in the Dart Editor (if you want to use a different editor such as sublime and are having issues let me know and I will help you. It is actually how I wrote it).

There are currently some small technical issues with writing a chrome extension in dart. The biggest is that unpacked extensions cannot use symlinked files, but dart uses them extensively in the file structure (at least at the time of writing and on Linux). To get around this when developing, it is easier to just develop as it like a normal website. The problem here is that Dartium will block connections to Tesla's servers because of security. To get around this open your launch configuration in Dart Editor and add:

```
--disable-web-security
```

to the Browser arguments box for main.html and login.html.

At this point you should be able to run login.html and have dartium load without issue

This product is not endorsed, certified or otherwise approved in any way by Tesla Motors or any of its affiliates.
