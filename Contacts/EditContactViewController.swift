//
//  EditContactViewController.swift
//  Contacts
//
//  Created by Vamsi Krishna on 17/07/22.
//

import UIKit
import Firebase

class EditContactViewController: UIViewController {
    
    @IBOutlet var firstName: UITextField!
    @IBOutlet var lastName: UITextField!
    @IBOutlet var phoneNumber: UITextField!
    
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var doneButton: UIBarButtonItem!
    
    @IBOutlet var deleteButton: UIButton!
    
    var sharedContact: Contact = Contact(contactId: 0, firstName: "",lastName: "",phoneNumber: "");
    var ref: DatabaseReference = Database.database().reference(withPath: "contacts")

    override func viewWillAppear(_ animated: Bool) {
        firstName.text = sharedContact.firstName;
        lastName.text = sharedContact.lastName;
        phoneNumber.text = sharedContact.phoneNumber;
    }
    

    override func viewDidLoad() {
        super.viewDidLoad();
        deleteButton.tintColor = UIColor.red;
    }
    
    @IBAction func cancelButtonClickListener(_ sender: UIBarButtonItem) {
        showActionSheet(message: "Are you sure you want to discard your changes", destructiveTitle: "Discard Changes", cancelTitle: "Keep Editing", destructiveAction: discardChanges);
    }
    
    func discardChanges() -> Void {
        self.navigationController?.popViewController(animated: true);
    }
    
    @IBAction func doneButtonCLickListener(_ sender: UIBarButtonItem) {
        sharedContact.firstName = firstName.text!;
        sharedContact.lastName = lastName.text!;
        sharedContact.phoneNumber = phoneNumber.text!;
        
        
        let contactDictionary: [String: String] = ["id": String(sharedContact.contactId),
                                 "firstName": sharedContact.firstName,
                                 "lastName":sharedContact.lastName,
                                 "phoneNumber":sharedContact.phoneNumber]
        let contactRef = self.ref.child(String(sharedContact.contactId))
        contactRef.setValue(contactDictionary)
        
        self.navigationController?.popViewController(animated: true);

    }
    
    
    @IBAction func onDeleteContact(_ sender: UIButton) {
        showActionSheet(message: "",destructiveTitle: "Delete Contact", cancelTitle: "Cancel", destructiveAction: deleteContact);
    }
    
    func deleteContact() -> Void {
        let contactRef = self.ref.child(String(sharedContact.contactId));
        contactRef.removeValue()
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);
    }
    
    func showActionSheet(message: String, destructiveTitle: String, cancelTitle: String, destructiveAction:@escaping () -> Void) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: destructiveTitle, style: .destructive , handler:{ (UIAlertAction)in
            destructiveAction();
        }))
        
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel , handler:{_ in }))

        self.present(alert, animated: true, completion: {})
    }

}
