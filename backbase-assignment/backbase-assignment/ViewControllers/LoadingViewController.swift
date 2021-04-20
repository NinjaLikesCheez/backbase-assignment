//
//  LoadingViewController.swift
//  backbase-assignment
//
//  Created by ninja on 17/04/2021.
//

import UIKit

/// A view to show the user while we're processing the initial data
class LoadingViewController: UIViewController {
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()

    private let blurEffectView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let activityLabel: UILabel = {
        let label = UILabel()
        label.text = "'Initial loading time of the app does not matter.' 🎉"
        label.sizeToFit()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(blurEffectView)
        view.addSubview(activityLabel)
        view.addSubview(activityIndicator)

        layoutContraints()
    }

    private func layoutContraints() {
        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            blurEffectView.leftAnchor.constraint(equalTo: view.leftAnchor),
            blurEffectView.rightAnchor.constraint(equalTo: view.rightAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            activityLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 10),
            activityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activityLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
