//
//  SettingsViewController.swift
//  appStudy
//
//  Created by Clement  Wekesa on 06/11/2020.
//

import UIKit

@available(iOS 10.0, *)
class SettingsViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    var places: [Places]?
    let units = ["standard", "metric", "imperial"]

    @IBOutlet weak var picker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func reset(_ sender: Any) {

        do {
            places = try context.fetch(Places.fetchRequest())
            for place in places! {
                context.delete(place)
            }
            try context.save()
        } catch {
            // There was an error
        }

    }
}

@available(iOS 10.0, *)
extension SettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return units.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return units[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        defaults.setValue(units[row], forKey: "selectedUnit")
    }
}
