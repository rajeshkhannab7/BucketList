# BucketList - App Store Publishing Checklist

## Phase 1: Apple Developer Account Setup
- [ ] **Create an Apple Developer Account** at https://developer.apple.com/programs/
  - Costs $99/year (required for App Store publishing)
  - Use your Apple ID to enroll
  - Individual enrollment (vs organization) is fine for a solo developer
  - Approval takes 24-48 hours typically

## Phase 2: App Preparation in Xcode
- [ ] **Set Bundle Identifier**: Already set to `com.bolloju.BucketList`
- [ ] **Set Version Number**: Currently `1.0` (MARKETING_VERSION)
- [ ] **Set Build Number**: Currently `1` (CURRENT_PROJECT_VERSION)
- [ ] **Create App Icon**:
  - You need a 1024x1024 pixel PNG (no transparency, no rounded corners)
  - Place it in `Assets.xcassets/AppIcon.appiconset/`
  - Tools to create icons: Canva, Figma, or hire a designer on Fiverr
- [ ] **Set Deployment Target**: Currently iOS 26.2 (consider lowering to iOS 17.0 for wider reach)
- [ ] **Add App Transport Security** settings if needed (for HTTP connections)
- [ ] **Configure Signing**:
  - Open project in Xcode > Signing & Capabilities
  - Select your Apple Developer Team
  - Xcode will auto-manage signing certificates and provisioning profiles
- [ ] **Add Google Maps URL Scheme** (for "Open in Google Maps" feature):
  - Add `comgooglemaps` to `LSApplicationQueriesSchemes` in Info.plist

## Phase 3: App Store Connect Setup
- [ ] **Log into App Store Connect** at https://appstoreconnect.apple.com
- [ ] **Create a New App**:
  - Click "My Apps" > "+" > "New App"
  - Platform: iOS
  - Name: BucketList (or "BucketList - Travel & Goals" for better discoverability)
  - Primary Language: English (U.S.)
  - Bundle ID: Select `com.bolloju.BucketList`
  - SKU: `bucketlist-001` (any unique identifier)

## Phase 4: App Store Listing Content
- [ ] **App Name**: "BucketList" (max 30 characters)
- [ ] **Subtitle**: "Track & Share Your Dream Goals" (max 30 characters)
- [ ] **Category**: Primary = "Lifestyle", Secondary = "Travel"
- [ ] **Description** (max 4000 characters):
  ```
  BucketList is your personal companion for tracking all the places you want to visit
  and experiences you want to have. Create your dream list, share with friends, and
  check off your adventures as you complete them!

  KEY FEATURES:
  • Create your personal bucket list with places, experiences, and goals
  • View locations on an interactive map
  • Open locations directly in Google Maps or Apple Maps for navigation
  • Share bucket list items with friends
  • Browse friends' shared bucket lists and add items to your own
  • Mark completed items and track your progress
  • Organize items by category: Travel, Food, Adventure, and more
  • Search and filter your bucket list easily

  Whether it's visiting the Eiffel Tower, trying authentic ramen in Tokyo, or learning
  to surf in Bali - BucketList helps you dream, plan, and achieve your goals!
  ```
- [ ] **Keywords** (max 100 characters, comma-separated):
  ```
  bucket list,travel,goals,places,wishlist,adventure,experiences,trip planner,map,friends
  ```
- [ ] **Promotional Text** (max 170 characters, can be updated anytime without review):
  ```
  Dream it. Plan it. Do it! Create your ultimate bucket list and share adventures with friends.
  ```
- [ ] **Support URL**: Create a simple webpage or use your GitHub repo URL
- [ ] **Marketing URL** (optional): Your website/landing page

## Phase 5: Screenshots & Preview
- [ ] **Screenshots** (REQUIRED - at least one set):
  - **iPhone 6.7" display** (iPhone 15 Pro Max): 1290 x 2796 pixels
  - **iPhone 6.5" display** (iPhone 14 Plus): 1284 x 2778 pixels
  - **iPad 12.9" display** (if supporting iPad): 2048 x 2732 pixels
  - You need 1-10 screenshots per device size
  - Recommended: 5-6 screenshots showing key features
  - Screenshot ideas:
    1. My Bucket List view with items
    2. Adding a new item with location search
    3. Item detail with map view
    4. Shared items from friends
    5. Completed items list
    6. Friends list view
  - Tools: Run on Simulator and take screenshots, or use a mockup tool like Rotato/AppMockUp
- [ ] **App Preview Video** (optional but recommended): 15-30 second video

## Phase 6: Legal & Privacy (REQUIRED)
- [ ] **Privacy Policy URL** (REQUIRED):
  - See `PRIVACY_POLICY.md` in this repo for a template
  - Host it on a website (GitHub Pages, Notion, or any free hosting)
  - Must be accessible via a public URL
