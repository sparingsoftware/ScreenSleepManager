# ScreenSleepManager

Small library for managing screen sleep in your app.

Let's say you don't want screen to "go sleep" in particular **ViewController**. You will need to use `isIdleTimerDisabled` and set it to `true`. When user leaves this screen you will have to set it back to `false` - otherwise your app will never let your screen to turn off. 

In simple cases that's OK. Easy to set, easy to remember.

---
### Not simple case
If you have multiple **ViewsControllers** in your app and on some of them you want to disable "screen lock" but on others don't.
You can somehow manage it with `isIdleTimerDisabled` but it would be really easy to make a mistake (`true` instead of `false` etc.) or just forget about enabling/disabling.

I found a really simple and nice library called [Insomnia](https://github.com/ochococo/Insomnia) for such scenario.
However in our (pretty big) music app we encountered some advanced cases and we wanted more suitable solution for this. Also - as we are usually doing **TDD** - we needed something easy and modularized for testing.

---
### Advanced case
As I already mention we are responsible for maintaining one of the biggest music app in Poland. It allows you to record video, add audio filters, browse through thousands of videos, listen to songs etc. 
We had some special requirements like:

 - don't let screen lock on specified **Views**
 - don't let screen lock when user is recording or listening to songs
 - and at last but not least - don't let screen lock when user's recording is being proceeded in background (user can be on any **View**)
 - in every other scenario we have to let the system do what it want with screen

We have to handle case in which many independent modules will try to enable and disable **idleTimer**.

---
### Solution
**ScreenSleepManager** implements **IScreenSleepManager** (sorry for my Java habits - I like to know which objects are **interface/protocol** at a glance)
```swift
protocol IScreenSleepManager {
  func requestToDisableSleep(withKey key: String)
  func removeRequest(forKey key: String)
}
```

You can send as many requests as you need and screen will be "ready to turn off" only when **there are no more requests on stack**. It's kind of a counter but with keys so you can control it better.


---
### Use Cases

Don't let screen go sleep on this **ViewController**:
```swift
func viewDidAppear() {
  manager.requestToDisableSleep(withKey: "PlayerView")
}

func viewDidDisappear() {
  manager.removeRequest(forKey: "PlayerView")
}
```
or  - don't let it sleep when something is being proceeded:
```swift
class AudioProcessor {
  func startProcessing() {
    // ... 
    manager.requestToDisableSleep(withKey: "AudioProcessor")
  }

  // callback
  func processingFinished() {
    manager.removeRequest(forKey: "AudioProcessor")
  }
}
```

---
### Tests
You can test it as an inter-module and see if `isDisabled` has proper value:
```swift
audioProcessor.startProcessign()
router.navigate(to: .Login)
presenter.clickSmth()

assXCTAssertrt(ScreenSleepManager.instance.isDisabled == false)
```

You can also inject ScreenSleepManager object to your **View/Presenter/ViewModel** and test your calls:
```swift
let mockScreenManager = MockScreenSleepManager()
let presenter = Presenter(..., mockScreenSleepManager)
presenter.startRecordingClicked()
verify(mockScreenManager).requestToDisableSleep(withKey: "XYZ")
// ...
presenter.stopRecordingClicked()
verify(mockScreenManager).removeRequest(forKey: "XYZ")
``` 
## License
MIT License © [Sparing Interactive](https://github.com/SparingSoftware)
