//
//  RetainDemonstrator.swift
//  MemoryManagementConcurrency
//
//  Created by A.J. van der Lee on 25/04/2025.
//

@MainActor
struct RetainDemonstrator {
    
    func demonstrateStrongSelf() {
        var viewModel: ContentViewModel? = .init()
        viewModel?.fetchDataStrongSelf()
        viewModel = nil
        print("Set viewModel to nil")
        
        /// Prints:
        /// Set viewModel to nil
        /// Perform network request
        /// Finished network request
        /// Update UI!
        /// DEINIT!
    }
    
    func demonstrateWeakSelf() {
        Task {
            var viewModel: ContentViewModel? = .init()
            viewModel?.fetchDataWeakSelf()
            try? await Task.sleep(for: .milliseconds(500)) // To ensure the fetch task starts.
            viewModel = nil
            print("Set viewModel to nil")
            
            /// Prints:
            /// Perform network request
            /// Set viewModel to nil
            /// Finished network request
            /// DEINIT!
        }
    }
}

@MainActor
final class ContentViewModel {
    
    deinit {
        print("DEINIT!")
    }
    
    func fetchDataStrongSelf() {
        Task {
            await performNetworkRequest()
            updateUI() // ⚠️ Captures self strongly!
        }
    }
    
    func fetchDataWeakSelf() {
        Task { [weak self] in
            await self?.performNetworkRequest()
            self?.updateUI() // ⚠️ Captures self strongly!
        }
    }
    
    func updateUI() {
        print("Update UI!")
    }
    
    func performNetworkRequest() async {
        print("Perform network request")
        /// Simulate a network request of 1 second.
        try? await Task.sleep(for: .seconds(1))
        print("Finished network request")
    }
}
