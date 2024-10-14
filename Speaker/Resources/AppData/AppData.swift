import Foundation

final class AppData {

    static let policyURL = URL(string: "https://sites.google.com/view/speakercontrollers1/privacy-policy")
    static let termsURL = URL(string: "https://sites.google.com/view/speakercontrollers1/terms-of-use")

    static let appHubKey = "app_jg2fJMXzarnhm3m2vVhne9etWXEy3E"
    static let appID = "6736561086"
}

enum Text {
    static let fromIpadTitle = "How to add music files from another \niPhone/iPad/Macbook"
    static let fromIpadText = "Turn on AirDrop on iPhone and iPad: Open Control Center > Enable AirDrop > Choose Contacts Only or Everyone. \n\nOn iPad: Open the Files app > Find the song you’d like to share > Hold the icon of song > Click Share Song > AirDrop > Choose iPhone \n\nThen On iPhone: A pop-up message will appear and click Accept. \n\nAfter that, go to this app again and click on Files button in the previous step. \n\nIn files you can easily import your music files to this app’s library. \n\nSimilarly, using the same procedure, you can transfer a file from a MacBook to an iPhone."

    static let dropBoxTitle = "How to add music files from \nDropbox, Drive, Onebox"
    static let dropBoxText = "To export a file on the Dropbox, Google Drive, Onebox mobile app on your iPhone: \n\n1. Open the Dropbox, Google Drive or Onebox mobile app. \n\n2.Tap the Files tab. \n\n3. Search your music files. \n\n4. Save the file locally: • To save the file locally, tap Save to device. \n\nAfter that, go to this app again and click on Files button in the previous step. \n\nIn files you can easily add your music files to this app’s library."

    static let wifiTitle = "Connecting Sonos Speaker to iPhone\nvia AirPlay"
    static let wifiText = "1. **Check Compatibility**: Ensure that your  speaker supports AirPlay 2. Models like Sonos One, Play:5, Playbase, Amp, and Beam are compatible with AirPlay 2.\n\n2. **Connect Devices to the Same Network**: Make sure that both your iPhone and the Sonos speaker are connected to the same Wi-Fi network.\n\n3. **Open Control Center on iPhone**:\n - On iPhone X and later models or iPad, swipe down from the top-right corner of the screen.\n - On iPhone 8 and earlier models, swipe up from the bottom edge of the screen.\n\n4. **Select AirPlay**: In the Control Center, find and tap on the AirPlay icon (a triangle with circles).\n\n5. **Choose Your Sonos Speaker**: From the list of available devices, select your Sonos speaker. If you want to play sound on multiple speakers, you can select several devices simultaneously.\n\n6. **Start Playback**: Play music or any audio file on your iPhone, and the sound will start playing through the selected Sonos speaker.\n\nNow you can enjoy music or podcasts through your Sonos speaker using AirPlay!"

    static let wifiTitle2 = "To connect your Sonos speaker to Wi-Fi,\nfollow these steps:"

    static let howConnectTitle = "How to connect speaker via Bluetooth"

    static let howConnectText = "Connecting Speaker to iPhone via Bluetooth\n\n1. **Power On the Speaker**: Connect your  speaker to a power source and ensure it is turned on.\n\n2. **Switch the Speaker to Bluetooth Mode**: Locate the mode button on the back of the speaker and switch it to Bluetooth. This will allow the speaker to search for devices to connect to.\n\n3. **Enable Bluetooth on iPhone**: Go to the Settings on your iPhone, select Bluetooth and turn it on.\n\n4. **Find the Speaker in the Device List**: In the Bluetooth section on your iPhone, you will see a list of available devices. Look for your speaker and select it to connect.\n\n5. **Confirm the Connection**: After selecting the speaker, you may need to confirm the connection by following any prompts on your screen.\n\n6. **Start Playing Music**: You can now play music from your iPhone through the speaker.\n\nIf your model does not support Bluetooth, you will need to connect it to a router using an Ethernet cable and set it up through the Sonos app by following the instructions provided in the app. Select the Sonos network in your iPhone's Wi-Fi settings, then return to the app and enter your home network password.\n\nIf your  model does not support Bluetooth, you can connect it to your iPhone using a wired setup with an Air Play and Wifi."
}
