//
//  ImmediateTaskDemonstrator.swift
//  ConcurrencyTasks
//
//  Created by A.J. van der Lee on 27/04/2026.
//

struct ImmediateTaskDemonstrator {
    static func demonstrate() {
        compareRegularTaskAndImmediateTask()
        demonstrateFirstSuspension()
        demonstrateMainActorOrdering()
        cleanupTemporaryFiles()
        demonstrateImmediateChildTasks()
    }

    private static func compareRegularTaskAndImmediateTask() {
        printSection("1. Regular Task vs Task.immediate")

        Task {
            print("Regular Task body: scheduled to run later")
        }
        print("After creating regular Task")

        Task.immediate {
            print("Immediate Task body: ran before the caller continued")
        }
        print("After creating immediate Task")
    }

    private static func demonstrateFirstSuspension() {
        printSection("2. Running until the first suspension")

        Task.immediate {
            print("Immediate task: started synchronously")
            await asyncMethodThatDoesNotSuspend()
            print("Immediate task: still running before the caller continues")

            await asyncMethodThatSuspends()
            print("Immediate task: resumed after the suspension")
        }

        print("Caller: continued after the first actual suspension")
    }

    private static func demonstrateMainActorOrdering() {
        printSection("3. MainActor ordering")

        Task.immediate { @MainActor in
            selectedPhotoID = nil

            Task { @MainActor in
                selectedPhotoID = 1
                print("Regular Task: selectedPhotoID = \(selectedPhotoDescription)")
            }
            print("After regular Task: selectedPhotoID = \(selectedPhotoDescription)")

            Task.immediate { @MainActor in
                selectedPhotoID = 2
                print("Immediate Task: selectedPhotoID = \(selectedPhotoDescription)")
            }
            print("After Task.immediate: selectedPhotoID = \(selectedPhotoDescription)")
        }
    }

    private static func cleanupTemporaryFiles() {
        printSection("4. Immediate detached task")

        Task.immediateDetached(priority: .background) {
            await TemporaryFileCleaner.cleanup()
        }
        print("Caller: cleanup was started, but it might still be running")
    }

    private static func demonstrateImmediateChildTasks() {
        printSection("5. Immediate child tasks")

        Task.immediate {
            await withTaskGroup(of: Void.self) { group in
                for item in 1...3 {
                    print("Adding immediate child task \(item)")
                    group.addImmediateTask {
                        print("Child \(item): synchronous part ran before adding the next task")
                        await suspendChildTask(item)
                        print("Child \(item): resumed after suspension")
                    }
                }
            }

            print("Immediate child tasks completed")
        }

        print("Caller: task group demonstration was started")
    }

    private static func asyncMethodThatDoesNotSuspend() async {
        print("Async method without suspension: returned immediately")
    }

    private static func asyncMethodThatSuspends() async {
        print("Async method with suspension: about to sleep")
        try? await Task.sleep(for: .milliseconds(200))
        print("Async method with suspension: finished sleeping")
    }

    private static func suspendChildTask(_ item: Int) async {
        try? await Task.sleep(for: .milliseconds(100 * item))
    }

    private static func printSection(_ title: String) {
        print("")
        print("=== \(title) ===")
    }

    @MainActor
    private static var selectedPhotoID: Int?

    @MainActor
    private static var selectedPhotoDescription: String {
        selectedPhotoID.map(String.init) ?? "nil"
    }
}

private struct TemporaryFileCleaner {

    @concurrent
    static func cleanup() async {
        try? await Task.sleep(for: .milliseconds(150))
        print("Detached cleanup: files cleaned")
    }
}
