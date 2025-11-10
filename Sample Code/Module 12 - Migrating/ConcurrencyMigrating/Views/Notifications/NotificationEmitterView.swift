//
//  NotificationEmitterView.swift
//  ConcurrencyMigrating
//
//  Created by A.J. van der Lee on 10/11/2025.
//

import SwiftUI

struct NotificationEmitterView: View {
    
    @State var observer = NotificationsObserver()
    
    var body: some View {
        Form {
            Button("Send notification - Old way") {
                NotificationEmitter().emitOldWay()
            }
            
            Button("Send notification - New way") {
                NotificationEmitter().emitNewWay()
            }
            Button("Change clipboard for standard API notification testing") {
                UIPasteboard.general.string = UUID().uuidString
            }
        }.onAppear {
            observer.startObserving()
        }
    }
    
}
