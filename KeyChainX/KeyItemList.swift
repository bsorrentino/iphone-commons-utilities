//
//  ContentView.swift
//  KeyChainX
//
//  Created by Bartolomeo Sorrentino on 06/06/2019.
//  Copyright © 2019 Bartolomeo Sorrentino. All rights reserved.
//

import SwiftUI

typealias ViewProvider = (( KeyItem ) -> UIView );


struct ContentView : View {

    var body: some View {
        NavigationView {
            TopView()
                .navigationBarTitle( Text("Key List") )
        }

    }
}

struct TopView : View {
    
    @EnvironmentObject var keys:ApplicationKeys;

    var body: some View {
        KeyItemList( keys:keys)
            .navigationBarItems(trailing:
            HStack {
                NavigationLink( destination: KeyItemForm( item: KeyItem.newItem() ), label: {
                    Image( systemName: "plus" )
                })
        })
    }
    
    
}


#if DEBUG

import KeychainAccess

struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
        .environmentObject( ApplicationKeys(items:[
            KeyItem( id:"item1", username:"user1", password:Keychain.generatePassword()),
            KeyItem( id:"item2", username:"user2", password:Keychain.generatePassword()),
            KeyItem( id:"item3", username:"user3", password:Keychain.generatePassword()),
        ]) )
        
    }
}
#endif