- [ ] **Terms of Use URL** (recommended):
  - Can use a simple terms page or Apple's standard EULA
- [ ] **App Privacy Details** (REQUIRED - in App Store Connect):
  - Go to "App Privacy" section
  - Since this app stores data locally only (no backend/analytics), select:
    - Data Not Collected (if no analytics or third-party SDKs)
    - If you add analytics later, you'll need to declare data types collected
- [ ] **Age Rating**:
  - Fill out the questionnaire in App Store Connect
  - This app should be rated 4+ (no objectionable content)
- [ ] **Content Rights**: Confirm you own all content in the app
- [ ] **EULA**: Apple provides a standard one, or you can add a custom one

## Phase 7: Testing Before Submission
- [ ] **Test on real devices** (not just simulator):
  - Test on at least one iPhone
  - Test location search functionality
  - Test "Open in Google Maps" and "Open in Apple Maps"
  - Test adding, editing, completing, and deleting items
  - Test sharing functionality
  - Test with friends' shared items
- [ ] **Test on different iOS versions** if possible
- [ ] **Test on different screen sizes** (SE, standard, Plus/Max)
- [ ] **Run Xcode Analyzer**: Product > Analyze (fix any warnings)
- [ ] **Profile with Instruments**: Check for memory leaks and performance
- [ ] **Test Dark Mode**: Ensure the app looks good in both light and dark mode
- [ ] **Test with no data**: Ensure empty states display properly
- [ ] **Test offline behavior**: App should work offline (it uses local SwiftData)

## Phase 8: Build & Upload
- [ ] **Archive the app**:
  1. In Xcode: Select "Any iOS Device" as destination
  2. Product > Archive
  3. When archive completes, Organizer window opens
- [ ] **Upload to App Store Connect**:
  1. In Organizer, click "Distribute App"
  2. Choose "App Store Connect"
  3. Follow the prompts
  4. Wait for processing (usually 15-30 minutes)
- [ ] **Select Build in App Store Connect**:
  - Go to your app > iOS App section
  - Click "+" next to Build and select your uploaded build

## Phase 9: TestFlight (Recommended Before Public Release)
- [ ] **Internal Testing**:
  - Your build is auto-available for internal testers (up to 25)
  - Add yourself and any team members as internal testers
  - Test the full app flow via TestFlight
- [ ] **External Testing** (optional):
  - Requires a quick Beta App Review (usually 24 hours)
  - Can invite up to 10,000 external testers
  - Great for getting feedback from friends/family

## Phase 10: Submit for Review
- [ ] **Complete all App Store listing** fields
- [ ] **Select pricing**: Free (or set a price/subscription)
- [ ] **Set availability**: Select countries/regions
- [ ] **Add review notes** (for Apple reviewers):
  ```
  This is a bucket list app for tracking places to visit and goals to achieve.
  To test the sharing feature, tap the Friends tab and select "Load Sample Data"
  to populate sample friends and shared items.
  ```
- [ ] **Click "Submit for Review"**
- [ ] **Wait for review**: Typically 24-48 hours (can take up to a week)

## Phase 11: Post-Submission
- [ ] **Monitor review status** in App Store Connect
- [ ] **If rejected**: Read the rejection reason carefully, fix issues, resubmit
  - Common rejection reasons:
    - Crashes or bugs
    - Incomplete functionality
    - Privacy policy missing or inadequate
    - Misleading description
    - Guideline 4.2: Minimum functionality (app must provide enough value)
- [ ] **Once approved**: Choose to release immediately or on a specific date

## Phase 12: Post-Launch
- [ ] **Monitor Crash Reports**: App Store Connect > Analytics > Crashes
- [ ] **Respond to Reviews**: App Store Connect > Ratings and Reviews
- [ ] **Plan Updates**: Collect feedback and plan version 1.1
- [ ] **Consider adding**:
  - CloudKit sync for real sharing between devices
  - Push notifications for friend activity
  - Photos/media for completed items
  - Widgets for home screen
  - Apple Watch companion

## Quick Cost Summary
| Item | Cost |
|------|------|
| Apple Developer Account | $99/year |
| App Icon Design (DIY) | Free |
| App Icon Design (Fiverr) | $20-50 |
| Screenshot Mockups (DIY) | Free |
| Privacy Policy Hosting (GitHub Pages) | Free |
| **Total Minimum** | **$99** |

## Useful Resources
- Apple Developer Documentation: https://developer.apple.com/documentation/
- App Store Review Guidelines: https://developer.apple.com/app-store/review/guidelines/
- Human Interface Guidelines: https://developer.apple.com/design/human-interface-guidelines/
- App Store Connect Help: https://developer.apple.com/help/app-store-connect/
