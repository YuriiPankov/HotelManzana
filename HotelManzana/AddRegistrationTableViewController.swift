//
//  AddRegistrationTableViewController.swift
//  HotelManzana
//
//  Created by Yurii Pankov on 27.07.2021.
//

import UIKit

class AddRegistrationTableViewController: UITableViewController, SelectRoomTypeTableViewControllerDelegate {
    
    var registrationData: Registration?
    
    init?(coder: NSCoder, registrationData: Registration?) {
        self.registrationData = registrationData
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.registrationData = nil
    }
    
    
    func selectRoomTypeTableViewController(_ controller: SelectRoomTypeTableViewController, didSelect roomType: RoomType) {
        self.roomType = roomType
        updateRoomType()
    }
    
    
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
    
    var roomType: RoomType?
    
    let checkInDatePickerCellIndexPath = IndexPath(row: 1, section: 1)
//    Differs from sample code, because of 3 sections instead of 2 as in sample.
    let checkOutDatePickerCellIndexPath = IndexPath(row: 1, section: 2)
    
    let checkInDateLabelCellIndexPath = IndexPath(row: 0, section: 1)
    let checkOutDateLabelCellIndexPath = IndexPath(row: 0, section: 2)
    
    var isCheckInDatePickerVisible: Bool = false {
        didSet {
            checkInDatePicker.isHidden = !isCheckInDatePickerVisible
        }
    }
    
    var isCheckOutDatePickerVisible: Bool = false {
        didSet {
            checkOutDatePicker.isHidden = !isCheckOutDatePickerVisible
        }
    }
    
    var registration: Registration? {
        
        guard let roomType = roomType else {
            return nil
        }
        
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        let numberOfAdults = Int(numberOfAdultsStepper.value)
        let numberOfChildren = Int(numberOfChildrenStepper.value)
        let hasWifi = wifiSwitch.isOn
        
        return Registration(firstName: firstName, lastName: lastName, emailAddress: email, checkInDate: checkInDate, checkOutDate: checkOutDate, numberOfAdults: numberOfAdults, numberOfChildren: numberOfChildren, WiFi: hasWifi, roomType: roomType)
    }
    
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var checkInDateLabel: UILabel!
    @IBOutlet var checkInDatePicker: UIDatePicker!
    @IBOutlet var checkOutDateLabel: UILabel!
    @IBOutlet var checkOutDatePicker: UIDatePicker!
    
    @IBOutlet var numberOfAdultsLabel: UILabel!
    @IBOutlet var numberOfAdultsStepper: UIStepper!
    @IBOutlet var numberOfChildrenLabel: UILabel!
    @IBOutlet var numberOfChildrenStepper: UIStepper!
    
    
    @IBOutlet var wifiCostPerDay: UILabel!
    @IBOutlet var wifiSwitch: UISwitch!
    
    @IBOutlet var roomTypeLabel: UILabel!
    
    @IBOutlet var doneButton: UIBarButtonItem!
    
    @IBOutlet var numberOfNightQuantity: UILabel!
    @IBOutlet var numberOfNightDatesInterval: UILabel!
    @IBOutlet var roomTypeAmount: UILabel!
    @IBOutlet var roomTypeDescription: UILabel!
    @IBOutlet var wifiAmount: UILabel!
    @IBOutlet var wifiIsOn: UILabel!
    @IBOutlet var totalAmount: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateDoneButtonState()
        updateCharges()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Update Wi-Fi cost label according to current fee mentioned in Registration.swift
        wifiCostPerDay.text = "$\(Registration.wifiCostPerDay) per day"
        
        // Date picker style represetation in wheels style
        checkInDatePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        checkOutDatePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        
        let midnightTodayGDT = Calendar.current.startOfDay(for: Date())
        let midnightToday = Calendar.current.date(byAdding: .hour, value: 3, to: midnightTodayGDT)
        
        checkInDatePicker.minimumDate = midnightToday
        checkInDatePicker.date = midnightToday!
        
        if let registrationData = registrationData {
            firstNameTextField.text = registrationData.firstName
            lastNameTextField.text = registrationData.lastName
            emailTextField.text = registrationData.emailAddress
            checkInDatePicker.date = registrationData.checkInDate
            checkOutDatePicker.date = registrationData.checkOutDate
            numberOfAdultsStepper.value = Double(registrationData.numberOfAdults)
            numberOfChildrenStepper.value = Double(registrationData.numberOfChildren)
            wifiSwitch.isOn = registrationData.WiFi
            roomType = registrationData.roomType
        }
        
        
        updateNumberOfGuests()
        updateDateViews()
        updateRoomType()
        updateDoneButtonState()
    }
