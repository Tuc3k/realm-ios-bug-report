//
//  ViewController.swift
//  realmTest
//
//  Created by Leon Tuček on 29/04/2019.
//  Copyright © 2019 Leon Tuček. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UISearchBarDelegate {
    private let realm: Realm = try! Realm()
    private var elementsToFilter: Results<Parent>!
    
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        if realm.objects(Parent.self).count == 0 {
            // Save dummy object if there are none
            try! realm.write {
                for i in 0 ..< 1 {
                    let parentObject = Parent()
                    parentObject.id = String(i)
                    
                    var children = [Child]()
                    for _ in 0 ..< 100 {
                        let child = Child()
                        child.name = randomString(length: 2)
                        children.append(child)
                    }
                    
                    parentObject.children.append(objectsIn: children)
                    realm.add(parentObject)
                }
            }
        }
        
        // Load saved objects
        elementsToFilter = realm.objects(Parent.self)
        
        // Prints all elements that will be filtered
        for parentObject in elementsToFilter {
            let unfiltered = parentObject.children
            print("=== SAVED ELEMENTS ===")
            for obj in unfiltered {
                print("\t\t\(obj.name)")
            }
            print("======================")
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        for parentObject in elementsToFilter {
            var searchedElemets: LazyFilterSequence<List<Child>>!
            
            // Filteres saved children objects based on searchText
            searchedElemets = parentObject.children.filter({
                let predict = NSPredicate(format: "self CONTAINS[cd] %@", searchText)
                return predict.evaluate(with: $0.name)
            })
            
            // Compares values of searched LazyFilterSequence, object.name and searchedElemets[i].name should contain the same value
            print("=== START OF SEARCH ===")
            var i: Int = 0
            for object in searchedElemets {
                print("\t\(object.name) != \(searchedElemets[i].name)")
                i += 1
            }
            print("=== END OF SEARCH ===")
        }
        
    }
    
    // Helper function
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyz"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }


}

