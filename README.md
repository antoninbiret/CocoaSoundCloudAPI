# Important notice
Unfortunately, we decided to discontinue support for this project; SoundCloud will no longer accept pull requests or make public releases of CocoaSoundCloudAPI. If you're using CocoaSoundCloudAPI in one of your projects, we suggest you fork the project in order to perform any necessary maintenance.

# The SoundCloud API for Cocoa

So you want to share your tracks in your iOS Application to SoundCloud? With this project you only need a few lines of code for doing that. The SoundCloud API supports iOS from Version 4.0 and MacOS X from Leopard (10.6). It uses SoundClouds [OAuth2](http://oauth.net/2) API and henceforth includes the [NXOAuth2Client](http://github.com/nxtbgthng/OAuth2Client) project.

Afraid of doing the journey alone? Don't be, there's a lot of places where you can find help:

* The [SoundCloud API Documentation](http://developers.soundcloud.com/docs). You'll need this.
* The [SoundCloud tag](http://stackoverflow.com/questions/tagged/soundcloud) on Stack Overflow.
* If you're looking for additional documentation on this wrapper have a look at the [wiki](http://wiki.github.com/soundcloud/cocoa-api-wrapper/) where you'll find the documentation for [version 1](http://github.com/soundcloud/cocoa-api-wrapper/tree/v1.0).

Please keep in mind that all of this is under heavy development, and things might change from time to time. Please update your frameworks often, and keep this space in mind.

We document the [changes to the different versions](https://github.com/soundcloud/CocoaSoundCloudAPI/blob/master/Changes.md). If you've used a previous version, please read it.

This guide assumes a few things:

* You are using Xcode 4
* You are using Git.

## Demo

<object width="400" height="225"><param name="allowfullscreen" value="true" /><param name="allowscriptaccess" value="always" /><param name="movie" value="http://vimeo.com/moogaloop.swf?clip_id=28715664&amp;server=vimeo.com&amp;show_title=0&amp;show_byline=0&amp;show_portrait=0&amp;color=00adef&amp;fullscreen=1&amp;autoplay=0&amp;loop=0" /><embed src="http://vimeo.com/moogaloop.swf?clip_id=28715664&amp;server=vimeo.com&amp;show_title=0&amp;show_byline=0&amp;show_portrait=0&amp;color=00adef&amp;fullscreen=1&amp;autoplay=0&amp;loop=0" type="application/x-shockwave-flash" allowfullscreen="true" allowscriptaccess="always" width="400" height="225"></embed></object><p><a href="http://vimeo.com/28715664">Cocoa SoundCloud API</a> from <a href="http://vimeo.com/user6669156">Tobias</a> on <a href="http://vimeo.com">Vimeo</a>.</p>

## Setup

We're taking a fresh new iOS Project as an example. Integration into an existing project and/or a Desktop project should be similar.

## CocoaPods
[CocoaPods](http://cocoapods.org/) is a dependency manager for Xcode projects. 
If you are already using `CocoaPods` you can include all necessary libraries by adding following lines to your `Podfile`:
```
pod 'CocoaSoundCloudAPI', '1.0.1'
pod 'CocoaSoundCloudUI', '1.0.5'
```
and run `pod install`.

Please note, that these `Pods` already include following `dependencies`:
* `OHAttributedLabel`
* `JSONKit`
* `NXOAuth2Client`

:hand: ^5 Everything is set up, and you can skip to the **Usage** section!

### In the Terminal

1. Go to your project directory.

2. Add the required GIT Submodules

        // For the API
        git submodule add git://github.com/nxtbgthng/OAuth2Client.git
        git submodule add git://github.com/soundcloud/CocoaSoundCloudAPI.git

        // For the UI (iOS only)
        git submodule add git://github.com/nxtbgthng/JSONKit.git
        git submodule add git://github.com/nxtbgthng/OHAttributedLabel.git
        git submodule add git://github.com/soundcloud/CocoaSoundCloudUI.git


### In Xcode

1. Create a Workspace containing all those submodules added above.

2. To be able to find the Headers, you still need to add `../**`, `./**` or `$PROJECT_DIR/**`, depending on your setup to the `Header Search Path` of the main project.

3. Now the Target needs to know about the new libraries it should build and link against. Note the following dependencies:

	**iOS only**

		libSoundCloudAPI.a
	    libOAuth2Client.a
    	libJSONKit.a
	    libOHAttributedLabel.a
    	libSoundCloudUI.a
    
	**OS X only**
	
    	SoundCloudAPI.framework
	    OAuth2Client.framework

	**iOS & OS X**

    	QuartzCore.framework
	    AddressBook.framework
	    AddressBookUI.framework
	    CoreLocation.framework
	    Security.framework
	    CoreGraphics.framework
	    CoreText.framework

	The relevant libraries should be added as dependencies of your target and also linked. In the _Project_, select the _Target_, and in _Build Phases_ add the libraries and frameworks to both the _Target Dependencies_ and _Link Binary with Libraries_ sections.

4. Next step is to make sure that the Linker finds everything it needs: So go to the Build settings of the project and add the following to *Other Linker Flags*, if not already present:

        -ObjC

*Note that previously, due to a linker bug, the flag `-all_load` was also necessary in order to prevent Objective-C categories from being stripped by the linker. If using the latest SDK this is no longer required. However, if you are seeing **Unrecognized Selector** exceptions then you are not using the latest developer tools and should consider upgrading, or adding the `-all_load` flag.*

5. On iOS we need a few graphics: Please move the `SoundCloud.bundle` from the `CocoaSoundCloudUI/` directory to your Resources.

Yay, done! Congrats! Everything is set up, and you can start using it.

## Usage

### The Basics

You only need to `#import "SCUI.h"` to include the UI headers (or `#import <SoundCloudAPI/SCAPI.h>` on Desktop).

### Configure your App

To configure you App you have to set your App's _Client ID_, it's _Client Secret_ and it's _Redirect URL_. The best way to do this is in the `initialize` class method in your app delegate.

    + (void)initialize;
    {
        [SCSoundCloud  setClientID:@"<Client ID>"
                            secret:@"<Client Secret>"
                       redirectURL:[NSURL URLWithString:@"<Redirect URL>"]];
    }

You will get your App's _Client ID_, it's _Client Secret_ from [the SoundCloud page where you registered your App](http://soundcloud.com/you/apps). There you should register your App with it's name and a _Redirect URL_. That _Redirect URL_ should comply to a protocol that is handled by your app. See [this page](http://iosdevelopertips.com/cocoa/launching-your-own-application-via-a-custom-url-scheme.html) on how to set up the protocol in your App. For the curious: in the wrapper we're using _Redirect URL_ instead of _Redirect URI_ because the underlying type is of `NSURL`.


### Using the Share UI (iOS only)

To share a track you just have to create a `SCShareViewController` with the URL to the file you want to share and present it on the current view controller. After a successful upload, the track info can be accessed in the completion handler.

    - (void)upload;
    {
        NSURL *trackURL = // ... an URL to the audio file

		SCShareViewController *shareViewController;
        shareViewController = [SCShareViewController shareViewControllerWithFileURL:trackURL
                                                                  completionHandler:^(NSDictionary *trackInfo, NSError *error){

                                            if (SC_CANCELED(error)) {
                                            	NSLog(@"Canceled!");
                                            } else if (error) {
                                            	NSLog(@"Ooops, something went wrong: %@", [error localizedDescription]);
                                            } else {
                                            	// If you want to do something with the uploaded
                                            	// track this is the right place for that.
                                            	NSLog(@"Uploaded track: %@", trackInfo);
                                            }
        }];

        // If your app is a registered foursquare app, you can set the client id and secret.
        // The user will then see a place picker where a location can be selected.
        // If you don't set them, the user sees a plain plain text filed for the place.
        [shareViewController setFoursquareClientID:@"<foursquare client id>"
                                      clientSecret:@"<foursquare client secret>"];

        // We can preset the title ...
        [shareViewController setTitle:@"Funny sounds"];

        // ... and other options like the private flag.
        [shareViewController setPrivate:NO];

        // Now present the share view controller.
        [self presentModalViewController:shareViewController animated:YES];
    }

Optionally you can preset set the *title*, a *cover image*, a *creation date* and a flag indicating if the track should be public or private. Look at `SCShareViewController.h` for details.

### Using the API

If you want to provide your own UI for sharing a track or you want to use the SoundCloud API for other purposes, have a look at the [General Usage](https://github.com/soundcloud/CocoaSoundCloudAPI/blob/master/GeneralUsage.md) or at [Sharing](https://github.com/soundcloud/CocoaSoundCloudAPI/blob/master/Sharing.md).

## Thats it!

