import UIKit

class ColorResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    var colorSchemes: [String: [String]] = [:]
    private var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Color schemes: \(colorSchemes)")
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        print("HEREHERE", colorSchemes)
        view.backgroundColor = .red
        navigationItem.title = "Matching Color Groups: "
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        setupTableView()
        setupUI()
        setupNavigationBarColors()
    }
    
    @objc func doneTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupNavigationBarColors() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4.0
        stackView.alignment = .center

        for category in colorSchemes.keys {
            if let rgbColorString = colorSchemes[category]?.first, let color = UIColor(fromRGBString: rgbColorString) {
                let colorView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
                colorView.backgroundColor = color
                colorView.layer.cornerRadius = 5
                stackView.addArrangedSubview(colorView)
            }
        }

        self.navigationItem.titleView = stackView
    }
    
    // MARK: - Setup Methods
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "colorCell")
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        let count = colorSchemes.keys.count
        print("Number of sections: \(count)")
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = Array(colorSchemes.keys)[section]
        let count = colorSchemes[category]?.count ?? 0
        print("Number of rows in section \(section): \(count)")
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "colorCell", for: indexPath)
        let category = Array(colorSchemes.keys)[indexPath.section]
        if let rgbColorString = colorSchemes[category]?[indexPath.row], let color = UIColor(fromRGBString: rgbColorString) {
            cell.backgroundColor = color
            cell.textLabel?.text = rgbColorString
            cell.textLabel?.textColor = color.isDarkColor ? .white : .black
        } else {
            // Default background if the conversion fails
            cell.backgroundColor = .black
            cell.textLabel?.text = "Invalid Color"
            cell.textLabel?.textColor = .white
        }
        
        return cell
    }

    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(colorSchemes.keys)[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
}
