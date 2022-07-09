# Lister
SwiftUI-like lightweight tableView interface builder library


```swift

class ViewController: UIViewController {

  private let view1 = UIView()
  private let view2 = UIView()
  private let view3 = UIView()

  private var isTriggered: Bool = false {
    didSet {
      if isTriggered {
        lister.appendRow(
          .init(view: view3, height: 150, edges: nil, action: nil),
            section: 0
          )
        }
        else {
          lister.removeRow(at: .init(row: 1, section: 0))
        }
    }
}

  private let content: [ListerSection] = [
    .init(
      rows: [
          ListerRow(view: view1, height: 150, edges: nil, action: {
              self.isTriggered.toggle()
          })
      ],
      header: "1",
      footer: "1"
  ),
    .init(
        rows: [
            ListerRow(view: view2, height: 50, edges: nil, action: nil)
        ],
        header: "2",
        footer: "2"
    )
  ]

  override func viewDidLoad() {
    super.viewDidLoad()
    let lister = Lister(frame: .zero, style: .insertGrouped)
    // configure frame with frame/constraints/LayoutPin/SnapKit

    lister.set(content)
  }
}




```
