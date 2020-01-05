import UIKit
import PlaygroundSupport

class MainViewController: UIViewController {
    
    override func loadView() {
        
        // Background
        let view = UIView()
        view.backgroundColor = .white
        
        // Blue view
        let blueView = UIView()
        blueView.backgroundColor = .blue
        view.addSubview(blueView)
        
        blueView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blueView.widthAnchor.constraint(equalToConstant: 100),
            blueView.heightAnchor.constraint(equalToConstant: 100),
            blueView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 25),
            blueView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // White dot
        let whiteDot = UIView()
        whiteDot.backgroundColor = .white
        view.addSubview(whiteDot)
        
        whiteDot.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            whiteDot.widthAnchor.constraint(equalToConstant: 10),
            whiteDot.heightAnchor.constraint(equalToConstant: 10),
            whiteDot.leadingAnchor.constraint(equalTo: blueView.leadingAnchor, constant: 10),
            whiteDot.topAnchor.constraint(equalTo: blueView.topAnchor, constant: 10)
        ])
        
        // Red view
        let redView = UIView()
        redView.backgroundColor = .red
        view.addSubview(redView)
        
        redView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            redView.widthAnchor.constraint(equalToConstant: 100),
            redView.heightAnchor.constraint(equalToConstant: 100),
            redView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -50),
            redView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        self.view = view
        
        whiteDot.layer.zPosition = .greatestFiniteMagnitude
    }
    
}

PlaygroundPage.current.liveView = MainViewController()
