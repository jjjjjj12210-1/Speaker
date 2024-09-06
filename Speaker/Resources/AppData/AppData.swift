import Foundation

final class AppData {

    static let policyURL = URL(string: "")
    static let termsURL = URL(string: "")
}

enum Text {
    static let fromIpadTitle = "How to add music files from another \niPhone/iPad/Macbook"
    static let fromIpadText = "Turn on AirDrop on iPhone and iPad: Open Control Center > Enable AirDrop > Choose Contacts Only or Everyone. \n\nOn iPad: Open the Files app > Find the song you’d like to share > Hold the icon of song > Click Share Song > AirDrop > Choose iPhone \n\nThen On iPhone: A pop-up message will appear and click Accept. \n\nAfter that, go to this app again and click on Files button in the previous step. \n\nIn files you can easily import your music files to this app’s library. \n\nSimilarly, using the same procedure, you can transfer a file from a MacBook to an iPhone."

    static let dropBoxTitle = "How to add music files from \nDropbox, Drive, Onebox"
    static let dropBoxText = "To export a file on the Dropbox, Google Drive, Onebox mobile app on your iPhone: \n\n1. Open the Dropbox, Google Drive or Onebox mobile app. \n\n2.Tap the Files tab. \n\n3. Search your music files. \n\n4. Save the file locally: • To save the file locally, tap Save to device. \n\nAfter that, go to this app again and click on Files button in the previous step. \n\nIn files you can easily add your music files to this app’s library."

}
