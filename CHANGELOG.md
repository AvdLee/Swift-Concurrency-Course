## July 2025
### Tasks
- Updated `ConcurrencyTasks.xcodeproj` for Xcode 26
- Updated the Detached Tasks lesson section "Risks of using detached tasks" following issue [#6](https://github.com/AvdLee/Swift-Concurrency-Course/issues/6). (Thanks, L. Olivier!)
- Updated the Detached Tasks lesson section "What is a detached task?" following issue [#13](https://github.com/AvdLee/Swift-Concurrency-Course/issues/13). (Thanks, Sivasankar K!)
- Rewrote the section in lesson "An introduction to Global Actors" about using an enum towards using a private init instead following issues [#14](https://github.com/AvdLee/Swift-Concurrency-Course/issues/14) and [#23
](https://github.com/AvdLee/Swift-Concurrency-Course/issues/23). (Thanks, Z. Zeynalov, Melanie H!)
- Updated lesson "Sendable and Value Types" to explain the impact of `@frozen` and `@usableFromInline` on implicit `Sendable` following issues [#15](https://github.com/AvdLee/Swift-Concurrency-Course/issues/15). (Thanks, Melanie H!)
- Updated section "Handling errors by using a throwing variant" in lesson "Task Groups" to better explain how error propegation works. I've also added `TaskGroupsDemonstrator.errorPropegation()` to demonstrate this in the sample code. ([#16](https://github.com/AvdLee/Swift-Concurrency-Course/issues/16), thanks Z. Zeynalov!)

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