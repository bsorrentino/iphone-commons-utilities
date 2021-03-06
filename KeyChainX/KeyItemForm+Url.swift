//
//  KeyItemForm+Url.swift
//  KeyChainX
//
//  Created by softphone on 03/01/2020.
//  Copyright © 2020 Bartolomeo Sorrentino. All rights reserved.
//

import SwiftUI
import FieldValidatorLibrary
import WebKit
  
struct  UrlField : View {
    
    @Binding var value:String

    var body: some View {
        NavigationLink( destination: UrlView( value: $value) ) {
            HStack {
                Image( systemName: "link.circle").resizable().frame(width: 20, height: 20, alignment: .leading)
                if( value.isEmpty ) {
                    Text( "tap to choose url" )
                        .foregroundColor(.gray)
                        .italic()
                }
                else {
                    Text(value )
                }
            }
            .padding(EdgeInsets( top: 20, leading: 0, bottom: 20, trailing: 0))
        }
    }
    
}


let __urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
let __urlPredicate = NSPredicate(format: "SELF MATCHES %@", __urlRegEx)

extension String {
    func isUrl() -> Bool {
        return __urlPredicate.evaluate(with: self)
    }
}

struct UrlView: View {

    @Environment(\.presentationMode) var presentationMode

    @Binding var value:String
    
    @State var urlValid = FieldChecker()
    @State var urlReload = false
    
    var body: some View {

        VStack( spacing: 10.0 ) {
            
            TextFieldWithValidator( title: "insert url",
                                    value: $value,
                                    checker:$urlValid,
                                    onCommit: openUrl ) { v in
                   
                    if( v.isEmpty ) {
                       return "url cannot be empty !"
                    }
                    if( !v.isUrl() ) {
                        return "url is not in correct format !"
                    }
                   
                   return nil
            }
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .font(.body)
            
            WebView( url: URL( string: value), reload:$urlReload )
            
        }
        .padding()
        .navigationBarTitle( Text("url"), displayMode: .inline )
        .navigationBarItems(trailing: saveButton() )

    }
    
    private func saveButton() -> some View  {

        Button( action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text( "Save" )
        }.disabled( !urlValid.valid )

    }
    
    private func openUrl() {        
        urlReload = urlValid.valid
    }
}

#if DEBUG
struct KeyItemForm_Url_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UrlView( value: .constant( "https://www.google.com"))
        }
    }
}
#endif
