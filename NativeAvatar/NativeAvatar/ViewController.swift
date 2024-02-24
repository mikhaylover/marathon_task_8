//

import UIKit

class ViewController: UIViewController {

    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.delegate = self
        return scroll
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()

    private let avatarOffset = 8.0
    private let avatarSide = 36.0
    private lazy var avatar: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle.fill")?
            .withRenderingMode(.alwaysOriginal).withTintColor(.systemGray)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let scrollSize = CGSize(width: view.bounds.size.width, height: view.bounds.size.height)
        let scrollContentSize = CGSize(width: view.bounds.size.width, height: view.bounds.size.height + 300)

        if scrollView.superview == nil {
            view.addSubview(scrollView)
            scrollView.frame = CGRect(origin: .zero, size: scrollSize)
            scrollView.contentSize = scrollContentSize

        }
        
        if contentView.superview == nil {
            scrollView.addSubview(contentView)
            contentView.frame = CGRect(origin: .zero, size: scrollContentSize)
        }

        if avatar.superview == nil, let largeTitleView = findLargeTitleView() {
            largeTitleView.addSubview(avatar)
            setAvatarFrame(superview: largeTitleView)
        }
    }

    private func configureView() {
        view.backgroundColor = .white
        title = "Avatar"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func findLargeTitleView() -> UIView? {
        guard let navigationBar = self.navigationController?.navigationBar else { return nil }
        for subview in navigationBar.subviews {
            // NOTE: based on navbars layout: large title under standart title
            // all other subviews origin.y = 0
            if subview.frame.origin.y > 0 {
                print("HURRAY")
                return subview
            }
        }
        return nil
    }

    private func setAvatarFrame(superview: UIView) {
        avatar.frame = CGRect(
            origin: CGPoint(
                x: superview.frame.width - avatarOffset - avatarSide,
                y: superview.frame.height - avatarOffset - avatarSide
            ),
            size: CGSize(width: avatarSide, height: avatarSide)
        )
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let avatarSuperview = avatar.superview {
            setAvatarFrame(superview: avatarSuperview)
        }
    }
}
