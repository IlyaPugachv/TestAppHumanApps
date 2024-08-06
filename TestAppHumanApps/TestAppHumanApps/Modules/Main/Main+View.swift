import UIKit

extension Main {
    class View: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        // MARK: - Properties -
        
        var presenter: Presenter!
        private lazy var safeArea = self.view.safeAreaLayoutGuide
        
        // MARK: - Subviews -
        
        private let plusButton: UIButton = .init()
        private let imageView: UIImageView = .init()
        
        // MARK: - Initializers -
        
        public init(with presenter: Presenter) {
            self.presenter = presenter
            super.init(nibName: nil, bundle: nil)
            
            presenter.view = self
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        deinit { }
        
        // MARK: - Lifecycle -
        
        public override func viewDidLoad() {
            super.viewDidLoad()
            setup()
        }
        
        public override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        }
        
        // MARK: - Methods -
        
        private func setup() {
            buildHierarchy()
            configureSubviews()
            layoutSubviews()
            setupActions()
        }
        
        private func buildHierarchy() {
            view.backgroundColor = .white
            view.addView(plusButton)
            view.addView(imageView)
        }
        
        private func configureSubviews() {
          
            plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
            plusButton.tintColor = .black

            imageView.contentMode = .scaleAspectFit
            imageView.layer.borderColor = UIColor.yellow.cgColor
            imageView.layer.borderWidth = 3
        }
        
        private func layoutSubviews() {
            NSLayoutConstraint.activate([
              
                plusButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5),
                plusButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 12),
                plusButton.heightAnchor.constraint(equalToConstant: 45),
                plusButton.widthAnchor.constraint(equalToConstant: 45),
                
                imageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 50),
                imageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 12),
                imageView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -12),
                imageView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20)
            ])
        }
        
        private func setupActions() {
            plusButton.addTarget(self, action: #selector(didTapPlusButton), for: .touchUpInside)
        }
        
        @objc 
        private func didTapPlusButton() {
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            present(imagePickerController, animated: true, completion: nil)
        }
  
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true, completion: nil)
            
            if let selectedImage = info[.originalImage] as? UIImage {
                imageView.image = selectedImage
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - Extension View -

extension Main.View: MainView { }
