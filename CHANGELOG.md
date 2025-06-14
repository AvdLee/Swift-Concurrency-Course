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