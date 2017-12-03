# DeadRinger

DeadRinger is a proof of concept to show how it's possible to re-create the iPhone X lock screen and steal a user's password by making them think they're entering it into their phone. It's not a cheap or particularly easy exploit because you'd have to sacrifice your own phone and physically swap phones with the target but hey, some people have the resources.

![Dead Ringer in action](https://github.com/hungtruong/DeadRinger/blob/master/demo.gif?raw=true)

### Video Demo

[![DeadRinger Demo Video](https://github.com/hungtruong/DeadRinger/blob/master/videodemo.gif?raw=true)](https://youtu.be/0fR6mmrMFyQ "DeadRinger Demo Video")


### Background

With the introduction of the iPhone X, a few new features have made it feasible to faithfully re-create the lock screen.

* The Super Retina display uses OLED, which turn off completely when the pixels are black. This allows us to simulate a phone that's locked and asleep when it's really just showing a black screen.
* The iPhone X removes the home button, which is a physical method of authentication and generally not interceptable in software. Instead, we get the home indicator which we can hide and override, which lets us recreate the lock screen by preventing someone from swiping up to get out of our app.

With this knowledge, we can make an app that looks just like the lock screen (almost) and trick a user into entering their passcode. We can then transmit this passcode to ourselves and theoretically unlock the real iPhone and do whatever we want with it.

### Prerequisites

You'll need to have a spare iPhone X that you're willing to sacrifice. The only thing you'll have to adjust is probably the wallpaper image in case your target has a custom one. Go into the storyboard file and find the `UIImageView` with the wallpaper as the background. Swap it out with whatever background you need.

I should also mention that this app assume the user's locale is US-EN. I tried using localized methods but the lock screen's date format doesn't follow one of Apple's default localized ones using the
`localizedString(from date: Date, dateStyle dstyle: DateFormatter.Style, timeStyle tstyle: DateFormatter.Style)`

method.


### How it works

The app has three states, inactive, lock screen, and passcode entry. It goes between those three states and makes the user assume that they failed Face ID too many times and need to enter a passcode (like Hair Force One did at the iPhone X unveiling).

Obviously there's more steps to get to that state like actually failing Face ID a few times, but for the sake of simplicity I've omitted those steps.

Once the user enters their passcode they get an alert that they've been duped. I'm not really gonna steal someone's passcode.

### Future To Dos

I've taken a first pass at faithfully reproducing the lock screen but there are quite a few things that don't work yet. I can either fix them or maybe someone can fix it and make a pull request.

* The camera and flashlight buttons don't do anything. I guess I could implement the flashlight but  I don't want the target to use the camera for some reason.
* Also, the camera and flashlight buttons have a cool haptic 3D touch thing that I haven't implemented. Seems fun.
* iOS 11.2 introduces an indicator on the upper right corner to show where to pull for control center that I haven't implemented yet
* There are some subtle animations like the lock screen elements moving upward when swiping to unlock. There's also the Face ID rotating ring animations and the process of failing Face ID that I haven't implemented yet.
* The emergency button doesn't work. What do you think it should do? Maybe show a message that says "Don't type your passcode in, it's a trick!"
* Some of the timing on the tilt to wake and sleep are probably a bit off, along with the transition animation speeds.

### Possible Mitigation Techniques

Part of the reason I could recreate the home screen is that Apple seemed to really relax a lot of rules about disabling getting to the home screen. You can still actually get to the home screen if you swipe up a few times really fast. Some ways that Apple can mitigate this would be:

* Show a personal security image on the passcode entry screen. That's probably too tacky for Apple but my bank shows me a goofy photo whenever I try to log in. Defeatable if you know the target's personal security image.
* Add a hardware led or something that lights up a status when entering sensitive info that's not accessible by software. Apple already has a light that turns on when your MacBook camra turns on so it's not unheard of. This would also solve other phishing techniques by websites that show dialogs that look like Apple account authentication dialogs.

### Disclaimer

Please don't use this to steal anyone's passcode because that would not be cool.

### License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details


