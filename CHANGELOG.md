# Changelog

All notable changes to this project are documented in this file.

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

### Deprecated


- Starting with v12.2.0 apps no longer need to embed numerous custom URL schemes in `LSApplicationQueriesSchemes` for their `Info.plist`.  Only the `fbapi` and `fb-messenger-share-api` custom URL schemes are needed.  With the change to iOS 15 that limits `LSApplicationQueriesSchemes` to 50 schemes, this should relieve some pressure that apps may face when running up against this limit. As part of this change the following symbols are deprecated:
  - `URLScheme.facebookApp`
  - `URLScheme.facebookShareExtension`
  - `URLScheme.masqueradePlayer`

[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v12.2.0...HEAD)

## 12.2.0

### Fixed

- Fixed NSKeyedUnarchiver validateAllowedClass Warnings in Xcode Console. Fixes #1941 and #1930
- An implementation bug in `ApplicationDelegate` where added application observers were notified twice for `application:didFinishLaunchingWithOptions:`.
The return type of `ApplicationDelegate.application:didFinishLaunchingWithOptions:` was also incorrectly stated as, "YES if the url was intended for the Facebook SDK, NO if not". In actuality, the method returns whether there are any application observers that themselves return true from calling their implementation of `application:didFinishLaunchingWithOptions:`.
This fix means that application observers will now only be notified once per app launch, however, if `ApplicationDelegate.application:didFinishLaunchingWithOptions:` is called after calling `ApplicationDelegate.initializeSDK` then the return type will always be false regardless of any application observers.
- Using share dialogs via share sheet mode fails to show the dialog (Issue #1938)
- Fixed: aem_conversion_configs should contain an explicit "fields" parameter (Issue #1933)

### Deprecated
- The class-based interface of `AppEvents` has been deprecated. Please use the instance properties and methods on `AppEvents.shared` instead.

[2021-12-01](https://github.com/facebook/facebook-ios-sdk/releases/tag/v12.2.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v12.1.0...v12.2.0)

## 12.1.0

### Changed
- When using SPM, FacebookAEM and FacebookBasics no longer have to be explicitly included

### Fixed
- FBSDKShareDialog show does nothing the first time (Issue #1919)
- Unable to archive app for distribution using Xcode 12.5.1 and Swift Package Manager (Issue #1917)
- iOS 15: NSKeyedUnarchiver warning (Issued #1887)

### Deprecated
- The aggregate FacebookSDK pod is deprecated. Please use one of the individual pods instead (i.e. FBSDKCoreKit,
  FBSDKShareKit, FBSDKLoginKit, etc.)

[2021-10-26](https://github.com/facebook/facebook-ios-sdk/releases/tag/v12.1.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v12.0.2...v12.1.0)

## 12.0.2

- Updated release to be built with Xcode 12 for backwards compatibility with Xcode 12

[2021-10-16](https://github.com/facebook/facebook-ios-sdk/releases/tag/v12.0.2) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v12.0.1...v12.0.2)

## 12.0.1

**Note**: Binaries for v12.0.1 were built with Xcode 13 and will not work with Xcode 12. See #1911. Use release v12.0.2 instead.

- Fixed: Share Dialog not presenting for SDK 12.0.0 including for the FacebookShareSample app #1909

[2021-10-15](https://github.com/facebook/facebook-ios-sdk/releases/tag/v12.0.1) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v12.0.0...v12.0.1)


## 12.0.0

Starting with version 12.0.0, CocoaPods and Swift Package Manager (SPM) are vending pre-built XCFrameworks. You no longer need to build the SDK when using CocoaPods or SPM, which should save you between a few seconds and a few minutes per build.

Because XCFrameworks do not allow embedded frameworks, note the following:
- When you install the SDK by using CocoaPods, the generated Pods project includes the dependencies for you.
- When you install the SDK by using SPM, you must add the dependencies yourself.
  - You must include `FacebookAEM` and `FacebookBasics` even though you won't use them directly.

You can no longer build from source using Carthage. Instead use Carthage to obtain the pre-built XCFrameworks. For instructions, see: https://github.com/Carthage/Carthage#migrating-a-project-from-framework-bundles-to-xcframeworks.

For more details, see https://developers.facebook.com/docs/ios/getting-started.


🚨 IMPORTANT 🚨

Changes to `FBSDKLoginButton` when defined in a Storyboard or XIB file: There is a known issue with using XCFrameworks in conjunction with Storyboard or XIB files. If you do not follow the instructions for using Interface Builder at https://developers.facebook.com/docs/facebook-login/ios/advanced/, `FBSDKLoginButton` does not load or decorate correctly.  Add `[FBSDKLoginButton class]` to `application:didFinishLaunchingWithOptions:` so that the Storyboard can find it. If you don't, any methods that you call on it may result in a **runtime crash**.


### Changes in Version 12.0.0

- The minimum supported version of iOS is now 10.0.
- Formalized the shared instance of `AppEvents` (given the property name `shared`) to start moving away from a class-based interface.
- `FacebookGamingServices` and `FBSDKGamingServicesKit` &mdash; There are two libraries related to Gaming Services. `FBSDKGamingServicesKit` is a superset of `FacebookGamingServices` that includes Objective-C wrapper classes for `FBSDKContextDialogPresenter` and `FBSDKContextDialogPresenter`. If you don't need an Objective-C interface for these types,
we recommend that you use only `FacebookGamingServices`.
- Nullability annotations are added to some types. If you are using Swift (and in some cases Objective-C) and you use a newly annotated type, see the warnings in Xcode for more information.

The following table contains changes to the iOS SDK in version 12.0.0.

|Removed or Changed|Version 12.0.0 Replacement or Change|
|-|-|
|`AccessToken` convenience initializers that include `graphDomain`|&mdash;|
|`AccessToken.graphDomain` class property.|`AccessToken.graphDomain` instance property.|
|`AccessToken.refreshCurrentAccessToken(completionHandler:)`|`AccessToken.refreshCurrentAccessToken(completion:)`|
|`AppEvents.activateApp` class method.|`AppEvents.activateApp` instance method that you access on the `AppEvents.shared` instance.|
|`FBSDKGraphErrorRecoveryProcessor` - you can no longer create new instances without using designated initializers.|&mdash;|
|`GamingContext.type`|&mdash;|
|`GamingImageUploader.uploadImage(configuration:andResultCompletionHandler:)`|`GamingImageUploader.uploadImage(configuration:andResultCompletion:)`|
|`GamingImageUploader.uploadImage(configuration:completionHandler:andProgressHandler:)`|`GamingImageUploader.uploadImage(configuration:completion:andProgressHandler:)`|
|`GamingPayload.gameRequestID`|You can obtain the game request ID from `GamingPayloadDelegate.parsedGameRequestURLContaining(_:gameRequestID:)`|
|`GamingPayloadDelegate.updatedURLContaining(_:)`|`GamingPayloadDelegate.parsedGameRequestURLContaining(_:gameRequestID:)`|
|`GamingPayloadObserver.shared`|You must now create instances of this object by using a delegate.|
|`GamingServiceResultCompletionHandler`|`GamingServiceResultCompletion`|
|`GamingVideoUploader.uploadVideo(configuration:andResultCompletionHandler:)`|`GamingVideoUploader.uploadVideo(configuration:andResultCompletion:)`|
|`GamingVideoUploader.uploadVideo(configuration:completionHandler:andProgressHandler:)`|`GamingVideoUploader.uploadVideo(configuration:completion:andProgressHandler:)`|
|`GraphRequest.start(completionHandler:)`|`GraphRequest.start(completion:)`|
|`GraphRequestBlock`|`GraphRequestCompletion`|
|`GraphRequestConnection.add(_:completionHandler:)`|`GraphRequestConnection.add(_:completion:)`|
|`GraphRequestConnection.add(_:batchEntryName:completionHandler:)`|`GraphRequestConnection.add(_:name:completion:)`|
|`GraphRequestConnection.add(_:batchParameters:completionHandler:)`|`GraphRequestConnection.add(_:parameters:completion:)`|


[2021-09-27](https://github.com/facebook/facebook-ios-sdk/releases/tag/v12.0.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v11.2.1...v12.0.0)


## 11.2.1

### Fixed
- Fixed the App AEM Advertiser Rule match for fb_content
- Fixed: 'FBSDKCoreKitImport.h' file not found. (Issue #1829)

[2021-09-16](https://github.com/facebook/facebook-ios-sdk/releases/tag/v11.2.1) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v11.2.0...v11.2.1)

## 11.2.0

### Added

- Added AEM Deeplink handling debugging support

### Fixed

- Support for building with Xcode 13 beta 4 due to change in optionality for NS_EXTENSION_UNAVAILABLE. More information in the [Xcode release notes](https://developer.apple.com/documentation/xcode-release-notes/xcode-13-beta-release-notes) and in issue [#1799](https://github.com/facebook/facebook-ios-sdk/issues/1799). Resolved by [@S2Ler](https://github.com/S2Ler) in [#1768](https://github.com/facebook/facebook-ios-sdk/pull/1811)

[2021-08-30](https://github.com/facebook/facebook-ios-sdk/releases/tag/v11.2.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v11.1.0...v11.2.0)

## 11.1.0

### Added

- Reintroduces `initializeSDK` method to `FBSDKApplicationDelegate`

### Changed

- Introduced [Xcodegen](https://github.com/yonaskolb/XcodeGen) for generating project files. Moving forward, We will now use Xcodegen to generate the project files that are used to build the SDK releases. There should be no impact to SDK users. However, some build settings were restored to Xcode defaults as a result of this change, and output binaries may be affected in unpredictable ways. Contributors to the SDK should run the new, top-level script `generate-projects.sh` to ensure that the project files they are using are the same as those being used in CI and for releases. The next major version will remove the project files from version control. If you experience any of these issues, please open an [issue](https://github.com/facebook/facebook-ios-sdk/issues/new/choose) and we will look into it.

### Deprecated

- Building the frameworks using [Carthage](https://github.com/Carthage/Carthage). Carthage is a dependency manager that typically works by building a third party framework using Xcode schemes shared from a `.xcodeproj` file. We are planning to remove the `.xcodeproj` files in the next major release as they will be generated on an as needed basis using [Xcodegen](https://github.com/yonaskolb/XcodeGen). There is a strong likelihood that this change will break several integrations that use Carthage. You will still be able to use Carthage by pulling the pre-built binaries or XCFrameworks directly from the release. If this does not work for your use case, we recommend checking out Swift Package Manager as an alternative.
- FBSDKGamingServicesKit's `GamingServiceResultCompletionHandler`. Replaced by `GamingServiceResultCompletion` which passes a dictionary instead of a string for the result. Additionally the following methods have been updated:
  - `uploadImageWithConfiguration:andResultCompletionHandler` is replaced by `uploadImageWithConfiguration:andResultCompletion`
  - `uploadImageWithConfiguration:completionHandler:andProgressHandler` is replaced by `uploadImageWithConfiguration:completion:andProgressHandler:`
  - `uploadVideoWithConfiguration:completionHandler:andProgressHandler:` is replaced by `uploadVideoWithConfiguration:completion:andProgressHandler:`
  - `uploadVideoWithConfiguration:andResultCompletionHandler` is replaced by `uploadVideoWithConfiguration:andResultCompletion`
- `FBSDKGamingPayloadObserver`'s `shared` instance. Going forward a user should create and retain their own instance of a payload observer for as long as they'd like to receive callbacks from its delegate.

### Fixed

- Initializing the SDK in when UIApplication is unavailable [#1748](https://github.com/facebook/facebook-ios-sdk/issues/1748)
- Issue caused by `initializeSDK` deprecation [#1731](https://github.com/facebook/facebook-ios-sdk/issues/1731)

[2021-07-23](https://github.com/facebook/facebook-ios-sdk/releases/tag/v11.1.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v11.0.1...v11.1.0)

## 11.0.1

### Added

- Add background refresh status logging

### Changed

- No longer automatically showing UI for GraphErrorRecoveryProcessor

### Fixed

- Fix nil completion handler crash - ([@revolter](https://github.com/revolter) in [#1768](https://github.com/facebook/facebook-ios-sdk/pull/1768))
- Fix AEM HMAC generation issue

[2021-06-22](https://github.com/facebook/facebook-ios-sdk/releases/tag/v11.0.1) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v11.0.0...v11.0.1)

## 11.0.0

ATTENTION: The Platform SDK v11.0 release introduces a few key changes to how dependencies will be managed moving forward.  These changes are being implemented to drive more efficiency in our development process and reduce an over-reliance on singletons and tight coupling.. As part of these changes, we are currently in the process of converting existing types to use injected dependencies. As a result, many types will no longer be usable until the SDK is initialized. In order to ensure that types are configured correctly before being used, you will need to call `FBSDKApplicationDelegate.application:didFinishLaunchingWithOptions:` first before attempting to (i) get or set any properties, or (ii) invoke any methods on the SDK.

The source code has been updated to include reminders in the form of exceptions in `DEBUG` builds across several locations. These reminders will serve as pointers for Developers to call `FBSDKApplicationDelegate.application:didFinishLaunchingWithOptions:` before using the SDK. For more information see: https://github.com/facebook/facebook-ios-sdk/issues/1763.

### Added

- Login with Facebook iOS app now populates a shared `AuthenticationToken` instance.
- Added Limited Login support for `user_hometown`, `user_location`, `user_gender` and `user_link` permissions under public beta.
- Updated Profile on Limited Login to include first, middle and last name as separate fields.
- Released `user_messenger_contact` permission to enable Login Connect with Messenger. This new feature allows people to opt in to being contacted by a business on Messenger following the FB Login flow.
- Added ability to add `messenger_page_id` param to `FBSDKLoginButton` and `FBSDKLoginConfiguration`
- Added `FBSDKApplicationObserving` - a protocol for describing types that can optional respond to lifecycle events propagated by `ApplicationDelegate`
- Added `addObserver:` and `removeObserver:` to `FBSDKApplicationDelegate`
- Added `startWithCompletion:` to `FBSDKGraphRequest`. Replaces `startWithCompletionHandler:`
- Added `addRequest:completion` to `FBSDKGraphRequestConnection`. Replaces `addRequest:completionHandler:`.
- Added `addRequest:name:completion:` to `FBSDKGraphRequestConnection`. Replaces `addRequest:batchEntryName:completionHandler:`.
- Added `addRequest:parameters:completion:` to `FBSDKGraphRequestConnection`. Replaces `addRequest:batchParameters:completionHandler:`.
- Added instance method `activateApp` to `AppEvents`.

### Deprecated

- `FBSDKGraphRequestBlock`. Replaced by `FBSDKGraphRequestCompletion` which returns an abstract `FBSDKGraphRequestConnection` in the form `id<FBSDKGraphRequestConnecting>` (ObjC) or `GraphRequestConnecting` (Swift)
- `FBSDKGraphRequest`'s `startWithCompletionHandler:` replaced by `startWithCompletion:`
- `FBSDKGraphRequestConnection`'s `addRequest:completionHandler:` replaced by `addRequest:completion:`
- `FBSDKGraphRequestConnection`'s `addRequest:batchEntryName:completionHandler:` replaced by `addRequest:name:completion:`
- `FBSDKGraphRequestConnection`'s `addRequest:batchParameters:completionHandler:` replaced by `addRequest:parameters:completion:`
- `FBSDKGraphRequestBlock`
- Class method `AppEvents.activateApp`. It is replaced by an instance method of the same name.

### Removed

- `FBSDKApplicationDelegate.initializeSDK:launchOptions:`. The replacement method is `FBSDKApplicationDelegate.application:didFinishLaunchingWithOptions:`
- `FBSDKAppEvents`' `updateUserProperties:handler:` method.
- `FBSDKAppEvents`'s `updateUserProperties:handler:` method.
- `FBSDKAppLinkReturnToRefererControllerDelegate`
- `FBSDKAppLinkReturnToRefererController`
- `FBSDKIncludeStatusBarInSize`
- `FBSDKAppLinkReturnToRefererViewDelegate`
- `FBAppLinkReturnToRefererView`
- `FBSDKErrorRecoveryAttempting`'s `attemptRecoveryFromError:optionIndex:delegate:didRecoverSelector:contextInfo:`
- `FBSDKProfile`'s `initWithUserID:firstName:middleName:lastName:name:linkURL:refreshDate:imageURL:email:`
- `FBSDKProfile`'s `initWithUserID:firstName:middleName:lastName:name:linkURL:refreshDate:imageURL:email:friendIDs:birthday:ageRange:isLimited:`
- `FBSDKProfile`'s `initWithUserID:firstName:middleName:lastName:name:linkURL:refreshDate:imageURL:email:friendIDs:`
- `FBSDKProfile`'s `initWithUserID:firstName:middleName:lastName:name:linkURL:refreshDate:imageURL:email:friendIDs:birthday:ageRange:`
- `FBSDKAccessTokensBlock`
- `FBSDKTestUsersManager`
- `FBSDKGraphErrorRecoveryProcessor`'s `delegate` property
- `FBSDKGraphErrorRecoveryProcessor`'s `didPresentErrorWithRecovery:contextInfo:`
- `FBSDKGamingVideoUploader`'s `uploadVideoWithConfiguration:andCompletionHandler:`
- `FBSDKGamingImageUploader`'s `uploadImageWithConfiguration:andCompletionHandler:`

[2021-06-01](https://github.com/facebook/facebook-ios-sdk/releases/tag/v11.0.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v9.3.0...v11.0.0)

## 10.0.0 (Release Skipped)

**NOT RELEASED**

Reason: The SDK is primarily a means of interacting with the Graph API. The decision was made to skip this version in order to maintain major version parity. Since Graph API is on v11, it did not make sense to release a v10 then immediately release a v11.

## 9.3.0

### Important

**Performance Improvements**

- Cocoapods: FBSDKCoreKit rebuilds FacebookSDKStrings.bundle so xcode processes the strings files into binary plist format. This strips comments and saves ~181KB in disk space for apps. [#1713](https://github.com/facebook/facebook-ios-sdk/pull/1713)

### Added

- Added AEM (Aggregated Events Measurement) support under public beta.
- Added `external_id` support in advanced matching.
- `GamingServicesKit` changed the Game Request feature flow where if the user has the facebook app installed, they will not see a webview to complete a game request. Instead they will switch to the facebook app and app switch back once the request is sent or the user cancels the dialog.

### Fixed

- Fix for shadowing swift type. [#1721](https://github.com/facebook/facebook-ios-sdk/pull/1721)
- Optimization for cached token fetching. See the [commit message](https://github.com/facebook/facebook-ios-sdk/commit/13fabd2f9ea2036b533f86e9443e201951e4e707) for more details.
- Cocoapods with generate_multiple_pod_projects [#1709](https://github.com/facebook/facebook-ios-sdk/pull/1709)

[2021-04-25](https://github.com/facebook/facebook-ios-sdk/releases/tag/v9.3.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v9.2.0...v9.3.0)

## 9.2.0

### Added

- Added Limited Login support for `user_friends`, `user_birthday` and `user_age_range` permissions under public beta.
- Shared Profile instance will be populated with `birthday` and `ageRange` fields using the claims from the `AuthenticationToken`. (NOTE: birthday and ageRange fields are in public beta mode)
- Added a convenience initializer to `Profile` as part of fixing a bug where upgrading from limited to regular login would fail to fetch the profile using the newly available access token.
- `GamingServicesKit` added an observer class where if developers set the delegate we will trigger the delegate method with a `GamingPayload` object if any urls contain gaming payload data. (NOTE: This feature is currently under development)

### Fixed

**Performance Improvements**

- Added in memory cache for carrier and timezone so they are not dynamically loaded on every `didBecomeActive`
- Added cached `ASIdentifierManager` to avoid dynamic loading on every `didBecomeActive`
- Backgrounds the expensive property creation that happens during AppEvents class initialization.
- Added thread safety for incrementing the serial number used by the logging utility.
- Added early return to Access Token to avoid unnecessary writes to keychain which can cause performance issues.

**Bug Fixes**

- Fixed using CocoaPods with the `generate_multiple_pod_projects` flag. [#1707](https://github.com/facebook/facebook-ios-sdk/issues/1707)
- Adhere to flush behavior for logging completion. Will now only flush events if the flush behavior is `explicitOnly`.
- Static library binaries are built with `BITCODE_GENERATION_MODE = bitcode` to fix errors where Xcode is unable to build apps with bitcode enabled. [#1698](https://github.com/facebook/facebook-ios-sdk/pull/1698)

### Deprecated

- `TestUsersManager`. The APIs that back this convenience type still exist but there is no compelling reason to have this be part of the core SDK. See the [commit message](https://github.com/facebook/facebook-ios-sdk/commit/441f7fcefadd36218b81fbca0a5d406ceb86a2da) for more on the rationale.

### Removed

- Internal type `AudioResourceLoader`.

[2021-04-06](https://github.com/facebook/facebook-ios-sdk/releases/tag/v9.2.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v9.1.0...v9.2.0)

## 9.1.0

### Added

- `friendIDs` property added to `FBSDKProfile` (NOTE: We are building out the `friendIDs` property in Limited Login with the intention to roll it out in early spring)
- `FBSDKProfile` initializer that includes optional `friendIDs` argument
- `claims` property of type `FBSDKAuthenticationTokenClaims` added to `FBSDKAuthenticationToken`

### Fixed

- Build Warnings for SPM with Xcode 12.5 Beta 2 [#1661](https://github.com/facebook/facebook-ios-sdk/pull/1661)
- Memory leak in `FBSDKGraphErrorRecoveryProcessor`
- Name conflict for Swift version of `FBSDKURLSessionTask`
- Avoids call to `AppEvents` singleton when setting overriding app ID [#1647](https://github.com/facebook/facebook-ios-sdk/pull/1647)
- CocoaPods now compiles `FBSDKDynamicFrameworkLoader` with ARC.
- CocoaPods now uses static frameworks as the prebuilt libraries for the aggregate FacebookSDK podspec
- App Events use the correct token if none have been provided manually ([@ptxmac](https://github.com/ptxmac)[#1670](https://github.com/facebook/facebook-ios-sdk/pull/1670)

### Deprecated

- `FBSDKGraphErrorRecoveryProcessor`'s `delegate` property
- `FBSDKGraphErrorRecoveryProcessor`'s `didPresentErrorWithRecovery:contextInfo:` method
- `FBSDKAppLinkReturnToRefererView`
- `FBSDKAppLinkReturnToRefererController`

### Removed

- Internal type `FBSDKErrorRecoveryAttempter`

[2021-02-25](https://github.com/facebook/facebook-ios-sdk/releases/tag/v9.1.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v9.0.1...v9.1.0)

## 9.0.1

### Added

- Add control support for the key FacebookSKAdNetworkReportEnabled in the info.plist
- Add APIs to control SKAdNetwork Report

### Fixed

- Fix deadlock issue between SKAdNetwork Report and AAM/Codeless
- Fix default ATE sync for the first app launch
- Fix build error caused by LoginButton nonce property ([@kmcbride](https://github.com/kmcbride) in [#1616](https://github.com/facebook/facebook-ios-sdk/pull/1616))
- Fix crash on FBSDKWebViewAppLinkResolverWebViewDelegate ([@Kry256](https://github.com/Kry256) in [#1624](https://github.com/facebook/facebook-ios-sdk/pull/1624))
- Fix XCFrameworks build issue (#1628)
- Fix deadlock when AppEvents ActivateApp is called without initializing the SDK (#1636)

[2021-02-02](https://github.com/facebook/facebook-ios-sdk/releases/tag/v9.0.1) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v9.0.0...v9.0.1)

## 9.0.0

We have a number of exciting changes in this release!
For more information on the v9 release please read our associated blog [post](https://developers.facebook.com/blog/post/2021/01/19/introducing-facebook-platform-sdk-version-9/)!

### Added

- Swift Package Manager now supports Mac Catalyst
- Limited Login. Please read the blog [post](https://developers.facebook.com/blog/post/2021/01/19/facebook-login-updates-new-limited-data-mode) and [docs](https://developers.facebook.com/docs/facebook-login/ios/limited-login/) for a general overview and implementation details.

### Changed

- The default Graph API version is updated to v9.0
- The `linkURL` property of `FBSDKProfile` will only be populated if the user has granted the `user_link` permission.
- FBSDKGamingServicesKit will no longer embed FBSDKCoreKit as a dependency. This may affect you if you are manually integrating pre-built binaries.
- The aggregate CocoaPod `FacebookSDK` now vendors XCFrameworks. Note: this may cause conflicts with other CocoaPods that have dependencies on the our libraries, ex: Audience Network. If you encounter a conflict it is easy to resolve by using one or more of the individual library pods instead of the aggregate pod.

### Removed

- The `autoInitEnabled` option is removed from the SDK. From here on, developers are required to initialize the SDK explicitly with the `initializeSDK` method or implicitly by calling it in `applicationDidFinishLaunching`.

### Fixed

- Swift Package Manager Mac Catalyst support [#1577](https://github.com/facebook/facebook-ios-sdk/issues/1577)

[2021-01-05](https://github.com/facebook/facebook-ios-sdk/releases/tag/v9.0.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v8.2.0...v9.0.0)

## 8.2.0

### Changed
- Remove SignalHandler to avoid hiding root cause of crashes caused by fatal signals.
- Expose functions in `FBSDKUserDataStore` as public for apps using [Audience Network SDK](https://developers.facebook.com/docs/audience-network) only to use advanced matching.

[2020-11-10](https://github.com/facebook/facebook-ios-sdk/releases/tag/v8.2.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v8.1.0...v8.2.0)

## 8.1.0

### Added
- Introduced `AppLinkResolverRequestBuilder` for use in cleaning up and adding tests around `AppLinkResolver`

### Changed
- Removed version checks for iOS 9 since it’s the default version now.
- Refactored `AppLinkResolver` to use a request builder
- Refactored and added tests around `FBSDKProfile` and `FBSDKProfilePictureView`
- Updated `FBSDKSettings` to use `ADIdentifierManager` for tracking status
- Removes usages of deprecated `UI_USER_INTERFACE_IDIOM()`

### Fixed
- Issues with Swift names causing warnings - #1522
- Fixes bugs related to crash handling - #1444
- Fixes Carthage distribution to include the correct binary slices when building on Xcode12 - #1484
- Fixes duplicate symbol for `FBSDKVideoUploader` bug #1512
- GET requests now default to having a 'fields' parameter to avoid warnings about missing fields #1403
- Fixes Multithreading issue related to crash reporting - #1550

[2020-10-23](https://github.com/facebook/facebook-ios-sdk/releases/tag/v8.1.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v8.0.0...v8.1.0)

## 8.0.0

## Added
- Added timestamp for install event in iOS 14
- Added method `setAdvertiserTrackingEnabled` to overwrite the `advertiser_tracking_enabled` flag
- Added `SKAdNetwork` support for installs
- Added `SKAdNetwork` support for conversion value in iOS 14
- Added `FBSDKReferralManager` for integrating with the web referral dialog
- Added method `loginWithURL` to `FBSDKLoginManager` for supporting deep link authentication
- Added E2E tests for all in-market versions of the SDK that run on server changes to avoid regressions

## Changed
- Event handling in iOS 14: will drop events if `setAdvertiserTrackingEnabled` is called with `false` in iOS 14
- `FBSDKProfile - imageURLForPictureMode:size:` - User profile images will only be available when an access or client token is available

## Deprecated
- `FBSDKSettings - isAutoInitEnabled` - Auto-initialization flag. Will be removed in the next major release. Future versions of the SDK will not utilize the `+ load` method to automatically initialize the SDK.

## Fixed / Patched
- #1444 - Update crash handling to use sigaction in signal handler and respect SIG_IGN
- #1447 - Login form automatically closing when SDK is not initialized on startup
- #1478 - Minimum iOS deployment target is now 9.0
- #1485 - StoreKit is now added as a weak framework for CocoaPods
- Bug fix for Advanced Matching, which was not working on iOS 14

[2020-09-22](https://github.com/facebook/facebook-ios-sdk/releases/tag/v8.0.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v7.1.1...v8.0.0)

## 7.1.1

## Fixed

- Fix data processing options issue

[2020-06-25](https://github.com/facebook/facebook-ios-sdk/releases/tag/v7.1.1) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v7.1.0...v7.1.1)

## 7.1.0

## Added

- Introduce DataProcessingOptions

### Deprecated

- Remove UserProperties API

[2020-06-23](https://github.com/facebook/facebook-ios-sdk/releases/tag/v7.1.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v7.0.1...v7.1.0)

## 7.0.1

🚨🚨🚨Attention! 🚨🚨🚨

This release fixes the ability to parse bad server configuration data. Please upgrade to at least this version to help avoid major outtages such as [#1374](https://github.com/facebook/facebook-ios-sdk/issues/1374) and [#1427](https://github.com/facebook/facebook-ios-sdk/issues/1427)

## Added
- Added additional unit tests for FBSDKRestrictiveDataFilterManager
- Added integration test for building with xcodebuild
- Added safer implementation of `NSJSONSerialization` methods to `FBSDKTypeUtility` and changed callsites
- Added 'fuzz' testing class to test our network response parsing won't crash from bad/unexpected values

## Fixed

- Issue #1401
- Issue #1380
- Previously, we could not remove AAM data if we opt out some rules. Now, we align with Android AAM and add an internalUserData to save AAM data. And we only send back the data of enabled AAM rules.
- Fix a bug where we were not updating Event Deactivation or Restrictive Data Filtering if the `enable()` function was called after the `update()` function
- Restrictive data filtering bug where updating filters would exit early on an empty eventInfo parameter.
- Enabling bitcode by default; we used to disable bitcode globally and enable it for certain versions of iphoneos due to Xcode 6 issue, given we've dropped the support for Xcode 6, it's cleaner to enable bitcode by default.

## Changed
- Now using `FBSDKTypeUtility` to provide type safety for Dictionaries and Arrays
- Updates code so that `NSKeyedUnarchiver` method calls will continue to work no matter what the iOS deployment target is set to.
- Skips sending back app events when there are no encoded events.

## Deprecated

- MarketingKit

[2020-06-08](https://github.com/facebook/facebook-ios-sdk/releases/tag/v7.0.1) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v7.0.0...v7.0.1)

## 7.0.0

## Changed

- Using version 7.0 of the Facebook Graph API
- Dropping support for Xcode versions below 11. This is in line with [Apple's plans](https://developer.apple.com/news/?id=03262020b) to disallow submission of Apps that do not include the iOS 13 SDK.
This means that from v7.0 on, all SDK kits will be built using Xcode 11 and Swift 5.1.
- Include the enhanced Swift interfaces

This primarily matters for how you include CocoaPods

| Distribution Channel  | Old way                              | New Way              |
| :---                  | :---                                 | :---                 |
| CocoaPods             | `pod 'FBSDKCoreKit/Swift'`           | `pod 'FBSDKCoreKit'` |
| Swift Package Manager | No change                            | No change            |
| Carthage              | No change                            | No change            |

## Deprecated

- FBSDKMarketingKit

[2020-05-05](https://github.com/facebook/facebook-ios-sdk/releases/tag/v7.0.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v6.5.2...v7.0.0)

## 6.5.2

- Various bug fixes

[2020-04-29](https://github.com/facebook/facebook-ios-sdk/releases/tag/v6.5.2) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v6.5.1...v6.5.2)

## 6.5.1

## Fixed

- The Swift interface for SharingDelegate should not have a nullable error in the callback.
- Fixes issue with login callback during backgrounding.
- Minor fixes related to Integrity

[2020-04-23](https://github.com/facebook/facebook-ios-sdk/releases/tag/v6.5.1) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v6.5.0...v6.5.1)

## 6.5.0

## Added

- More usecase for Integrity is supported.

[2020-04-20](https://github.com/facebook/facebook-ios-sdk/releases/tag/v6.5.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v6.4.0...v6.5.0)

## 6.4.0

## Added

FBSDKMessageDialog now accepts FBSDKSharePhotoContent.

FBSDKGamingServicesKit/FBSDKGamingImageUploader.h
`uploadImageWithConfiguration:andResultCompletionHandler:`
`uploadImageWithConfiguration:completionHandler:andProgressHandler:`

FBSDKGamingServicesKit/FBSDKGamingVideoUploader.h
`uploadVideoWithConfiguration:andResultCompletionHandler:`
`uploadVideoWithConfiguration:completionHandler:andProgressHandler:`

## Deprecated

FBSDKGamingServicesKit/FBSDKGamingImageUploader.h
`uploadImageWithConfiguration:andCompletionHandler:`

FBSDKGamingServicesKit/FBSDKGamingVideoUploader.h
`uploadVideoWithConfiguration:andCompletionHandler:`

[2020-03-25](https://github.com/facebook/facebook-ios-sdk/releases/tag/v6.4.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v6.3.0...v6.4.0)

## Changed

Various bug fixes, CI improvements

## 6.3.0

## Added

- Support new event type for suggested events

[2020-03-25](https://github.com/facebook/facebook-ios-sdk/releases/tag/v6.3.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v6.2.0...v6.3.0)

## 6.2.0

## Added

- Support for Gaming Video Uploads
- Allow Gaming Image Uploader to accept a callback
- [Messenger Sharing](https://developers.facebook.com/docs/messenger-platform/changelog/#20200304)

[2020-03-09](https://github.com/facebook/facebook-ios-sdk/releases/tag/v6.2.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v6.0.0...v6.2.0)

## 6.0.0

### Updated

- Uses API version 6.0 by default

### Fixed

- `FBSDKShareDialog` delegate callbacks on apps using iOS 13

### Removed

#### ShareKit

- Facebook Messenger Template and OpenGraph Sharing
- `FBSDKMessengerActionButton`
- `FBSDKShareMessengerGenericTemplateContent`
- `FBSDKShareMessengerGenericTemplateElement`
- `FBSDKShareMessengerMediaTemplateMediaType`
- `FBSDKShareMessengerMediaTemplateContent`
- `FBSDKShareMessengerOpenGraphMusicTemplateContent`
- `FBSDKShareMessengerURLActionButton`
- `FBSDKShareAPI` since it exists to make sharing of open graph objects easier. It also requires  the deprecated `publish_actions` permission which is deprecated.
- Property `pageID` from `FBSDKSharingContent` since it only applies to sharing to Facebook Messenger
- `FBSDKShareOpenGraphAction`
- `FBSDKShareOpenGraphContent`
- `FBSDKShareOpenGraphObject`
- `FBSDKShareOpenGraphValueContainer`

#### CoreKit

- `FBSDKSettings` property `instrumentEnabled`
- Sharing of open graph objects. This is because the "publish_actions" permission is deprecated so we should not be providing helper methods that encourage its use. For more details see: https://developers.facebook.com/docs/sharing/opengraph
- `FBSDKAppEventNameSubscriptionHeartbeat`

#### LoginKit

- `FBSDKLoginBehavior` Login flows no longer support logging in through the native application. This change reflects that.

[2020-02-03](https://github.com/facebook/facebook-ios-sdk/releases/tag/v6.0.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v5.15.1...v6.0.0)

## 5.15.1

### Fixed
- fix multi-thread issue for Crash Report
- fix write to file issue for Crash Report

[2020-01-28](https://github.com/facebook/facebook-ios-sdk/releases/tag/v5.15.1) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v5.15.0...v5.15.1)

## 5.15.0

### Fixed

- fix for CocoaPods (i.e. macro `FBSDKCOCOAPODS`)
- fixes a bug in for sharing callbacks for apps using SceneDelegate

[2020-01-21](https://github.com/facebook/facebook-ios-sdk/releases/tag/v5.15.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v5.14.0...v5.15.0)

## 5.14.0

### Added

- SPM Support for tvOS

### Fixed

- fix for CocoaPods static libs (i.e. no `use-frameworks!`)
- various bug fixes and unit test additions

[2020-01-14](https://github.com/facebook/facebook-ios-sdk/releases/tag/v5.14.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v5.13.1...v5.14.0)

## 5.13.1

### Fixed

- bug fix for address inferencer weights load

[2019-12-16](https://github.com/facebook/facebook-ios-sdk/releases/tag/v5.13.1) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v5.13.0...v5.13.1)

## 5.13.0

[2019-12-11](https://github.com/facebook/facebook-ios-sdk/releases/tag/v5.13.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v5.12.0...v5.13.0)

### Added
- Parameter deactivation

### Fixed
- Update ML model to support non-English input

## 5.12.0

### Changed
- Updated suggested events

[2019-12-03](https://github.com/facebook/facebook-ios-sdk/releases/tag/v5.12.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v5.11.1...v5.12.0)

## 5.11.1

[2019-11-19](https://github.com/facebook/facebook-ios-sdk/releases/tag/v5.11.1) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v5.11.0...v5.11.1)

### Fixed

- Accelerate automatically linked for SPM installs [6c1a7e](https://github.com/facebook/facebook-ios-sdk/commit/6c1a7ea6d8a8aec23bf00a0da1dfb03214741c58)
- Fixes building for Unity [6a83270](https://github.com/facebook/facebook-ios-sdk/commit/6a83270d5b4f9bbbe49ae9b323a09ffc392dcc00)
- Updates build scripts, various bug fixes

## 5.11.0

[2019-11-14](https://github.com/facebook/facebook-ios-sdk/releases/tag/v5.11.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v5.10.1...v5.11.0)

### Added
- Launch event suggestions

## 5.10.1

[2019-11-12](https://github.com/facebook/facebook-ios-sdk/releases/tag/v5.10.1) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v5.10.0...v5.10.1)

### Fixed

- Various bugfixes with SPM implementation

## 5.10.0

[2019-11-06](https://github.com/facebook/facebook-ios-sdk/releases/tag/v5.10.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v5.9.0...v5.10.0)

### Added

- Support for Swift Package Manager

## 5.9.0

[2019-10-29](https://github.com/facebook/facebook-ios-sdk/releases/tag/v5.9.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v5.8.0...v5.9.0)

### Changed

- Using Graph API version 5.0

## 5.8.0

[2019-10-08](https://github.com/facebook/facebook-ios-sdk/releases/tag/v5.8.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v5.7.0...v5.8.0)

### Added

- Launch automatic advanced matching: https://www.facebook.com/business/help/2445860982357574

## 5.7.0

[2019-09-30](https://github.com/facebook/facebook-ios-sdk/releases/tag/v5.7.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v5.6.0...v5.7.0)

### Changed
- Nullability annotation in FBSDKCoreKit

### Fixed
- Various bug fixes
- Build scripts (for documentation and to support libraries that include Swift)

## 5.6.0

[2019-09-13](https://github.com/facebook/facebook-ios-sdk/releases/tag/v5.6.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v5.5.0...v5.6.0)

### Changed
- Fixed FB Login for multi-window apps that created via Xcode 11
- Added support for generate_multiple_pod_projects for cocoapods 1.7.0
- Improved performance and stability of crash reporting
- Added user agent suffix for macOS

### Fixed
- Various bug fixes

## 5.5.0

[2019-08-30](https://github.com/facebook/facebook-ios-sdk/releases/tag/v5.5.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v5.4.1...v5.5.0)

### Changed
- Replaced UIWebView with WKWebView as Apple will stop accepting submissions of apps that use UIWebView APIs
- Added support for Catalyst

### Fixed
- Various bug fixes

## 5.4.1

[2019-08-21](https://github.com/facebook/facebook-ios-sdk/releases/tag/v5.4.1) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v5.4.0...v5.4.1)

### Changed
- Deprecated `+[FBSDKSettings isInstrumentEnabled]`, please use `+[FBSDKSettings isAutoLogEnabled]` instead

### Fixed
- Fix Facebook Login for iOS 13 beta
- Various bug fixes

## 5.4.0

[2019-08-15](https://github.com/facebook/facebook-ios-sdk/releases/tag/v5.4.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v5.3.0...v5.4.0)

### Changed
- Add handling for crash and error to make SDK more stable

## 5.3.0

[2019-07-29](https://github.com/facebook/facebook-ios-sdk/releases/tag/v5.3.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v5.2.3...v5.3.0)

### Changed
- Graph API update to v4.0

## 5.2.3

[2019-07-15](https://github.com/facebook/facebook-ios-sdk/releases/tag/v5.2.3) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v5.2.2...v5.2.3)

### Fixed
- Fixed Facebook Login issues

## 5.2.2

[2019-07-14](https://github.com/facebook/facebook-ios-sdk/releases/tag/v5.2.2) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v5.2.1...v5.2.2)

### Fixed
- Fixed Facebook Login on iOS 13 beta
- Various bug fixes

## 5.2.1

[2019-07-02](https://github.com/facebook/facebook-ios-sdk/releases/tag/v5.2.1) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v5.2.0...v5.2.1)

### Fixed

- Various bug fixes

## 5.2.0

[2019-06-30](https://github.com/facebook/facebook-ios-sdk/releases/tag/v5.2.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v5.1.1...v5.2.0)

### Fixed

- Fixed a crash caused by sensitive data filtering
- Fixed FB Login for iOS 13

## 5.1.1

[2019-06-22](https://github.com/facebook/facebook-ios-sdk/releases/tag/v5.1.1) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v5.1.0...v5.1.1)

## 5.1.0

[2019-06-21](https://github.com/facebook/facebook-ios-sdk/releases/tag/v5.1.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v5.0.2...v5.1.0)

## 5.0.2
[2019-06-05](https://github.com/facebook/facebook-ios-sdk/releases/tag/v5.0.2) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v5.0.1...v5.0.2)

### Fixed

- Various bug fixes

## 5.0.1
[2019-05-21](https://github.com/facebook/facebook-ios-sdk/releases/tag/v5.0.1) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v5.0.0...v5.0.1)

### Fixed

- Various bug fixes

## 5.0.0

[2019-04-30](https://github.com/facebook/facebook-ios-sdk/releases/tag/v5.0.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v4.44.1...v5.0.0)

### Added
- support manual SDK initialization

### Changed
- extend coverage of AutoLogAppEventsEnabled flag to all internal analytics events

### Added

- Typedefs for public Objective-C blocks
- `NS_DESIGNATED_INITIALIZER` for required inits
- `NS_TYPED_EXTENSIBLE_ENUM` where made sense
- `getter` name for certain properties, like booleans
- `NS_ASSUME_NONNULL_BEGIN`, `NS_ASSUME_NONNULL_END`, and other nullability annotations
- Generics for Arrays, Sets, and Dictionaries
- `NS_SWIFT_NAME` to remove the `FBSDK` prefix where necessary (left `FB` prefix for UI elements)
- `FBSDKLoginManager -logInWithPermissions:fromViewController:handler:`
- `FBSDKLoginButton permissions`
- `FBSDKDeviceLoginButton permissions`
- `FBSDKDeviceLoginViewController permissions`
- New `FBSDKAppEventName` values

### Changed

- Using `instancetype` for inits
- All `NSError **` translate to throws on Swift
- Updated Xcode Projects and Schemes to most Valid Project settings
- Getter methods changed to `readonly` properties
- Getter/Setter methods changed to `readwrite` properties
- Dot notation for access to properties
- Collections/Dictionaries became non null when at all possible
- Class creation methods become Swift inits
- Used `NS_REFINED_FOR_SWIFT` where advisable

### Deprecated

- `FBSDKLoginManager -logInWithReadPermissions:fromViewController:handler:`
- `FBSDKLoginManager -logInWithWritePermissions:fromViewController:handler:`
- `FBSDKLoginButton readPermissions`
- `FBSDKLoginButton writePermissions`
- `FBSDKDeviceLoginButton readPermissions`
- `FBSDKDeviceLoginButton writePermissions`
- `FBSDKDeviceLoginViewController readPermissions`
- `FBSDKDeviceLoginViewController writePermissions`
- `FBSDKUtility SHA256HashString`
- `FBSDKUtility SHA256HashData`

### Removed

- Deprecated methods
- Deprecated classes
- Deprecated properties
- Made `init` and `new` unavailable where necessary
- Used `NS_SWIFT_UNAVAILABLE` where necessary

### Fixed

- Various bug fixes

### 5.X Upgrade Guide

#### All Developers

- Light-weight generics have been added for Arrays, Sets, and Dictionaries. Make sure you're passing in the proper
  types.
- Some methods used to have closures as arguments, but did not have them as the final argument. All these methods have
  been rearranged to have the closure as the final argument.

#### ObjC Developers

- Certain string values, like App Event Names and HTTP Method, have been made NSString typedef with the
  `NS_TYPED_EXTENSIBLE_ENUM` attribute. All your existing code should work just fine.

#### Swift Developers

- `NS_SWIFT_NAME` was applied where applicable. Most of these changes Xcode can fix automatically.
  - The `FBSDK` prefix for UI elements has been replaced with the simpler `FB` prefix.
  - The `FBSDK` prefix for all other types has been removed.
  - `FBSDKError` is now `CoreError`.
- `NS_ERROR_ENUM` is used to handling errors now. For more details, view Apple's documentation on
  [Handling Cocoa Errors in Swift](https://developer.apple.com/documentation/swift/cocoa_design_patterns/handling_cocoa_errors_in_swift).
- Certain string values, like App Event Names and HTTP Method, have been made extensible structs with the
  `NS_TYPED_EXTENSIBLE_ENUM` attribute:
  - `FBSDKAppEventNamePurchased` -> `AppEvents.Name.purchased`
  - `"custom_app_event"` -> `AppEvents.Name("custom_app_event")`
- Certain values have been annotated with `NS_REFINED_FOR_SWIFT` and can be customized via either:
  1. The Facebook SDK in Swift (Beta)
  2. Implementing custom extensions

```swift
// Custom extensions
public extension AccessToken {
  var permissions: Set<String> {
    return Set(__permissions)
  }
}

extension AppEvents.Name {
  static let customAppEvent = AppEvents.Name("custom_app_event")
}

extension ShareDialog.Mode: CustomStringConvertible {
  public var description: String {
    return __NSStringFromFBSDKShareDialogMode(self)
  }
}

// Later in code
let perms: Set<String> = AccessToken(...).permissions

let event: AppEvents.Name = .customAppEvent

let mode: ShareDialog.Mode = .native
let description: String = "\(mode)"
```

## 4.44.1

[2019-04-11](https://github.com/facebook/facebook-ios-sdk/releases/tag/v4.44.1) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v4.44.0...v4.44.1)

### Fixed

- `_inBackground` now indicates correct application state

## 4.44.0

[2019-04-02](https://github.com/facebook/facebook-ios-sdk/releases/tag/v4.44.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v4.43.0...v4.44.0)

### Added

- Add parameter `_inBackground` for app events

### Fixed

- Various bug fixes

## 4.43.0

[2019-04-01](https://github.com/facebook/facebook-ios-sdk/releases/tag/v4.43.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v4.42.0...v4.43.0)

### Added

- Support for Xcode 10.2

### Deprecated

- `FBSDKLoginBehaviorNative`
- `FBSDKLoginBehaviorSystemAccount`
- `FBSDKLoginBehaviorWeb`
- `[FBSDKLoginManager renewSystemCredentials]`

### Fixed

- Various bug fixes

## 4.42.0

[2019-03-20](https://github.com/facebook/facebook-ios-sdk/releases/tag/v4.42.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v4.41.2...v4.42.0)

### Changed

- Moved directory structure for better separation

### Fixed

- Various bug fixes

## 4.41.2

[2019-03-18](https://github.com/facebook/facebook-ios-sdk/releases/tag/v4.41.2) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v4.41.1...v4.41.2)

### Fixed

- Resolved issues with the release process
- Various bug fixes

## 4.41.1

[2019-03-18](https://github.com/facebook/facebook-ios-sdk/releases/tag/v4.41.1) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v4.41.0...v4.41.1)

### Fixed

- Resolved build failures with Carthage and Cocoapods
- Various bug fixes

## 4.41.0

[2019-03-13](https://github.com/facebook/facebook-ios-sdk/releases/tag/v4.41.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v4.40.0...v4.41.0)

### Fixed

- Various bug fixes

## 4.40.0

[2019-01-17](https://github.com/facebook/facebook-ios-sdk/releases/tag/v4.40.0) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/v4.39.1...v4.40.0)

### Fixed

- Various bug fixes

## 4.39.1

[2019-01-08](https://github.com/facebook/facebook-ios-sdk/releases/tag/v4.39.1) |
[Full Changelog](https://github.com/facebook/facebook-ios-sdk/compare/sdk-version-4.0.0...v4.39.1) |
[Facebook Developer Docs Changelog](https://developers.facebook.com/docs/ios/change-log-4x)
