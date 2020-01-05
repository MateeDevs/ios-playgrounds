import UIKit
import PlaygroundSupport

extension String{
    func convertHtml() -> NSAttributedString{
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do{
            return try NSAttributedString(data: data, options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch{
            return NSAttributedString()
        }
    }
}

class LabelViewController : UIViewController {
    
    override func loadView() {
        
        // UI
        let view = UIView()
        view.backgroundColor = .white
        
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = "<!DOCTYPE html><html><body><h1>This is <a href=\"http://www.skoda-auto.com/other/memorandum-marketing-cs\" rel=\"nofollow\">http://www.skoda-auto.com/other/memorandum-marketing-cs</a> heading 1</h1><h2>This is heading 2</h2><h3>This is heading 3</h3><h4>This is heading 4</h4><h5>This is heading 5</h5><h6>This is heading 6</h6></body></html>".convertHtml()
        view.addSubview(label)
        
        // Layout
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
        
        self.view = view
    }
    
}

PlaygroundPage.current.liveView = LabelViewController()
