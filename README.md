## Index
- [Goals](#goal)
- [Evaluation](#evaluation)
- [Installation](#installation)
- [Demo Video](#demo)
- [Process Followed](#process-followed)
- [Optimizations / Best Practises Incorporated](#optimizations-and-best-practises-incorporated)
- [Optimizations Considered / Tried](#optimizations-considered-and-tried)
- [Future Optimizations Plans](#future-optimizations-plans)
- [Screenshots](#screenshots)

# Mobile Developer Coding Challenge

This is a coding challenge for prospective mobile developer applicants applying through http://work.traderev.com/

## Goal

#### Build simple app that allows viewing and interacting with a grid of curated photos from Unsplash: Completed all above criteria.

- [x] Fork this repo. Keep it public until we have been able to review it.
- [x] iOS: _Swift 5.8_
- [x] Unsplash API docs are here: https://unsplash.com/documentation.
- [X] Grid of photos should preserve the aspect ratio of the photos it's displaying, meaning you shouldn't crop the image in any way.
- [x] App should work in both portrait and landscape orientations of the device.
- [x] Grid should support pagination, i.e. you can scroll on grid of photos infinitely.
- [x] When user taps on a photo on the grid it should show only the tapped photo in full screen with more information about the photo.
- [x] When user swipes on a photo in full screen, it should show the the next photo.
- [x] Preserve current photo's location on the grid, so when she dismisses the full screen, grid of photos should contain the last photo she saw in photo details.

### Evaluation:
- [x] Solution compiles. If there are necessary steps required to get it to compile, those should be covered in README.md.
- [x] No crashes, bugs, compiler warnings
- [x] App operates as intended
- [x] Conforms to SOLID principles
- [x] Code is easily understood and communicative
- [x] Commit history is consistent, easy to follow and understand

### Installation
- Remember to use your own API key in the `Config.xcconfig` file like `UNSPLASH_API_CLIENT_ID=12345655` before running.
- Min iOS version supported is iOS 15, after the disscussion in the last round. Used XCode 14.3.1 for building.

### Demo
  [![Demo Photostic iOS Unsplash App](https://github.com/shobhitpuri/ios-coding-challenge/assets/3515359/4b2c9dcc-8b6f-4a55-837c-2307822f899a)](https://youtu.be/GuPWxQ-4wP8)

### Process Followed
1. Planning - Divide and Conquer: Created a list of tasks and prioritized it. Check [Photostic Project](https://github.com/users/shobhitpuri/projects/3/views/1)
<img width="1081" alt="Screenshot 2024-02-09 at 10 05 24 AM" src="https://github.com/shobhitpuri/ios-coding-challenge/assets/3515359/109529ee-e22d-45cc-9484-912237fd46eb">

2. Unsplash API Spike: Tooks a deep dive at the Unsplash API, seeing what all optimizations it can offer, and came to following conclusions:
   - **webP/ AVIF support**: These are much better than jpeg or others and best balacing compression / quality. Not supported for free version though.
   - [**Blur Hash**](https://github.com/woltapp/blurhash): They provide Blur Hash string that would make a great placeholder. However this was 4x slower than Android, and was making less performance, so I implemented my own version of placeholder using the `color` they send with each image and a loader. Spend a lot of time trying to make the has work with [ThumbHash](https://github.com/evanw/thumbhash/blob/main/swift/ThumbHash.swift), which is much better than Blur Hash in terms of performance, but since they use `base83` hashing, which is different than what Unsplash provides (base64), it wasn't worth the effort, givent eh time constraints.
   - **page size / per page limits / free tier limits**: It turns out that for free version many of above is not there like only 10 per page, max 50 request / hour, no custom format etc. 
   - Multiple size of Images pre-available for `thumb`, `full` etc.

3. Mocking the API: 
   - Simulated a real world enviornment where many time devs don't have API available, so working off Mocks make it faster. 
   - Limitation of free tire were 50 requests / hour, didn't want to cross that.
   - Would be useful for testing anyways.
  
4. Implemented screens and flow using the mocks.
5. Added following
    - Network logic using async await,
    - Caching,
    - MVVM pattern,
    - Pagination,
    - Splash Screen,
    - App Icon,
    - Tests etc after that.
7. Note: As a best practise, following PR process. It also showed I like to be detailed and explicits with PRs for easier review process. Sample Pull Request can be found here: [PR:# GridView and DetailsView Screens with Mocked Data](https://github.com/shobhitpuri/ios-coding-challenge/pull/1)           

### Optimizations and Best Practises Incorporated
1. CLIENT_ID / API_KEY not included in the project, and in separate config file, which is added to gitignore. [Add your key to Config.xcconfig before trying to run project](https://github.com/shobhitpuri/ios-coding-challenge/blob/master/Photostic/Photostic/Config.xcconfig).
2. Offline friendly app, with cahing of images as well as API calls (default by URLsession). Faster load times for images, and prevents unnecessary calls.
3. Error Handling done to show user alerts.
4. Constants at the top of file (could have been in a global file as well)
5. Customized Placeholder almost similar to blue effect, of exact the size of image, while maintaining the aspect ratio.
6. thumbnail size for grid view, and regular for the details.
7. NetworkManager's implementation is mockable.
8. Added a few Unit / UI tests to show possibilities.
9. Rigorous manual testing with network simulator, multiple device sizes and modes etc.
10. No 3rd party libraries.

### Optimizations Considered and Tried
1. AsyncImage: Implemented it initially but doesn't supports caching, so removed.
2. Memory mangagement: Considered implementing custom LazyTabView for image gallery. The TabView is not lazy loading in details view. There is no lazy version of that available unlike, LazyVGrid. An implementation I had was buggy, where I was considering only having 3 tabs, and just replacing images in it.
3. Network Monitor to monitor when data goes away but wasn't worth this time, after dwendling into it for a while with simulators.
4. Tried snapshot testing, but due to shortage of time, couldn't set it up.

### Future Optimizations Plans
1. Incorporate webP / AVIF format if/when I was on the paid API plan.
2. Consider decouping Network layer more maybe using a Factory pattern, such that if we use multiple Image APIs in future, the interface and logic of rest of the code remain same. We only need to make 
3. Consider implementing Repository pattern around APIs to read from local data if data not returned from remote. 
4. Deciding Image quality to load based on network quality (releavnt with remote dealerships) - multiple libraries do that.
5. Implement Logging (remote) using Singleton pattern for better debugging.
6. Make the views more accessible, eg: [Apple Accessibility guidelines](https://developer.apple.com/design/human-interface-guidelines/accessibility) talk about having buttons irrespective of gestures on the views.
7. Localization Support rather than harcoding strings
8. For the cache size, check for existing free storage on devices before deciding the number.
9. Separate constants in the codebase for better readability.
10. Zoom feature 
11. Better testing coverage.
12. Including performance benchmarks, performance tests,  snapshot tests, accessibility testing (and following best practises).
13. Animations
14. Add brand colors
15. Dark Mode support
16. Feature flags (maybe not needed for simple ones)

### Screenshots

### iPhones

  | 1 | 2 |
  |--|--|
  | ![](https://github.com/shobhitpuri/ios-coding-challenge/assets/3515359/5cbbf91c-484e-4575-9db4-aee83a8a5fed) | ![](https://github.com/shobhitpuri/ios-coding-challenge/assets/3515359/23b78005-0548-4d1f-aa06-2721cc249ba6) 

| 3 | 4 |
  |--|--|
  | ![](https://github.com/shobhitpuri/ios-coding-challenge/assets/3515359/846523fb-d985-45dd-9d84-c2eae32bf53f) |![](https://github.com/shobhitpuri/ios-coding-challenge/assets/3515359/e62934b4-7d8d-4e01-b21f-fd1592ea0056) 

  | 5 | 6 |
  |--|--|
  |![](https://github.com/shobhitpuri/ios-coding-challenge/assets/3515359/fd88758e-f198-4669-830f-f5cf304d183c)  | ![](https://github.com/shobhitpuri/ios-coding-challenge/assets/3515359/865a45a5-a2cb-45e2-be33-26e61756d3f9) 
  
  | 7 | 8 |
  |--|--|
  | ![](https://github.com/shobhitpuri/ios-coding-challenge/assets/3515359/88b272d5-02c4-4384-8c7c-13671f753323) | ![](https://github.com/shobhitpuri/ios-coding-challenge/assets/3515359/41e46b0b-3bf6-446e-84ff-1d30aa8a48c6)

  | 9 | 10 |
  |--|--|
  | ![](https://github.com/shobhitpuri/ios-coding-challenge/assets/3515359/1f40fbf8-3890-44e6-850a-99af36436e4d) | ![](https://github.com/shobhitpuri/ios-coding-challenge/assets/3515359/ec21c1f0-ce6b-4da5-a7b3-4aea5c57cfa6) 

### iPad

 | 1 | 2 |
  |--|--|
  | ![](https://github.com/shobhitpuri/ios-coding-challenge/assets/3515359/f3a21d7f-eaed-4e64-88ae-e0eb5a3ba5d6) | ![](https://github.com/shobhitpuri/ios-coding-challenge/assets/3515359/1ee16510-6c83-48ff-9b82-a8b15127d589) 


   
