//
//  ConsoleLogsCapturer.swift
//  ConcurrencyTasks
//
//  Created by A.J. van der Lee on 13/03/2025.
//

import SwiftUI
import Foundation

@Observable @MainActor
final class ConsoleLogsCapturer: ObservableObject, Sendable {
    var logs: [String] = []
    
    let inputPipe = Pipe()
    let outputPipe = Pipe()
    
    init() {
        captureConsoleOutput()
    }
    
    func clearLogs() {
        logs.removeAll()
    }

    private func captureConsoleOutput() {
        inputPipe.fileHandleForReading.readabilityHandler = { [weak self] fileHandle in
            guard let self else { return }

            let data = fileHandle.availableData
            if let logString = String(data: data, encoding: String.Encoding.utf8) {
                Task { @MainActor in
                    let newLogLines = logString.components(separatedBy: "\n").filter { !$0.isEmpty }
                    logs.append(contentsOf: newLogLines)
                }
            }

            // Write input back to stdout
            outputPipe.fileHandleForWriting.write(data)
        }
        
        openConsolePipe()
    }
    
    /// Capture print statements and send them forward to the original debugger.
    private func openConsolePipe() {
        dup2(FileHandle.standardOutput.fileDescriptor, outputPipe.fileHandleForWriting.fileDescriptor)
        dup2(inputPipe.fileHandleForWriting.fileDescriptor, FileHandle.standardOutput.fileDescriptor)
    }
}
