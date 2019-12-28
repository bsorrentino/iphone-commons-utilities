//
//  RestoreKeysView.swift
//  KeyChainX
//
//  Created by softphone on 28/12/2019.
//  Copyright © 2019 Bartolomeo Sorrentino. All rights reserved.
//

import SwiftUI



struct RestoreKeysView: View {
    
    var body: some View {
        NavigationView {
            FileManagerView()
                .navigationBarTitle( Text("Backup"), displayMode: .large)
        }
        
    }
}

struct RestoreKeysView_Previews: PreviewProvider {
    static var previews: some View {
            RestoreKeysView()
    }
}
