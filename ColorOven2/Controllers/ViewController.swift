import UIKit

class ViewController: UIViewController, UITextFieldDelegate  {
    
    let viewModel = ColorOvenViewModel()

    // UI Components
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    var currentPage: Int = 0

    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    
    var redValueLabel: UILabel!
    var greenValueLabel: UILabel!
    var blueValueLabel: UILabel!
    
    @IBOutlet var redTextField: UITextField!
    @IBOutlet var greenTextField: UITextField!
    @IBOutlet var blueTextField: UITextField!
    
    var selectColorButton: UIButton!
    var resetButton: UIButton!
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitialPage()
        setupUI()
        updateBackgroundColor()
        scrollView.isUserInteractionEnabled = false
        redSlider?.isUserInteractionEnabled = true
        greenSlider?.isUserInteractionEnabled = true
        blueSlider?.isUserInteractionEnabled = true

        redTextField?.isUserInteractionEnabled = true
        greenTextField?.isUserInteractionEnabled = true
        blueTextField?.isUserInteractionEnabled = true
    }
    
    func setupInitialPage() {
        let redComponents = createSlider(title: "Red")
        redSlider = redComponents.0
        redValueLabel = redComponents.1
        redTextField = redComponents.2

        let greenComponents = createSlider(title: "Green")
        greenSlider = greenComponents.0
        greenValueLabel = greenComponents.1
        greenTextField = greenComponents.2

        let blueComponents = createSlider(title: "Blue")
        blueSlider = blueComponents.0
        blueValueLabel = blueComponents.1
        blueTextField = blueComponents.2
        
        selectColorButton = UIButton(type: .system)
        selectColorButton.backgroundColor = UIColor.white
        selectColorButton.layer.cornerRadius = 10
        selectColorButton.setTitle("Select Color", for: .normal)
        selectColorButton.addTarget(self, action: #selector(didSelectColor), for: .touchUpInside)
        
        resetButton = UIButton(type: .system)
        resetButton.backgroundColor = UIColor.white
        resetButton.layer.cornerRadius = 10
        resetButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        resetButton.setTitle("Reset", for: .normal)
        resetButton.addTarget(self, action: #selector(didTapReset), for: .touchUpInside)
        
        let buttonStack = UIStackView(arrangedSubviews: [selectColorButton, resetButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 10
        
        let mainStack = UIStackView(arrangedSubviews: [redComponents.3, greenComponents.3, blueComponents.3, buttonStack])
        mainStack.axis = .vertical
        mainStack.spacing = 20
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mainStack.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])

        NSLayoutConstraint.activate([
            mainStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mainStack.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])
    }

    func createSlider(title: String) -> (UISlider, UILabel, UITextField, UIStackView) {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 255
        slider.value = 127.5
        slider.tintColor = .lightGray
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        slider.widthAnchor.constraint(equalToConstant: 200).isActive = true // Set a preferred width
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let valueLabel = UILabel()
        valueLabel.text = "\(Int(slider.value))"
        valueLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let textField = UITextField()
        textField.text = "\(Int(slider.value))"
        textField.widthAnchor.constraint(equalToConstant: 50).isActive = true
        textField.delegate = self
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5

        let stack = UIStackView(arrangedSubviews: [titleLabel, slider, valueLabel, textField])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center  // Added alignment to center
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return (slider, valueLabel, textField, stack)
    }


    @objc func sliderValueChanged(_ sender: UISlider) {
        if sender == redSlider {
            redValueLabel.text = "\(Int(sender.value))"
        } else if sender == greenSlider {
            greenValueLabel.text = "\(Int(sender.value))"
        } else if sender == blueSlider {
            blueValueLabel.text = "\(Int(sender.value))"
        }

        updateBackgroundColor()
    }

    func updateBackgroundColor() {
        let r = CGFloat(redSlider.value / 255.0)
        let g = CGFloat(greenSlider.value / 255.0)
        let b = CGFloat(blueSlider.value / 255.0)
        
        view.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    @objc func didSelectColor() {
        let r = Int(redSlider.value)
        let g = Int(greenSlider.value)
        let b = Int(blueSlider.value)
        
        viewModel.fetchColorSchemes(r: r, g: g, b: b) {
            DispatchQueue.main.async {
                self.transformAndPassData()
                self.presentColorResults()
            }
        }
    }

    func transformAndPassData() {
        var unifiedColorSchemes: [String: [String]] = [:]

        for (key, value) in self.viewModel.colorSchemes {
            if let singleRGB = value as? [String: Int] {
                let rgbString = "r: \(singleRGB["r"] ?? 0), g: \(singleRGB["g"] ?? 0), b: \(singleRGB["b"] ?? 0)"
                unifiedColorSchemes[key] = [rgbString]
            } else if let rgbArray = value as? [[String: Int]] {
                var rgbStrings: [String] = []
                for rgb in rgbArray {
                    let rgbString = "r: \(rgb["r"] ?? 0), g: \(rgb["g"] ?? 0), b: \(rgb["b"] ?? 0)"
                    rgbStrings.append(rgbString)
                }
                unifiedColorSchemes[key] = rgbStrings
            }
        }

        self.viewModel.colorSchemes = unifiedColorSchemes // Re-assign the transformed data to your viewModel.
    }

    func presentColorResults() {
        let resultsVC = ColorResultsViewController()

        var newColorSchemes: [String: [String]] = [:]
        for (key, value) in self.viewModel.colorSchemes {
            if let stringArray = value as? [String] {
                newColorSchemes[key] = stringArray
            }
        }
        resultsVC.colorSchemes = newColorSchemes

        let navController = UINavigationController(rootViewController: resultsVC)
        navController.modalTransitionStyle = .coverVertical
        self.present(navController, animated: true, completion: nil)
    }

    @objc func didTapReset() {
        redSlider.value = 127.5
        greenSlider.value = 127.5
        blueSlider.value = 127.5

        redValueLabel.text = "127"
        greenValueLabel.text = "127"
        blueValueLabel.text = "127"

        updateBackgroundColor()

        for view in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
//    func parseData(_ data: [String: Any]) {
//        for (key, dataValue) in data {
//            if let arrayValue = dataValue as? [String] {
//                viewModel.colorSchemes[key] = arrayValue
//            }
//        }
//        print(viewModel.colorSchemes)
//    }
    
    func createPages() {
        let categories = Array(viewModel.colorSchemes.keys)
        for (index, category) in categories.enumerated() {
            let tableView = UITableView()
            tableView.tag = index
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
            tableView.backgroundColor = .clear
            tableView.tableHeaderView = self.tableViewHeader(title: category)
            stackView.addArrangedSubview(tableView)
            
            NSLayoutConstraint.activate([
                tableView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            ])
        }
    }
    
    private func setupUI() {
        scrollView.isPagingEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
    
    private func tableViewHeader(title: String) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        
        let label = UILabel()
        label.text = title
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }
}
