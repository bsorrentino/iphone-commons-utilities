//
//  ContentView.swift
//  KeyChainX
//
//  Created by Bartolomeo Sorrentino on 06/06/2019.
//  Copyright © 2019 Bartolomeo Sorrentino. All rights reserved.
//

import SwiftUI

typealias ViewProvider = (( KeyItem ) -> UIView );

class KeyItemListViewController : UITableViewController {
    
    
    var items:[KeyItem] = []

    var cellView:ViewProvider?

    override func viewDidLoad() {
        tableView.register(UINib(nibName: "KeyItemCell", bundle: nil), forCellReuseIdentifier: "keyitem")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "keyitem", for: indexPath)
        
        let item = items[indexPath.row]
        if let viewProvider = self.cellView {
            cell.contentView.addSubview(viewProvider(item))
        }

        cell.textLabel?.text = item.id.uppercased()
        cell.detailTextLabel?.text = item.grouped ? item.groupPrefix ?? "" : item.username
        
        return cell
    
    }
    
    //
    // MARK: SWIPE ACTIONS
    //
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let copy = UIContextualAction( style: .normal, title: "Copy" ) { action, view, completionHandler in
            
            completionHandler(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [ copy ])
        
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let configuration = UISwipeActionsConfiguration(actions: [])
        
        return configuration
    }

    
}

struct KeyItemList: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = KeyItemListViewController
    
    var controller:KeyItemListViewController
    
    public init( _ items:[KeyItem]/*, cellView:@escaping ViewProvider*/ ) {
        
        self.controller = KeyItemListViewController()
        
        self.controller.items = items
        //self.controller.cellView = cellView
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<KeyItemList>) -> UIViewControllerType {
        
        print( "makeUIViewController" )
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: UIViewControllerRepresentableContext<KeyItemList>) {
        //
        print( "updateUIViewController" )
        self.controller.tableView.reloadData()
    }
}

struct ContentView : View {
    
    var items:[KeyItem]
    /*
    var body: some View {
            List(items) { item in
                KeyItemRow(item:item)
                
            }
    }
    */
    var body: some View {
        KeyItemList(items)
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView(items: [
            KeyItem( id:"item1", username:"user1", note:""),
            KeyItem( id:"item2", username:"user2", note:""),
            KeyItem( id:"item3", username:"user3", note:""),
        ])
    }
}
#endif
