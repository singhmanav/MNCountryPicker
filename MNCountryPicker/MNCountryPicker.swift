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
    
    /// flag flag of the country
    public let flag: String
    
    /// Currency symbol of the country
    public let currency:String
    
}
public protocol MNCountryPickerDelegate : UIPickerViewDelegate {
    
    /**
     Returns the selected Country
     
     - parameter picker:  An object representing the MNCounrtyPicker requesting the data.
     - parameter country: The Selected MNCountry
     */
    func countryPicker(_ picker: MNCountryPicker, didSelectCountry country: MNCountry)
}

public enum MNCountryPickerType {
    case name
    case flag
    case nameAndFlag
    case nameAndCurrency
    case all
}

open class MNCountryPicker : UIPickerView {
    
    /// The current picked MNCountry
    public var pickedCountry : MNCountry?
    
    /// The delegate for the MNCountryPicker
    public var countryDelegate : MNCountryPickerDelegate?
    
    /// The type of the MNCountryPicker
    /// default is name
    public var pickerType : MNCountryPickerType = .name
    
    /// The Datasource of the MNCountryPicker
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
        countryData = Locale.isoRegionCodes.map({
            let locale = Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.countryCode.rawValue: $0]))
            let name = Locale.current.localizedString(forRegionCode: $0) ?? ""
            return MNCountry(name: name, iso: $0, flag: flag(country: $0),currency: locale.currencySymbol ?? "")
        })
        //        for localeIdentifier in Locale.isoRegionCodes{
        //            let locale = Locale(identifier: localeIdentifier)
        //            let iso = locale.regionCode ?? ""
        //            let name = Locale.current.localizedString(forRegionCode: iso) ?? ""
        //            let flag = flag(country: iso)
        //            let currency = locale.currencySymbol ?? ""
        //            let country = MNCountry(name: name, iso: iso, flag: flag,currency: currency)
        //
        //            // append country
        //            countryData.append(country)
        //        }
        
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
        var title = ""
        switch self.pickerType{
        case .name:
            title = "\(countryData[row].name.description)"
        case .flag:
            title = "\(countryData[row].flag.description)"
        case .nameAndFlag:
            title = "\(countryData[row].flag.description) - \(countryData[row].name.description)"
        case .nameAndCurrency:
            title = "\(countryData[row].name.description) - \(countryData[row].currency.description)"
        case .all:
            title = "\(countryData[row].flag.description) - \(countryData[row].name.description) - \(countryData[row].currency.description)"
        }
        return title
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
