//
//  MNCountryPicker.swift
//  MNCountryPicker
//
//  Created by Manav on 06/09/18.
//

import UIKit

/// Data Model For MNCountry
public struct MNCountry {
    
    /// Name of the country
    public let name : String
    
    /// ISO country code of the country
    public let iso : String
    
    /// Flag of the country
    public let flag: String
    
    /// Currency symbol of the country
    public let currency:String
    
}

/// MARK: - MNCountryPickerDelegate
public protocol MNCountryPickerDelegate : UIPickerViewDelegate {
    
    /**
     Returns the selected Country
     
     - parameter picker:  An object representing the MNCounrtyPicker requesting the data.
     - parameter country: The Selected MNCountry
     */
    func countryPicker(_ picker: MNCountryPicker, didSelectCountry country: MNCountry)
}

/// MNCountryPickerType
///
/// - name: picker with country name
/// - flag: picker with flag
/// - nameAndFlag: picker with name and flag
/// - nameAndCurrency: picker with name and currency
/// - all: picker with all
public enum MNCountryPickerType {
    case name
    case flag
    case nameAndFlag
    case nameAndCurrency
    case all
}

/// MARK: - MNCountryPicker
open class MNCountryPicker : UIPickerView {
    
    /// The current picked MNCountry
    public var pickedCountry : MNCountry?
    
    /// The delegate for the MNCountryPicker
    public weak var mnCountryDelegate : MNCountryPickerDelegate?
    
    /// The type of the MNCountryPicker
    /// default is name
    public var pickerType : MNCountryPickerType = .name
    
    /// The Datasource of the MNCountryPicker
    internal var mnCountryData = [MNCountry]()
    
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
    
    
    fileprivate func loadData() {
        mnCountryData = Locale.isoRegionCodes.map({
            let locale = Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.countryCode.rawValue: $0]))
            let name = Locale.current.localizedString(forRegionCode: $0) ?? ""
            return MNCountry(name: name, iso: $0, flag: flag(country: $0),currency: locale.currencySymbol ?? "")
        })
        mnCountryData.sort { $1.name > $0.name }
        self.reloadAllComponents()
        
    }
}


/// return flag for country code
///
/// - Parameter country: iso country code
/// - Returns: flag emoji for the country iso code
func flag(country:String) -> String {
    let base : UInt32 = 127397
    var s = ""
    for v in country.unicodeScalars {
        s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
    }
    return String(s)
}


// MARK: - MNCountryPicker : UIPickerViewDataSource
extension MNCountryPicker : UIPickerViewDataSource {
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title = ""
        switch self.pickerType{
        case .name:
            title = "\(mnCountryData[row].name.description)"
        case .flag:
            title = "\(mnCountryData[row].flag.description)"
        case .nameAndFlag:
            title = "\(mnCountryData[row].flag.description) - \(mnCountryData[row].name.description)"
        case .nameAndCurrency:
            title = "\(mnCountryData[row].name.description) - \(mnCountryData[row].currency.description)"
        case .all:
            title = "\(mnCountryData[row].flag.description) - \(mnCountryData[row].name.description) - \(mnCountryData[row].currency.description)"
        }
        return title
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mnCountryData.count
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
}


// MARK: - MNCountryPicker : UIPickerViewDelegate
extension MNCountryPicker : UIPickerViewDelegate {
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickedCountry = mnCountryData[row]
        if let mnCountryDelegate = self.mnCountryDelegate {
            mnCountryDelegate.countryPicker(self, didSelectCountry: mnCountryData[row])
        }
    }
    
}
