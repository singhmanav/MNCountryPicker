//
//  MNCountryPicker.swift
//  MNCountryPicker
//
//  Created by Manav on 06/09/18.
//

import UIKit
public struct MNCountry {
    
    /// Name of the country
    public let name : String
    
    /// ISO country code of the country
    public let iso : String
    
    /// Emoji flag of the country
    public let emoji: String
    
}
public protocol MNCountryPickerDelegate : UIPickerViewDelegate {
    
    /**
     Returns the selected Country
     
     - parameter picker:  An object representing the MNCounrtyPicker requesting the data.
     - parameter country: The Selected MNCountry
     */
    func countryPicker(_ picker: MNCountryPicker, didSelectCountry country: MNCountry)
}

open class MNCountryPicker : UIPickerView {
    
    /// The current picked MNCountry
    open var pickedCountry : MNCountry?
    
    /// The delegate for the MNCountryPicker
    open var countryDelegate : MNCountryPickerDelegate?
    
    /// The Content of the MNCountryPicker
    internal var countryData = [MNCountry]()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.dataSource = self
        self.delegate = self
        loadData()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.dataSource = self
        self.delegate = self
        loadData()
    }
    
    /**
     Country Data generation
     */
    fileprivate func loadData() {
        
        for locale in NSLocale.isoCountryCodes{
            let iso = locale
            let name = NSLocale.current.localizedString(forRegionCode: locale)
            let emoji = flag(country: iso)
            let country = MNCountry(name: name!, iso: iso, emoji: emoji)
            
            // append country
            countryData.append(country)
        }
        
        countryData.sort { $1.name > $0.name }
        self.reloadAllComponents()
        
    }
}

func flag(country:String) -> String {
    let base : UInt32 = 127397
    var s = ""
    for v in country.unicodeScalars {
        s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
    }
    return String(s)
}

extension MNCountryPicker : UIPickerViewDataSource {
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(countryData[row].emoji.description) - \(countryData[row].name.description)"
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryData.count
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
}

extension MNCountryPicker : UIPickerViewDelegate {
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickedCountry = countryData[row]
        if let countryDelegate = self.countryDelegate {
            countryDelegate.countryPicker(self, didSelectCountry: countryData[row])
        }
    }
    
}
