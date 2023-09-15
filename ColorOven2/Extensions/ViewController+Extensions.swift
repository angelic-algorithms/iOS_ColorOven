import UIKit

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let totalCells = CGFloat(tableView.numberOfRows(inSection: 0))
        let headerHeight: CGFloat = 40
        return ((self.view.frame.height - headerHeight) / totalCells)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Cell at section: \(indexPath.section), row: \(indexPath.row) tapped")
        guard let cell = tableView.cellForRow(at: indexPath) as? CustomTableViewCell else { return }
        
        let category = Array(viewModel.colorSchemes.keys)[tableView.tag]
        guard let colorNames = viewModel.colorSchemes[category] as? [String] else { return }
        
        let colorName = colorNames[indexPath.row]
        
        if cell.overlayView == nil {
            let overlayView = UIView(frame: cell.bounds)
            overlayView.backgroundColor = UIColor.clear.withAlphaComponent(0.6)
            overlayView.tag = 999 // For easy identification
            
            let label = UILabel(frame: overlayView.bounds)
            label.textAlignment = .center
            label.textColor = .white
            label.text = colorName
            overlayView.addSubview(label)
            cell.contentView.addSubview(overlayView)
            cell.overlayView = overlayView
        } else {
            cell.overlayView?.isHidden = !cell.overlayView!.isHidden
            if let label = cell.overlayView?.subviews.first as? UILabel {
                label.text = colorName
            }
        }
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = Array(viewModel.colorSchemes.keys)[tableView.tag]
        return (viewModel.colorSchemes[category] as? [String])?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        let category = Array(viewModel.colorSchemes.keys)[tableView.tag]
        
        if let colorNames = viewModel.colorSchemes[category] as? [String] {
            let colorName = colorNames[indexPath.row]
            cell.backgroundColor = UIColor(named: colorName) // Ensure you have the named colors set up
            cell.colorLabel.text = colorName
        }
        
        // Hide overlay by default during cell reuse
        cell.overlayView?.isHidden = true
        
        return cell
    }
}
