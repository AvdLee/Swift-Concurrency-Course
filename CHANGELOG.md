## November 2025

### New module: Performance
- **A whole new module** with 4 lessons and an assessment, teaching you how to deal with performance in Swift Concurrency.

### Introduction
- **Updated a lesson:** [What is structured concurrency](https://courses.avanderlee.com/courses/swift-concurrency/lectures/59997222) had an invalid code example (the one with Result enum). (Thanks, M. La Gala!)

### Task Groups
- **Updated a lesson:** Added a small note regarding discarding task groups cancellation behavior on errors. (See [Issue #64](https://github.com/AvdLee/Swift-Concurrency-Course/issues/64)) (Thanks, Luc Olivier!)
- **Updated a lesson:** Task group timeout code example uses Swift 6.2 APIs. [Added a note for this](https://courses.avanderlee.com/courses/swift-concurrency/lectures/62438091). (Thanks, Luc Olivier!)

### Actors
- **Updated a lesson:** [Added a paragraph about Mutex being thread blocking](https://courses.avanderlee.com/courses/swift-concurrency/lectures/62306972) (Thanks, moreindirection!)

### Threading
- **Updated a lesson:** [How Threads relate to Tasks in Swift Concurrency](https://courses.avanderlee.com/courses/swift-concurrency/lectures/60100309) now mentions the use of a Thread.currentThread extension. (Thanks, Luc Olivier!)

### Migrating
- **Added a new video:** [Migration Tooling for upcoming Swift Features](https://courses.avanderlee.com/courses/swift-concurrency/lectures/62060933)
- **Added a new video:** [The Approachable Concurrency build setting (Updated for Swift 6.2)](https://courses.avanderlee.com/courses/swift-concurrency/lectures/62485046)
- **Added a new lesson:** [Migrating to concurrency-safe notifications](https://courses.avanderlee.com/courses/swift-concurrency/lectures/62485107)

### General
- Certificate completion page layout now looks normal on larger screens (Thanks, C. Lawther!)

## August 2025

### New Module: Core Data
- A whole new module containing 4 lessons dedicated to Core Data and Swift Concurrency, starting with [An introduction to Swift Concurrency and Core Data](https://courses.avanderlee.com/courses/swift-concurrency/lectures/62485126).

### Async/Await basics
- **Updated a lesson:**: Removed the redundant `try await` early in the lesson [Calling async functions in parallel using async let](https://courses.avanderlee.com/courses/swift-concurrency/lectures/59997414) to avoid confusion. (Thanks, C. Lawther!)

### Tasks
- **Added a new lesson:** [Creating a Task timeout handler using a Task Group](https://courses.avanderlee.com/courses/swift-concurrency/lectures/62438091)
- **Added a new lesson:** [Discarding Task Groups](https://courses.avanderlee.com/courses/swift-concurrency/lectures/62485188)
- **Updated a lesson:** The [Task Cancellation](https://courses.avanderlee.com/courses/swift-concurrency/lectures/59997234) lesson now explicitly explains the order of execution when using SwiftUI's task modifier. (Thanks, ginnheimerCoder!)

### Actors
- **Added a new lesson:** [Using a Mutex as an alternative to actors](https://courses.avanderlee.com/courses/swift-concurrency/lectures/62306972)
- **Added a new lesson:** [Adding isolated conformance to protocols](https://courses.avanderlee.com/courses/swift-concurrency/lectures/62485157)
- **Added a new lesson:** [Using Isolated synchronous deinit](https://courses.avanderlee.com/courses/swift-concurrency/lectures/62485150)
- Updated the sample project to have the console logger view as well.

### Threads
- **Updated a lesson:** Better explained nonisolated(nonsending) in lesson [Dispatching to different threads using nonisolated(nonsending) and @concurrent (Updated for Swift 6.2)](https://courses.avanderlee.com/courses/swift-concurrency/lectures/59997228)
- Updated sample code mention of upcoming feature to `NonisolatedNonsendingByDefault`.
- Removed duplicate answer in Question 9 of the assessment. (Thanks, C. Lawther!)

### Migrating
- **Added a new lesson:** [The Approachable Concurrency build setting](https://courses.avanderlee.com/courses/swift-concurrency/lectures/62485046)
- **Updated a lesson:** Added the Approachable Concurrency build setting as an additional migration step in ["Steps to migrate existing code to Swift 6 and Strict Concurrency Checking"](https://courses.avanderlee.com/courses/swift-concurrency/lectures/59997246)
- **Updated a lesson:** Mentioned AsyncExtensions open-source framework and a threading risk for Combine in lesson [Migrating away from Functional Reactive Programming like RxSwift or Combine](https://courses.avanderlee.com/courses/swift-concurrency/lectures/60010397)

### General improvements
- Made `currentThread` convenience method `nonisolated` to avoid compiler issues when using `@MainActor` default actor isolation. (Thanks, L. Olivier!)

## July 2025
### Tasks
- Updated `ConcurrencyTasks.xcodeproj` for Xcode 26
- Updated the Detached Tasks lesson section "Risks of using detached tasks" following issue [#6](https://github.com/AvdLee/Swift-Concurrency-Course/issues/6). (Thanks, L. Olivier!)
- Updated the Detached Tasks lesson section "What is a detached task?" following issue [#13](https://github.com/AvdLee/Swift-Concurrency-Course/issues/13). (Thanks, Sivasankar K!)
- Rewrote the section in lesson "An introduction to Global Actors" about using an enum towards using a private init instead following issues [#14](https://github.com/AvdLee/Swift-Concurrency-Course/issues/14) and [#23
](https://github.com/AvdLee/Swift-Concurrency-Course/issues/23). (Thanks, Z. Zeynalov, Melanie H!)
- Updated lesson "Sendable and Value Types" to explain the impact of `@frozen` and `@usableFromInline` on implicit `Sendable` following issues [#15](https://github.com/AvdLee/Swift-Concurrency-Course/issues/15). (Thanks, Melanie H!)
- Updated section "Handling errors by using a throwing variant" in lesson "Task Groups" to better explain how error propagation works. I've also added `TaskGroupsDemonstrator.errorPropagation()` to demonstrate this in the sample code. ([#16](https://github.com/AvdLee/Swift-Concurrency-Course/issues/16), thanks Z. Zeynalov!)
- Fixed several grammar mistakes throughout the lessons ([#22](https://github.com/AvdLee/Swift-Concurrency-Course/issues/22), thanks Z. Zeynalov!)
- Updated lesson "Sendable and Reference Types" to properly mention "parent" vs. "child class". ([#20](https://github.com/AvdLee/Swift-Concurrency-Course/issues/20), thanks Z. Zeynalov!)
- Updated lesson "Using AsyncStream and AsyncThrowingStream in your code" regarding subscribing to a terminated stream, which finishes the task immediately. ([#25](https://github.com/AvdLee/Swift-Concurrency-Course/issues/25), thanks Z. Zeynalov!)
- Updated lesson "Controlling the default isolation domain" for Xcode 26
- Updated lesson "Dispatching to different threads (Updated for Swift 6.2)" for Xcode 26

## June 2025
No new modules yet due to the approach of WWDC any many expected changes. Yet, existing lessons did receive quite a few updates!

### Async/await
- Assessment — Updated question five *Is the order of execution of the following three requests always the same?* to have clearer and more precise answers. (Thanks, O. Marchenko!)
- Async let - Clarified that async let tasks are not guaranteed to start in the order they’re declared, aligning explanation with Swift’s concurrency scheduling behavior. (Thanks, O. Marchenko!)
- Async let - Clarified tasks in an array are cancelled instead of failing when another task from the array throws. (Thanks, O. Marchenko!)


### Tasks
- Task Cancellation — Updated wording to clarify that child tasks are notified—not forcibly canceled—when their parent task is canceled, reflecting more accurate Swift Concurrency behavior.
- Task Groups - Added more details to better explain the concept, including `next()`, basics of `withTaskGroup`. (Thanks, M. La Gala!)
- Task.sleep vs yield — Rewrote a small section about `Task.yield()` to remove a statement regarding priority being a deciding factor. (Thanks, Zeynal7!)
- Task Priorities — Fixed a typo stating the default priority is userInitiated instead of medium. (Thanks, Zeynal7!)

### Actors
- Understanding actors in Swift Concurrency — Added a small section to mention Actors can inherit from NSObject. (Thanks, P. Muñoz Cabrera!)

### Sendable
- Sendable and Value Types — Rewrote the section about public structures and implicit sendability. (Thanks, Zeynal7!)

### Other changes
- Fixed several grammar mistakes (Thanks, J. Shulman!)

## May 2025
### 13 new lessons across 3 modules

- AsyncStream & AsyncSequence: Handling Asynchronous Data Streams
- Threading: How It All Connects
- Memory Management in Swift Concurrency: Avoiding Common Pitfalls


### Other changes
**Module 3**

- Updated sample code to print the current thread via a convenience method.
- Added a new threading demonstrator that works with an upcoming feature flag for demonstrating new threading behavior in Swift 6.2. Also, moved this threading demonstrator to the threading module sample code.

## April 2025
### 30 new lessons
Added 30 lessons covering:

- Tasks
- Sendable
- Actors

## March 2025

### Course changes
- Assessments can now be retried up to five times
- Assessments now show the correct answer so you know where you need to improve your knowledge

### Existing lesson changes
- Added a note about `async let` not requiring an `async` method
- Updated `synchronousMethod()` inside `ConcurrencyCourseIntroduction.xcodeproj` to make use of `async let` to properly demonstrate a parent-child relationship. Lesson content was already up to date.