//Don't need doneBarButtonTapped(_:) method because it's purpose was to allow testing of input screen.
//    @IBAction func doneBarButtonTapped(_ sender: UIBarButtonItem) {
//        let firstName = firstNameTextField.text ?? ""
//        let lastName = lastNameTextField.text ?? ""
//        let email = emailTextField.text ?? ""
//        let checkInDate = checkInDatePicker.date
//        let checkOutDate = checkOutDatePicker.date
//        let numberOfAdults = Int(numberOfAdultsStepper.value)
//        let numberOfChildren = Int(numberOfChildrenStepper.value)
//        let hasWifi = wifiSwitch.isOn
//        let roomChoice = roomType?.name ?? "Not Set"
//
//        print("DONE TAPPED")
//        print("firstName: \(firstName)")
//        print("lastName: \(lastName)")
//        print("email: \(email)")
//        print("checkIn: \(checkInDate)")
//        print("checkOut: \(checkOutDate)")
//        print("numberOfAdults: \(numberOfAdults)")
//        print("numberOfChildren: \(numberOfChildren)")
//        print("wifi: \(hasWifi)")
//        print("roomType: \(roomChoice)")
//
//        // Don't need performSegue(withIdentifier:sender:) because it's programatic segue and we have storyboard unwind segue to Exit button
////        performSegue(withIdentifier: "UnwindToRegistrationsTable", sender: self)
//
//
//    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateViews()
//        print("checkInDatePicker.date is \(checkInDatePicker.date)")
//        print("checkOutDatePicker.date is \(checkOutDatePicker.date)")
        updateCharges()
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        updateNumberOfGuests()
    }
    
    @IBAction func wifiSwitchChanged(_ sender: UISwitch) {
        updateCharges()
    }
    
    @IBSegueAction func selectRoomType(_ coder: NSCoder) -> SelectRoomTypeTableViewController? {
        let selectRoomTypeController = SelectRoomTypeTableViewController(coder: coder)
        selectRoomTypeController?.delegate = self
        selectRoomTypeController?.roomType = roomType
        
        return selectRoomTypeController
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func updateDateViews(){
        checkOutDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: checkInDatePicker.date)
        checkInDateLabel.text = dateFormatter.string(from: checkInDatePicker.date)
        checkOutDateLabel.text = dateFormatter.string(from: checkOutDatePicker.date)
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case checkOutDatePickerCellIndexPath where isCheckOutDatePickerVisible == false:
            return 0
        case checkInDatePickerCellIndexPath where isCheckInDatePickerVisible == false:
            return 0
        default:
            return UITableView.automaticDimension
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath == checkInDateLabelCellIndexPath && isCheckOutDatePickerVisible == false {
                // check-in label selected, check-out picker is not visible, toggle check-in picker
                isCheckInDatePickerVisible.toggle()
            } else if indexPath == checkOutDateLabelCellIndexPath && isCheckInDatePickerVisible == false {
                // check-out label selected, check-in picker is not visible, toggle check-out picker
                isCheckOutDatePickerVisible.toggle()
            } else if indexPath == checkInDateLabelCellIndexPath || indexPath == checkOutDateLabelCellIndexPath {
                // either label was selected, previous conditions failed meaning at least one picker is visible, toggle both
                isCheckInDatePickerVisible.toggle()
                isCheckOutDatePickerVisible.toggle()
            } else {
                return
            }

//        if isCheckOutDatePickerVisible == false && isCheckInDatePickerVisible == false {
//            if checkInDateLabelCellIndexPath == indexPath {
//                isCheckInDatePickerVisible = true
//            } else if checkOutDateLabelCellIndexPath == indexPath {
//                isCheckOutDatePickerVisible = true
//            }
//        }
//
//        if isCheckInDatePickerVisible == true && isCheckOutDatePickerVisible == false {
//            if checkInDateLabelCellIndexPath == indexPath {
//                isCheckInDatePickerVisible = false
//            } else if checkOutDateLabelCellIndexPath == indexPath {
//                isCheckOutDatePickerVisible = true
//                isCheckInDatePickerVisible = false
//            }
//        }
//
//        if isCheckInDatePickerVisible == false && isCheckOutDatePickerVisible == true {
//            if checkInDateLabelCellIndexPath == indexPath {
//                isCheckInDatePickerVisible = true
//                isCheckOutDatePickerVisible = false
//            } else if checkOutDateLabelCellIndexPath == indexPath {
//                isCheckOutDatePickerVisible = false
//            }
//        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    
    func updateNumberOfGuests(){
        numberOfAdultsLabel.text = "\(Int(numberOfAdultsStepper.value))"
        numberOfChildrenLabel.text = "\(Int(numberOfChildrenStepper.value))"
    }
    
    func updateRoomType(){
        if let roomType = roomType {
            roomTypeLabel.text = roomType.name
        } else {
            roomTypeLabel.text = "Not Set"
        }
    }
    
    func updateDoneButtonState(){
        if registration == nil {
            doneButton.isEnabled = false
        } else {
            doneButton.isEnabled = true
        }
    }
    
    func updateCharges(){
        //86400 = 60 * 60 * 24 number of seconds in one day
        let numberOfNights = Int(checkOutDatePicker.date.timeIntervalSince(checkInDatePicker.date)/86400)
        
        numberOfNightQuantity.text = String(numberOfNights)
        numberOfNightDatesInterval.text = "\(dateFormatter.string(from: checkInDatePicker.date)) - \(dateFormatter.string(from: checkOutDatePicker.date))"
        roomTypeAmount.text = "$ \(numberOfNights * Int(roomType?.price ?? 0))"
        roomTypeDescription.text = "\(roomType?.name ?? "") @ $\(Int(roomType?.price ?? 0))/night"
        
         
        if wifiSwitch.isOn {
            wifiAmount.text = "$ \(Registration.wifiCostPerDay * numberOfNights)"
            wifiIsOn.text = "Yes"
            totalAmount.text = "$ \(numberOfNights * (Int(roomType?.price ?? 0) + Registration.wifiCostPerDay))"
        } else {
            wifiAmount.text = "$ 0"
            wifiIsOn.text = "No"
            totalAmount.text = "$ \(numberOfNights * (Int(roomType?.price ?? 0)))"
        }
        
        tableView.reloadData()
    }
}
