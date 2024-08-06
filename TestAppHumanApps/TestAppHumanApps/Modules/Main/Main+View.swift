import UIKit

extension Main {
    class View: UIViewController {
        
        // MARK: - Properties -
        
        var presenter: Presenter!
        private lazy var safeArea = self.view.safeAreaLayoutGuide
        
        // MARK: - Subviews -
        
        private let plusButton: UIButton = .init()
        private let frameView: UIView = .init()
        private let imageContainerView: UIView = .init()
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
            view.addView(frameView)
            frameView.addView(imageContainerView)
            imageContainerView.addView(imageView)
        }
        
        private func configureSubviews() {
    
            plusButton.configureButton(
                systemImageName: "plus",
                tintColor: .black
            )
            
            frameView.layer.borderColor = UIColor.yellow.cgColor
            frameView.layer.borderWidth = 3

            imageContainerView.clipsToBounds = true

            imageView.contentMode = .scaleAspectFit
            imageView.isUserInteractionEnabled = true

            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
            let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
            let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotationGesture(_:)))
            
            imageView.addGestureRecognizer(panGesture)
            imageView.addGestureRecognizer(pinchGesture)
            imageView.addGestureRecognizer(rotationGesture)
        }
        
        private func layoutSubviews() {
            NSLayoutConstraint.activate([
                plusButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5),
                plusButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 12),
                plusButton.heightAnchor.constraint(equalToConstant: 45),
                plusButton.widthAnchor.constraint(equalToConstant: 45),
               
                frameView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 60),
                frameView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 12),
                frameView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -12),
                frameView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20),
                
                imageContainerView.topAnchor.constraint(equalTo: frameView.topAnchor),
                imageContainerView.leadingAnchor.constraint(equalTo: frameView.leadingAnchor),
                imageContainerView.trailingAnchor.constraint(equalTo: frameView.trailingAnchor),
                imageContainerView.bottomAnchor.constraint(equalTo: frameView.bottomAnchor),
                
                imageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor)
            ])
        }
        
        private func setupActions() {
            plusButton.addTarget(self, 
                                 action: #selector(didTapPlusButton),
                                 for: .touchUpInside)
        }
    
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true, completion: nil)
            
            if let selectedImage = info[.originalImage] as? UIImage {
                imageView.image = selectedImage
                imageView.frame = imageContainerView.bounds
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }

        // MARK: - Gesture Handlers -
        
        @objc
        private func didTapPlusButton() {
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            present(imagePickerController, animated: true, completion: nil)
        }
        
        @objc 
        private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
            guard let viewToMove = gesture.view else { return }
            
            let translation = gesture.translation(in: self.view)
            if gesture.state == .began || gesture.state == .changed {
                viewToMove.center = CGPoint(x: viewToMove.center.x + translation.x,
                                            y: viewToMove.center.y + translation.y)
                gesture.setTranslation(.zero, in: self.view)
            }
        }
        
        @objc 
        private func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
            guard let viewToZoom = gesture.view else { return }
            
            if gesture.state == .began || gesture.state == .changed {
                viewToZoom.transform = viewToZoom.transform.scaledBy(x: gesture.scale, y: gesture.scale)
                gesture.scale = 1.0
            }
        }
        
        @objc 
        private func handleRotationGesture(_ gesture: UIRotationGestureRecognizer) {
            guard let viewToRotate = gesture.view else { return }
            
            if gesture.state == .began || gesture.state == .changed {
                viewToRotate.transform = viewToRotate.transform.rotated(by: gesture.rotation)
                gesture.rotation = 0
            }
        }
    }
}

// MARK: - Extension View -

extension Main.View: MainView, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}
