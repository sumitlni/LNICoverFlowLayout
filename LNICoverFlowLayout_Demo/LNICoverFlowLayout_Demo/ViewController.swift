//
//  ViewController.swift
//  LNICoverFlowLayout
//
//
//    The MIT License (MIT)
//
//    Copyright (c) 2017 Loud Noise Inc.
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.


import UIKit
import LNICoverFlowLayout

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var photoModelsDatasource = [PhotoModel]()
    
    @IBOutlet weak var photosCollectionView:UICollectionView!
    @IBOutlet weak var coverFlowLayout:LNICoverFlowLayout!
    
    @IBOutlet weak var maxDegreesValueLabel:UILabel!
    @IBOutlet weak var coverDensityValueLabel:UILabel!
    @IBOutlet weak var minOpacityValueLabel:UILabel!
    @IBOutlet weak var minScaleValueLabel:UILabel!
    
    var originalItemSize = CGSize.zero
    var originalCollectionViewSize = CGSize.zero
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalItemSize = coverFlowLayout.itemSize
        originalCollectionViewSize = photosCollectionView.bounds.size
        
        maxDegreesValueLabel.text = String(format: "%.2f", coverFlowLayout.maxCoverDegree)
        coverDensityValueLabel.text = String(format: "%.2f", coverFlowLayout.coverDensity)
        minOpacityValueLabel.text = String(format: "%.2f", coverFlowLayout.minCoverOpacity)
        minScaleValueLabel.text = String(format: "%.2f", coverFlowLayout.minCoverScale)
        
        generateDatasource()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {
            self.photosCollectionView.reloadData()
        }
    }
    
    // MARK: Auto Layout
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        // We should invalidate layout in case we are switching orientation.
        // If we won't do that we will receive warning from collection view's flow layout that cell size isn't correct.
        coverFlowLayout.invalidateLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Now we should calculate new item size depending on new collection view size.
        coverFlowLayout.itemSize = CGSize(
            width: photosCollectionView.bounds.size.width * originalItemSize.width / originalCollectionViewSize.width,
            height: photosCollectionView.bounds.size.height * originalItemSize.height / originalCollectionViewSize.height
        )
        
        // Forcely tell collection view to reload current data.
        photosCollectionView.setNeedsLayout()
        photosCollectionView.layoutIfNeeded()
        photosCollectionView.reloadData()
    }
    
    // MARK: Callbacks
    
    @IBAction func degreesSliderValueChanged(_ sender:UISlider) {
        coverFlowLayout.maxCoverDegree = CGFloat(sender.value)
        maxDegreesValueLabel.text = String(format: "%.2f", coverFlowLayout.maxCoverDegree)
        
        photosCollectionView.reloadData()
    }
    
    @IBAction func densitySliderValueChanged(_ sender:UISlider) {
        coverFlowLayout.coverDensity = CGFloat(sender.value)
        coverDensityValueLabel.text = String(format: "%.2f", coverFlowLayout.coverDensity)
        
        photosCollectionView.reloadData()
    }
    
    @IBAction func opacitySliderValueChanged(_ sender:UISlider) {
        coverFlowLayout.minCoverOpacity = CGFloat(sender.value)
        minOpacityValueLabel.text = String(format: "%.2f", coverFlowLayout.minCoverOpacity)
        
        photosCollectionView.reloadData()
    }
    
    @IBAction func scaleSliderValueChanged(_ sender:UISlider) {
        coverFlowLayout.minCoverScale = CGFloat(sender.value)
        minScaleValueLabel.text = String(format: "%.2f", coverFlowLayout.minCoverScale)
        
        photosCollectionView.reloadData()
    }
    
    // MARK: Private
    fileprivate func generateDatasource() {
        photoModelsDatasource = [
            PhotoModel(image: UIImage(named:"nature1")!, imageDescription: "Lake and forest."),
            PhotoModel(image: UIImage(named:"nature2")!, imageDescription: "Beautiful bench."),
            PhotoModel(image: UIImage(named:"nature3")!, imageDescription: "Sun rays going through trees."),
            PhotoModel(image: UIImage(named:"nature4")!, imageDescription: "Autumn Road."),
            PhotoModel(image: UIImage(named:"nature5")!, imageDescription: "Outstanding Waterfall."),
            PhotoModel(image: UIImage(named:"nature6")!, imageDescription: "Different Seasons."),
            PhotoModel(image: UIImage(named:"nature7")!, imageDescription: "Home near lake."),
            PhotoModel(image: UIImage(named:"nature8")!, imageDescription: "Perfect Mirror."),
            PhotoModel(image: UIImage(named:"smtng")!, imageDescription: "Interesting formula.")
        ]
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoModelsDatasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.kCustomCellIdentifier, for: indexPath) as! CustomCollectionViewCell
        
        cell.photoModel = photoModelsDatasource[indexPath.row]
        
        return cell
    }
    
}

// Model for storing image information
struct PhotoModel {
    let image:UIImage
    let imageDescription:String
}

// Custom cell
class CustomCollectionViewCell:UICollectionViewCell {
    static let kCustomCellIdentifier = "CustomCell"

    var photoModel:PhotoModel! {
        didSet {
            self.photoImageView.image = photoModel.image
            self.photoDescription.text = photoModel.imageDescription
        }
    }
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoDescription: UILabel!
}
