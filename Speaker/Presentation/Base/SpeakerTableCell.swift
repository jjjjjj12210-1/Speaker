import UIKit

class SpeakerTableCell: UITableViewCell {

    static var id: String {
        return String(describing: self)
    }

    class var height: CGFloat {
        return 0
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func setup() {
        //object configuration:
    }

    static func register(_ tableView: UITableView) {
        tableView.register(Self.self, forCellReuseIdentifier: Self.id)
    }

    static func getCell(_ tableView: UITableView, for indexPath: IndexPath) -> Self {
        return tableView.dequeueReusableCell(withIdentifier: Self.id, for: indexPath) as! Self
    }
}
