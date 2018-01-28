# Access Collective App

This is the iOS version of the Access Collective app, created by Coders for Causes UWA, that provides information about disability services around the UWA campuses. The app uses Firebase, a popular cloud platform by Google, to store map data.

## Getting Started

Currently, we do not have access to an Apple Developer Account, so for now we will be building the app without one. Instructions will be placed here regarding setup once the Account has been created.

### Prerequisites

You will need:

- Latest version of [Xcode 9](https://developer.apple.com/xcode/)
  - You will need to sign in with an Apple ID to download Xcode, which will register it as a Developer Account and allow you to sideload iOS apps
- An Intel-based Mac running macOS 10.10 (Yosemite) or later

### Setting Up

1. Install [Git](https://www.atlassian.com/git/tutorials/install-git)
2. Install [CocoaPods](https://guides.cocoapods.org/using/getting-started.html#toc_3), a dependency manager used by Xcode for some libraries (including Firebase)

 `sudo gem install cocoapods`

3. Clone the repository to a location of your choice  

  `cd path/to/desired/location/`  
  `git clone https://github.com/alexarnold94/access-collective-ios.git`

4. Grab the `GoogleService-Info.plist` file from a project contributor (available on the group Slack channel) and add it to the `access-collective` folder of the project

5. Open Xcode through Terminal  

  `open access-collective.xcworkspace`

## Contributing

The contribution guide is located in CONTRIBUTING.md, and covers the development workflow as well as task creation and allocation.

## Built using

- Firebase

## Contributors

- Abrar Amin
- Christian Sivwright
- Jeremiah Pinto
- Diva Lonial
- John Nguyen
- Alex Arnold
