import UIKit

class SpeakerButton: UIButton {

    // MARK: - Functions

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let newArea = CGRect(
            x: self.bounds.origin.x,
            y: self.bounds.origin.y,
            width: self.bounds.size.width + 20.0,
            height: self.bounds.size.height + 20.0
        )
        return newArea.contains(point)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
