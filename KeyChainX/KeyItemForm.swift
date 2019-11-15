//
//  KeyItemDetail.swift
//  KeyChainX
//
//  Created by Bartolomeo Sorrentino on 16/06/2019.
//  Copyright © 2019 Bartolomeo Sorrentino. All rights reserved.
//

import SwiftUI
import Combine
import FieldValidatorLibrary

enum SecretInfo: Int, Hashable {
    
    case hide
    case show
}


struct PasswordToggleField : View {
    typealias Validator = (String) -> String?
    
    @Binding var secretInfo:SecretInfo
    
    @ObservedObject var field:FieldValidator<String>
    
    init( value:Binding<String>, checker:Binding<FieldChecker>, secretInfo:Binding<SecretInfo>, validator:@escaping Validator ) {
        self.field = FieldValidator(value, checker:checker, validator:validator )
        self._secretInfo = secretInfo
    }

    var body: some View {
        
        VStack {
            Group {
                if( secretInfo == .hide ) {
                    SecureField( "password", text:$field.value)
                }
                else {
                    TextField( "password", text:$field.value)
                }
            }
        }
        .onAppear {
            self.field.doValidate()
        }

    }
}

extension SecretInfo {
    
    var text:String {
        switch( self ) {
        case .hide: return "***"
        case .show: return "abc"
        }
    }
}

struct EmailField : View {
    
    @Binding var value:String

    var body: some View {
        NavigationLink( destination: EmailList( value: $value) ) {
            HStack {
                Image( systemName: "envelope.circle")
                if( value.isEmpty ) {
                    Text( "tap to choose email" )
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

struct NoteField : View {
    
    @Binding var value:String

    func message() -> some View {
        if( self.value.isEmpty ) {
            return Text( "tap to insert note" )
                .foregroundColor(.gray)
                .italic()
        }
        else {
            return Text(self.value)
                
        }

    }
    
    var body: some View {
        
        NavigationLink( destination: KeyItemNote( value: $value) ) {
            
            HStack(alignment: .center) {
                Image( systemName: "doc.circle")
                GeometryReader { geometry in
                    self.message()
                    .frame(width: geometry.size.width ,
                           height: geometry.size.height,
                           alignment: .leading)
                }
            }
            .padding(EdgeInsets( top: 20, leading: 0, bottom: 20, trailing: 0))
        }
    }

    
}



struct KeyEntityForm : View {
    @Environment(\.presentationMode) var presentationMode
    
    @Environment(\.managedObjectContext) var managedObjectContext

    @ObservedObject var item:KeyItem
    
    @State var secretInfo:SecretInfo = .hide
    
    private let bg = Color(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, opacity: 0.2)
                    //Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
    
    init() {
        self.item = KeyItem()
    }

    init( entity:KeyEntity ) {
        self.item = KeyItem( entity:entity )
    }

    func mnemonicInput() -> some View  {
        
        VStack(alignment: .leading) {
            HStack {
                Text("mnemonic")
                if( !item.mnemonicCheck.valid  ) {
                    Spacer()
                    Text( item.mnemonicCheck.errorMessage ?? "" )
                        .fontWeight(.light)
                        .font(.footnote)
                        .foregroundColor(Color.red)

                }

            }
            
            TextFieldWithValidator( value: $item.mnemonic, checker:$item.mnemonicCheck ) { v in
                
                if( v.isEmpty ) {
                    return "mnemonic cannot be empty"
                }
                
                return nil
            }
            .padding(.all)
            .border( item.mnemonicCheck.valid ? Color.clear : Color.red , width: 0.5)
            .background( bg )
            .autocapitalization(.allCharacters)
    
        }
            

    }
    
    func userInput() -> some View {
        
        VStack(alignment: .leading) {
            HStack {
                Text("username")
                if( !item.usernameCheck.valid  ) {
                    Spacer()
                    Text( item.usernameCheck.errorMessage ?? "" )
                        .fontWeight(.light)
                        .font(.footnote)
                        .foregroundColor(Color.red)

                }

            }
            
            TextFieldWithValidator( value: $item.username, checker:$item.usernameCheck ) { v in
                
                if( v.isEmpty ) {
                    return "username cannot be empty"
                }
                
                return nil
            }
            .padding(.all)
            .border( item.usernameCheck.valid ? Color.clear : Color.red , width: 0.5)
            .background(bg)
            .autocapitalization(.none)
            
        }


    }

    func passwordInput() -> some View {
        
        VStack(alignment: .leading) {
            HStack {
                Text("Password")
                if( !item.passwordCheck.valid  ) {
                    Spacer()
                    Text( item.passwordCheck.errorMessage ?? "" )
                        .fontWeight(.light)
                        .font(.footnote)
                        .foregroundColor(Color.red)

                }

            }
            
            PasswordToggleField( value:$item.password, checker:$item.passwordCheck, secretInfo:$secretInfo ) { v in
                    if( v.isEmpty ) {
                        return "password cannot be empty"
                    }
                    return nil
            }
            .padding(.all)
            .border( item.passwordCheck.valid ? Color.clear : Color.red , width: 0.5)
            .background(bg)
            .autocapitalization(.none)
            

        }

    }

    
    var body: some View {
        NavigationView {
            Form {
                

                if( item.isNew ) {
                    Section {
                        
                        mnemonicInput()
                        
                    }

                }

                Section {
                    
                    userInput()
                    
                    passwordInput()
                                        
                }
                
                Section {
                    
                    EmailField( value:$item.mail )
                    
                    NoteField( value:$item.note)
                    
                }
            }
            .navigationBarTitle( Text( item.mnemonic.uppercased()), displayMode: .inline  )
            .navigationBarItems(trailing:
                HStack {
                    Picker( selection: $secretInfo, label: EmptyView() ) {
                        Image( systemName: "eye.slash").tag(SecretInfo.hide)
                        //Text(SecretInfo.hide.text).tag(SecretInfo.hide)
                        Image( systemName: "eye").tag(SecretInfo.show)
                        //Text(SecretInfo.show.text).tag(SecretInfo.show)
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    Spacer(minLength: 15)
                    
                    Button( "save", action: {
                        print( "Save\n mnemonic: \(self.item.mnemonic)\n username: \(self.item.username)" )
                        
                        do {
                            try self.item.save( context: self.managedObjectContext )
                        }
                        catch {
                            if( self.item.isNew ) {
                                print( "error inserting new key \(error)" )
                            }
                            else {
                                print( "error updating new key \(error)" )
                            }
                        }
                        
                        self.presentationMode.wrappedValue.dismiss()
                        
                    })
                        .disabled( !item.checkIsValid )
                    
                }
            )
        } // NavigationView
        
    }
}

#if DEBUG
import KeychainAccess

struct KeyItemDetail_Previews : PreviewProvider {
    static var previews: some View {
        
        KeyEntityForm()
        
        
    }
}
#endif
    
