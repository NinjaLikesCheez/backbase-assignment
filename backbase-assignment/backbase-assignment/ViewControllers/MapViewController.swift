//
//  MapViewController.swift
//  backbase-assignment
//
//  Created by ninja on 17/04/2021.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()

    private let location: Location

    init(_ location: Location) {
        self.location = location

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = location.getDisplayName()
        navigationItem.largeTitleDisplayMode = .never

        let mapLocation = CLLocation(
            latitude: location.coordinates.latitude,
            longitude: location.coordinates.longitude
        )

        let region = MKCoordinateRegion(
            center: mapLocation.coordinate,
            span: .init(latitudeDelta: 0.03, longitudeDelta: 0.03)
        )

        mapView.setRegion(region, animated: true)

        view.addSubview(mapView)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}