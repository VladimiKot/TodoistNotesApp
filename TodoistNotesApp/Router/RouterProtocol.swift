import Foundation
import UIKit

protocol RouterProtocol {
    
    func openNoteController(from vc: UIViewController,
                            note: Note?, noteStorage: NoteStorageProtocol,
                            completion: @escaping () -> Void)
    
    func closeNoteController(from vc: UIViewController)
}
