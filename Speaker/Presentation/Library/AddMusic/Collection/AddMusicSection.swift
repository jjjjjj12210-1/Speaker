import Foundation

class AddMusicSection: Section<StreamCellModel> {}

extension AddMusicSection {

    static func allSections() -> [AddMusicSection] {
        return [ .init(title: "",
                       items: [StreamCellModel(title: "Audiomack", image: .streamAuto),
                               StreamCellModel(title: "Mixcloud", image: .streamMix),
                               StreamCellModel(title: "Soundcloud", image: .streamSoundcloud),
                               StreamCellModel(title: "Spotify", image: .streamSpotify),
                               StreamCellModel(title: "Youtube", image: .streamYoutube),
                               StreamCellModel(title: "Amazon", image: .streamAmazon),
                               StreamCellModel(title: "Pandora", image: .streamPandora),
                               StreamCellModel(title: "SiriusXM", image: .streamSirius),
                               StreamCellModel(title: "Browser", image: .streamBroweser),
                               ])
        ]
    }
}
