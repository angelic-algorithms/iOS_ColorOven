import UIKit

class CustomTableViewCell: UITableViewCell {
    
    var overlayView: UIView?
    let colorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black // or any default color you want
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Add colorLabel to the cell's contentView
        contentView.addSubview(colorLabel)
        
        // Setup AutoLayout constraints for colorLabel
        NSLayoutConstraint.activate([
            colorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        overlayView?.removeFromSuperview()
        overlayView = nil
        colorLabel.text = nil // Reset the label's text
    }
}
