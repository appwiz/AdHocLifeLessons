### Introduction
AdHocLifeLessons is a Swift app that runs on iOS and macOS. It works in any orientation on iPhone, iPad, macOS, or tvOS.

### How it works
- When the app is launched, it displays a "life lesson" centered in the main view. The lesson is retrieved from https://rohand.app/lifelesson/quote.json using a GET request. 
The JSON document has the following structure:
```json
{
  "ts": "20250731",
  "v": 1,
  "s": "Life is Happy"
}
```
- The `ts` field is a timestamp indicating when the lesson was last updated.
- The `v` field is the version of the lesson.
- The `s` field is the actual lesson text. Display this text in the app.

### Requirements
- If the API endpoint is unreachable, the app should display 
    - either the last successfully retrieved lesson, or
    - a default lesson if no lesson has been retrieved before
- The default lesson is "Love Each Other".
- Display the lesson in a large font, centered in the view. This text should be scrollable if it exceeds the screen height. Make this text visually appealing, using a suitable font and color. 

### Storage
- All information is stored locally in the app's storage. Nothing is synced across CloudKit or any other service.
- The app should store the last successfully retrieved lesson and the timestamp of the last update in local storage.

### Footer
The app view also contains a footer.
- Display a tiny footer at the bottom of the view that shows the last update time of the lesson in a human-readable format (e.g., "Last updated: 2 minutes ago"). The footer is always visible.
- The app should also have a button that allows the user to refresh the lesson by fetching it again from the API. Add this button to the footer.

### Icon
We need an icon for this app and in various sizes for the different types of iOS/macOS/visionOS/tvOS devices. Create an icon that has double quotes on a solid white background in all required sizes please. No transparency.

