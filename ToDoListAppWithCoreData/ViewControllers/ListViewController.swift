//
//  ListViewController.swift
//  ToDoListAppWithCoreData
//
//  Created by Mac on 07.05.2021.
//

import UIKit

class ListViewController: UITableViewController {
    
    private var contacts: [Contact]?
    
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchList()
    }
    
    private func fetchList() {
        do {
            self.contacts = try context.fetch(Contact.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print(Error.self)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let person = contacts?[indexPath.row].name
        cell.textLabel?.text = person
        return cell
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        showAlert()
    }
    
    private func showAlert() {
        let ac = UIAlertController(title: "Введите имя", message: "Введите имя", preferredStyle: .alert)
        ac.addTextField(configurationHandler: nil)
        
        let ok = UIAlertAction(title: "Ok", style: .default) { _ in
            guard let text = ac.textFields?.first?.text else { return }
            let newPerson = Contact(context: self.context)
            newPerson.name = text
            do {
                try self.context.save()
            } catch {
                print(error)
            }
            self.fetchList()
        }
        ac.addAction(ok)
        present(ac, animated: true, completion: nil)
    }
    

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let personToRemove = self.contacts?[indexPath.row] else { return }
            self.context.delete(personToRemove)
            do {
                try self.context.save()
            } catch {
                print(error)
            }
            self.fetchList()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
