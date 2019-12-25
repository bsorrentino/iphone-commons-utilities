//
//  Note.swift
//  KeyChainX
//
//  Created by Bartolomeo Sorrentino on 04/07/2019.
//  Copyright © 2019 Bartolomeo Sorrentino. All rights reserved.
//

import SwiftUI


struct MultilineTextView: UIViewRepresentable {
    @Binding var text: String

    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.isScrollEnabled = true
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.backgroundColor = .yellow
        
        NotificationCenter.default.addObserver(forName: UITextView.textDidChangeNotification,
                                               object: nil,
                                               queue: nil) { (notification) in
                                                
                                                guard view == notification.object as? UITextView else {
                                                    return
                                                }

                                                self.text = view.text
        }
        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
    
    func textDidChangeNotification(_ notif: Notification) {
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


struct KeyItemNote : View {
    @Environment(\.presentationMode) private var presentationMode
    
    @Binding var value:String
    
    var body: some View {
        //NavigationView {
                VStack {
                    GeometryReader { geometry in
                        MultilineTextView( text: self.$value )
                            .frame( width: geometry.size.width,
                                    height: geometry.size.height,
                                    alignment: .topLeading)
                    }
                    Button("OK") {
                        self.presentationMode.wrappedValue.dismiss()
                    }
            //}.navigationBarTitle( Text("Note"), displayMode: .inline  )
        }

    }
}

#if DEBUG
struct Note_Previews : PreviewProvider {
    static var previews: some View {
        KeyItemNote( value: .constant("TEST") )
    }
}
#endif
