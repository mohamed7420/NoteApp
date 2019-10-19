//
//  ViewController.swift
//  EngksNote
//
//  Created by Mohamed on 10/18/19.
//  Copyright © 2019 Mohamed74. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class ViewController: UIViewController  , UITableViewDelegate , UITableViewDataSource{
   
    @IBOutlet weak var tableView: UITableView!
    
    var notes: Results<Note>?
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.delegate = self
        tableView.dataSource = self
        
        loadData()
       // print(realm.configuration.fileURL)
        
    }

    @IBAction func btn_addNote(_ sender: UIBarButtonItem) {
        
        addNotes()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return notes?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellItem", for: indexPath) as! TableViewCell 
        cell.delegate = self
        cell.textLabel?.numberOfLines = 0
        
        cell.nameLabel.text = notes?[indexPath.row].noteText ?? "none"
        cell.emailLabel.text = notes?[indexPath.row].email ?? "none"
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController{
    
    
    func addNotes(){
        
        var emailField = UITextField()
        
        let alert = UIAlertController(title: "New Note", message: "add your new note", preferredStyle: .alert)
        
        alert.addTextField { (NoteField) in
            
            NoteField.placeholder = "enter you note text"
            
        }
        
        alert.addTextField { (EmailNote) in
            
            emailField = EmailNote
            
            EmailNote.placeholder = "enter you email"
        }
        
        let action = UIAlertAction(title: "Save", style: .default) { (addNote) in
            
            let note = Note()

            note.noteText = (alert.textFields?.first!.text)!

            note.email = emailField.text!

            do{
                
                try self.realm.write {
                     self.realm.add(note)
                }
                
            } catch {
                
                print("error \(error.localizedDescription)")
            }

          
            self.tableView.reloadData()

        }

        alert.addAction(action)

        present(alert, animated: true, completion: nil)

    }
    
    
    func loadData(){
        
        notes = realm.objects(Note.self)
        tableView.reloadData()
    }
    
  
}

extension ViewController : SwipeTableViewCellDelegate{
    
    
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
      guard orientation == .right else { return nil }

      let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
         
        if (self.notes?[indexPath.row]) != nil {
            
            do{
                
                try self.realm.write {
                    
                    self.realm.delete(self.notes![indexPath.row])
                }
                
            }catch{
                
                print("error while removing \(error)")
            }
            
            tableView.reloadData()
            
        }
        
    }

      deleteAction.image = UIImage(named: "delete")

      return [deleteAction]
  }
    

//    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
//        var options = SwipeOptions()
//        options.expansionStyle = .destructive
//        options.transitionStyle = .border
//        return options
//    }
    
}
