      //
//  ResultsViewController.swift
//  MakeUp App
//
//  Created by Benjamin Bernstein on 4/4/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import UIKit


class ResultsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let resultStore = ResultStore.sharedInstance

    let youtubeReviewLabel = UILabel()
    let youtubeReviewVideos = MediaCollectionView(frame: CGRect.zero)
    
    let productDisplay = ProductDisplayView()
    
    let youtubeTutorialLabel = UILabel()
    let youtubeTutorialVideos = MediaCollectionView(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Palette.white.color
        guard let product = resultStore.product else {return}
        navBar(title: product.title, leftButton: .back, rightButton: .favorite)
        
        if let product = resultStore.product {
            print("product title right before I do a youtube search", product.title)
            self.resultStore.getYouTubeVideos(search: product.title, videoType: .review) {
                DispatchQueue.main.async {
                    print("review videos fetched")
                    self.youtubeReviewVideos.reloadData()
                }
                
            }
            self.resultStore.getYouTubeVideos(search: product.title, videoType: .tutorial) {
                DispatchQueue.main.async {
                    print("tutorial videos fetched")
                    self.youtubeTutorialVideos.reloadData()
                }
                
            }
            
        }
        setUpLabels()
        setUpCollectionViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    func setUpLabels() {
        
        view.addSubview(youtubeTutorialLabel)
        view.addSubview(youtubeReviewLabel)
        view.addSubview(youtubeReviewVideos)
        view.addSubview(youtubeTutorialVideos)
        view.addSubview(productDisplay)
        
        productDisplay.product = resultStore.product

        youtubeTutorialLabel.text = "Tutorials"
        youtubeTutorialLabel.textColor = Palette.darkGrey.color
        youtubeTutorialLabel.font = Fonts.Playfair(withStyle: .italic, sizeLiteral: 25)
        youtubeTutorialLabel.textAlignment = .left
        
        youtubeReviewLabel.text = "Reviews"
        youtubeReviewLabel.textColor = Palette.darkGrey.color
        youtubeReviewLabel.font = Fonts.Playfair(withStyle: .italic, sizeLiteral: 25)
        youtubeReviewLabel.textAlignment = .left
        
        youtubeTutorialLabel.translatesAutoresizingMaskIntoConstraints = false
        youtubeTutorialLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
        youtubeTutorialLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        youtubeTutorialLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        youtubeTutorialLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05)
        
        youtubeReviewLabel.translatesAutoresizingMaskIntoConstraints = false
        youtubeReviewLabel.topAnchor.constraint(equalTo: youtubeTutorialVideos.bottomAnchor).isActive = true
        youtubeReviewLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        youtubeReviewLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        youtubeReviewLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
    }
    
    func setUpCollectionViews() {
       youtubeTutorialVideos.register(YoutubePreviewCell.self, forCellWithReuseIdentifier: "tutorialCell")
        youtubeReviewVideos.register(YoutubePreviewCell.self, forCellWithReuseIdentifier: "reviewCell")
        
        youtubeReviewVideos.delegate = self
        youtubeReviewVideos.dataSource = self
        
        youtubeTutorialVideos.delegate = self
        youtubeTutorialVideos.dataSource = self
        
        //productDisplay.translatesAutoresizingMaskIntoConstraints = false
        //productDisplay.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        //productDisplay.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        //productDisplay.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        //productDisplay.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true
        
        youtubeTutorialVideos.translatesAutoresizingMaskIntoConstraints = false
        youtubeTutorialVideos.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        youtubeTutorialVideos.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true
        youtubeTutorialVideos.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        youtubeTutorialVideos.topAnchor.constraint(equalTo: youtubeTutorialLabel.bottomAnchor).isActive = true
        
        youtubeReviewVideos.translatesAutoresizingMaskIntoConstraints = false
        youtubeReviewVideos.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        youtubeReviewVideos.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true
        youtubeReviewVideos.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        youtubeReviewVideos.topAnchor.constraint(equalTo: youtubeReviewLabel.bottomAnchor).isActive = true
        
    }
    
    //Mark: COLLECTION VIEW METHODS
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.youtubeReviewVideos:
            return resultStore.youtubeReviewVideos.count
            
        default:
            return resultStore.youtubeTutorialVideos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case self.youtubeReviewVideos:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reviewCell", for: indexPath) as! YoutubePreviewCell
            cell.backgroundColor = Palette.white.color
            cell.youtube = resultStore.youtubeReviewVideos[indexPath.item]
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tutorialCell", for: indexPath) as! YoutubePreviewCell
            cell.youtube = resultStore.youtubeTutorialVideos[indexPath.item]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: collectionView.frame.height)
    }
    
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case self.youtubeReviewVideos:
            print("I was tapped")
            let destinationVC = YouTubePlayerViewViewController()
            let cell = resultStore.youtubeReviewVideos[indexPath.item]
            destinationVC.youtubeID = cell.videoID
            destinationVC.modalPresentationStyle = .overCurrentContext
            destinationVC.modalTransitionStyle = .crossDissolve
            present(destinationVC, animated: true, completion: {
                print("youtube video player was displayed with ", cell.videoID)
            })
        default:
            let destinationVC = YouTubePlayerViewViewController()
            let cell = resultStore.youtubeTutorialVideos[indexPath.item]
            destinationVC.youtubeID = cell.videoID
            destinationVC.modalPresentationStyle = .overCurrentContext
            destinationVC.modalTransitionStyle = .crossDissolve
            present(destinationVC, animated: true, completion: {
                print("youtube video player was displayed with ", cell.videoID)
            })
        }
    }
    
    
    
}
