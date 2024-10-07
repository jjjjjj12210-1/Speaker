import UIKit
import CoreBluetooth
import ExternalAccessory
import AVFoundation

protocol BluetoothMenuPresenterOutputInterface: AnyObject {

}

final class BluetoothMenuViewController: SpeakerViewController {

    private var presenter: BluetoothMenuPresenterInterface?
    private var router: BluetoothMenuRouterInterface?

    private var deviceArray = [BluetoothListModel(title: "Xiaomi Mi Dual Mode Wireless", isConnect: false),
                               BluetoothListModel(title: "Xiaomi Mi Dual Mode Wireless", isConnect: true)]


    var peripherals: [CBPeripheral] = []
    var bluetoothManager: CBCentralManager? = nil

    var mainPeripheral: CBPeripheral? = nil
    var mainCharacteristic: CBCharacteristic? = nil

    let options: [String: Any] = [CBCentralManagerScanOptionAllowDuplicatesKey:
                                  NSNumber(value: false)]

//    let BLEService = "DFB0"
//    let BLECharacteristic = "DFB1"

    // MARK: - UI
    private lazy var mainImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.image = .bcLogo
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .poppins(.bold, size: 26)
        label.text = "Find your \ndevice"
        label.numberOfLines = 2
        return label
    }()

    private lazy var descLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .textGrayLight
        label.font = .poppins(.regular, size: 14)
        label.text = "Make sure your device is \nturned on and close to you."
        label.numberOfLines = 1
        return label
    }()

    private lazy var mainTable: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .baseBlack
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none

        BluetoothListCell.register(tableView)
        return tableView
    }()

    // MARK: - Init
    init(presenter: BluetoothMenuPresenterInterface, router: BluetoothMenuRouterInterface) {
        self.presenter = presenter
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Lifecicle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBar?.hideTabBar(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        customInit()
        presenter?.viewDidLoad(withView: self)

//        listAvailableAudioDevices()

//        bluetoothManager = CBCentralManager(delegate: self, queue: nil)
//        bluetoothManager?.delegate = self

//        EAAccessoryManager.shared().showBluetoothAccessoryPicker(withNameFilter: nil, completion: nil)

//        scanBLEDevices()
    }
}

// MARK: - BluetoothMenuPresenterOutputInterface

extension BluetoothMenuViewController: BluetoothMenuPresenterOutputInterface {

}

// MARK: - UISetup

private extension BluetoothMenuViewController {
    func customInit() {
        setNavBar()

        view.addSubview(mainImage)
        view.addSubview(titleLabel)
        view.addSubview(descLabel)
        view.addSubview(mainTable)

        mainImage.snp.makeConstraints({
            $0.size.equalTo(164)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(48)
        })

        titleLabel.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalTo(mainImage.snp.bottom).offset(20)
        })

        descLabel.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(34)
        })

        mainTable.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(descLabel.snp.bottom).offset(30)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(10)
        })
    }
}

// MARK: - UITableViewDelegate

extension BluetoothMenuViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        deviceArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BluetoothListCell.getCell(tableView, for: indexPath)
        cell.configure(deviceArray[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        78
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.selectDevice(isConnect: deviceArray[indexPath.row].isConnect)
    }
}

// MARK: - NavBar

private extension BluetoothMenuViewController {
    func setNavBar() {
        navigationItem.title = "Connect Device"

        let button = SpeakerButton.init(type: .custom)
        let normalAttributedString = NSAttributedString(
            string: "BACK",
            attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.textGrayLight,
                NSAttributedString.Key.font : UIFont.poppins(.regular, size: 12)
            ]
        )
        button.setAttributedTitle(normalAttributedString, for: .normal)
        button.setAttributedTitle(normalAttributedString, for: .highlighted)
        button.frame = CGRect.init(x: 0, y: 0, width: 50, height: 20)
        button.addTarget(self, action: #selector(tapBack), for: .touchUpInside)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
    }

    @objc func tapBack() {
        presenter?.selectBack()
    }

//    func listAvailableAudioDevices() {
//        let audioDevices = AVCaptureDevice.DiscoverySession(
//            deviceTypes: [.builtInMicrophone,
//                          .external],
//            mediaType: .audio,
//            position: .unspecified
//        ).devices
//
//        for device in audioDevices {
//            print("Device name: \(device.localizedName)")
//        }
//    }
}

extension BluetoothMenuViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        print(central.state)
//        print(central.isScanning)
        switch central.state {
          case .unknown:
            print("central.state is .unknown")
          case .resetting:
            print("central.state is .resetting")
          case .unsupported:
            print("central.state is .unsupported")
          case .unauthorized:
            print("central.state is .unauthorized")
          case .poweredOff:
            print("central.state is .poweredOff")
          case .poweredOn:
            print("central.state is .poweredOn")
            bluetoothManager?.scanForPeripherals(withServices: nil, options: options)
        @unknown default:
            print("default central.state is .unknown")
        }

    }

//    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//        if(!peripherals.contains(peripheral)) {
//            peripherals.append(peripheral)
//        }
//        print(peripheral)
//    }

//    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber){
//
//        let peripheralLocalName_advertisement = ((advertisementData as NSDictionary).value(forKey: "kCBAdvDataLocalName")) as? String
//
//        if (((advertisementData as NSDictionary).value(forKey: "kCBAdvDataLocalName")) != nil) {
//             print(peripheralLocalName_advertisement)//peripheral name from advertismentData
//             print(peripheral.name)//peripheral name from peripheralData
////             peripherals.append(peripheral)
////             arrayPeripheral.append(advertisementData)
//        }
//    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
      print(peripheral)
    }


    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {

        //pass reference to connected peripheral to parent view
        mainPeripheral = peripheral
        peripheral.delegate = self
        peripheral.discoverServices(nil)

        //set the manager's delegate view to parent so it can call relevant disconnect methods
        bluetoothManager?.delegate = self


        print("Connected to " +  (peripheral.name ?? ""))
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print(error!)
    }
}


private extension BluetoothMenuViewController {

    // MARK: BLE Scanning
    func scanBLEDevices() {
        //manager?.scanForPeripherals(withServices: [CBUUID.init(string: parentView!.BLEService)], options: nil)

        //if you pass nil in the first parameter, then scanForPeriperals will look for any devices.
        bluetoothManager?.scanForPeripherals(withServices: nil, options: nil)
//        bluetoothManager?.retrieveConnectedPeripherals(withServices: <#T##[CBUUID]#>)
//        bluetoothManager?.retrievePeripherals(withIdentifiers: <#T##[UUID]#>)

        //stop scanning after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 60.0) {
            self.stopScanForBLEDevices()
        }
    }

    func stopScanForBLEDevices() {
        bluetoothManager?.stopScan()
    }
}

extension BluetoothMenuViewController: CBPeripheralDelegate {

}
