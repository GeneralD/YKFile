# YKFile — Repo Notes for AI Sessions

- Legacy Objective-C iOS library (circa iOS 6 era) that wraps file paths as
  objects: `YKFile` exposes path properties (name, extension, depth, exists,
  isDirectory, ...) and filesystem ops (mkdir/rm/cp/mv, recursive listing,
  path cropping/comparison), Java-File-style.
- Distributed as a CocoaPod (`YKFile.podspec`, v0.0.2, `requires_arc`,
  platform iOS 6.0). License: WTFPL (`FILE_LICENSE`).
- Status: legacy/archived utility — no commits expected, predates Swift;
  do not modernize unless explicitly asked.
- Layout:
  - `Classes/ios/YKFile.{h,m}` — core class
  - `Classes/ios/YKFile+NSDirectories.{h,m}` — standard-directory helpers
  - `Classes/ios/NSMutableArray+YKFileArray.{h,m}` — `YKFileArray` category
- No Xcode project, tests, or CI in the repo; the podspec is the only
  manifest. There is no verifiable build command — consume via CocoaPods.
