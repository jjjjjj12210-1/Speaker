//
//  LibraryPresenter.swift
//  Speaker
//
//  Created by Денис Ледовский on 28.08.2024.
//

import UIKit

protocol LibraryPresenterInterface {
    func viewDidLoad(withView view: LibraryPresenterOutputInterface)
    func selectAddInfo()
    func selectSearch()
    func selectDelete(_ index: Int, id: UUID)
    func deleteFromSearch(_ id: UUID)
}

final class LibraryPresenter: NSObject {

    private weak var view: LibraryPresenterOutputInterface?
    private var router: LibraryRouterInterface

    private let audioDataSource = Store.viewContext.audioDataSource

    init(router: LibraryRouterInterface) {
        self.router = router
    }
}

// MARK: - LibraryPresenterInterface

extension LibraryPresenter: LibraryPresenterInterface {
    func deleteFromSearch(_ id: UUID) {
        if let index = AudioManager.shared.allTracks.firstIndex(where: {$0.id == id}) {
            AudioManager.shared.trackDelete(index)
            audioDataSource.fetch { result in
                switch result {
                case .fail(let error): print("Error: ", error)
                case .success:
                    guard let audioMO = self.audioDataSource.getAudioList().first(where: {$0.id == id}) else {return}
                    print("delete track from CD - \(audioMO.url)")
                    Store.viewContext.deleteItem(object: audioMO) { result in
                        switch result {
                        case .success: print("Delted from CD")
                        case .fail(_): print("Cennot delete from cd")
                        }
                    }
                }
            }
        }
    }
    
    func selectDelete(_ index: Int, id: UUID) {
        AudioManager.shared.trackDelete(index)
        audioDataSource.fetch { result in
            switch result {
            case .fail(let error): print("Error: ", error)
            case .success:
                guard let audioMO = self.audioDataSource.getAudioList().first(where: {$0.id == id}) else {return}
//                let audioMO = self.audioDataSource.getAudioList()[index]
                print("delete track from CD - \(audioMO.url)")
                Store.viewContext.deleteItem(object: audioMO) { result in
                    switch result {
                    case .success: print("Delted from CD")
                    case .fail(_): print("Cennot delete from cd")
                    }
                }
            }
        }
    }
    
    func selectSearch() {
        router.showSearch()
    }
    
    func selectAddInfo() {
        router.showAddInfo()
    }
    
    func viewDidLoad(withView view: LibraryPresenterOutputInterface) {
        self.view = view
    }
}
