//
//  PhotoDetailViewController.swift
//  Rover
//
//  Created by Steve Lederer on 12/19/18.
//  Copyright © 2018 Steve Lederer. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var cameraLabel: UILabel!
    @IBOutlet weak var solLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    let client = SHLMarsRoverClient()
    
    @objc var photo: SHLMarsPhoto? 
    
    @objc var rover: SHLMarsRover?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
        guard let photo = photo else { return }
        guard let camera = photo.camera else { return }
        cameraLabel.text = "Camera: \(camera)"
        solLabel.text = "Mars sol \(photo.solTaken)"
        let date = formatDate(dateAsString: photo.earthDateTaken)
        let formattedDate = formatDateToString(date)
        dateLabel.text = formattedDate
        guard let roverName = rover?.name else { return }
        self.title = roverName
        
        let cache = SHLPhotoCache.shared
        if let imageData = cache?.imageData(forIdentifier: photo.photoID),
            let image = UIImage(data: imageData) {
            photoImageView.image = image
        } else {
            client.fetchImageData(for: photo) { (data) in
                if (data == nil) {
                    NSLog("Error fetching photo.")
                    return
                }
                if let image = UIImage(data: data!),
                    self.photo == photo {
                    DispatchQueue.main.async {
                        self.photoImageView.image = image
                    }
                }
            }
        }
    }
    
    func formatDate(dateAsString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.date(from: dateAsString)
        return formattedDate ?? Date()
    }
    
    func formatDateToString(_ date: Date) -> String? {
        let otherDateFormatter = DateFormatter()
        otherDateFormatter.dateStyle = .medium
        return otherDateFormatter.string(from: date)
    }
}
