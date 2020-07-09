//
//  PageViewController.swift
//  WeatherApp
//
//  Created by Vasilis Daningelis on 3/7/20.
//  Copyright © 2020 Vasilis Daningelis. All rights reserved.
//

import UIKit
import Lottie

class MainViewController: UIViewController, MainView, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    
    var configurator = MainConfiguratorImplementation()
    var presenter: MainPresenter!

    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var magnifierImageView: UIImageView!
    
    var emptyView: UIView?
    var pageController: UIPageViewController!
    
    let colors:[UIColor] = [.red, .green, .blue, .black, .white]

    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(mainViewController: self)
    
        topContainerView.layer.cornerRadius = 8
        topContainerView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        topContainerView.layer.masksToBounds = true
        
        magnifierImageView.image = UIImage(systemName: "magnifyingglass")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        view.bringSubviewToFront(topContainerView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        topContainerView.addGestureRecognizer(tap)
        
        self.view.backgroundColor = .systemTeal
        
        presenter.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.router.prepare(for: segue, sender: sender)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        presenter.addButtonPressed()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = presenter.loadedControllers.firstIndex(of: viewController as! CityViewController) {
            if index > 0 {
                return presenter.loadedControllers[index - 1]
            } else {
                return nil
            }
        }

        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        //Lazy load UIViewControllers when needed
        print("viewController = \(String(describing: (viewController as! CityViewController).city?.name))")
        if let index = presenter.loadedControllers.firstIndex(of: viewController as! CityViewController) {
            if index < presenter.numberOfCities - 1 {
                if index >= presenter.loadedControllers.count - 1  {
                    let cityViewController = presenter.loadNextCity()
                    return cityViewController
                }else{
                    
                    return presenter.loadedControllers[index + 1]
                    
                }
            } else {
                return nil
            }
        }
        return nil
    }
    // MARK: - MainView
    
    
    func displayCitiesRetrievalError(title: String, message: String) {
        presentAlert(withTitle: title, message: message)
    }
    
    func updateCityLabel(withCityName name: String){
        cityLabel.text = name
    }
    
    func loadNewAddedCity(cityName name: String) {
        cityLabel.text = name
        
        if presenter.loadedControllers.count == 1 {
            pageController.setViewControllers([presenter.loadedControllers[0]], direction: .forward, animated: false)
        }else{
            pageController.setViewControllers([presenter.loadedControllers.last!], direction: .forward, animated: true)
        }
        
    }
    
    func updatePageControllerAfterDeleting(deletedCityId: String) {
        
        if presenter.loadedControllers.count > 0 {
        
            //Rare case when you delete the city right after the current presented city
            // You should nil the dataSource to erase the viewControllerAfter
            self.pageController.dataSource = nil
            self.pageController.dataSource = self
            self.pageController.setViewControllers([self.presenter.loadedControllers[0]], direction: .forward, animated: true)
            presenter.loadCity(withIndex: 0)
            
        }else{
            showEmptyScreen()
        }
    }
    
    // MARK: - UIPageViewControllerDelegate
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed { return }

        let currentlyPresentedVC = pageViewController.viewControllers?.first

        if let index = presenter.loadedControllers.firstIndex(of: currentlyPresentedVC as! CityViewController) {
            presenter.loadCity(withIndex: index)
        }
    }
    
    func initiliazePageContoller() {
        
        emptyView?.removeFromSuperview()
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController.dataSource = self
        pageController.delegate = self

        addChild(pageController)
        view.addSubview(pageController.view)

        let views = ["pageController": pageController.view] as [String: AnyObject]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[pageController]|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[pageController]|", options: [], metrics: nil, views: views))
        
        pageController.setViewControllers([presenter.loadedControllers[0]], direction: .forward, animated: false)
        
        view.bringSubviewToFront(topContainerView)
    }
    
    func showEmptyScreen() {
        if pageController != nil {
            willMove(toParent: nil)
            pageController.view.removeFromSuperview()
            pageController.removeFromParent()

        }
        
        
        self.emptyView = UIView()
        emptyView!.translatesAutoresizingMaskIntoConstraints = false
        emptyView!.backgroundColor = .systemTeal

        view.addSubview(emptyView!)

        let emptyAnimationView = AnimationView()
        emptyAnimationView.backgroundColor = .clear
        emptyAnimationView.translatesAutoresizingMaskIntoConstraints = false
        emptyAnimationView.contentMode = .scaleAspectFill
        emptyAnimationView.backgroundBehavior = .pauseAndRestore
        emptyAnimationView.loopMode = .loop

        emptyAnimationView.animation = Animation.named("emptyView-animation2")
        emptyAnimationView.play()

        emptyView!.addSubview(emptyAnimationView)

        let views = ["emptyView": emptyView!] as [String: AnyObject]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[emptyView]|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[emptyView]|", options: [], metrics: nil, views: views))


        emptyAnimationView.centerXAnchor.constraint(equalTo: emptyView!.centerXAnchor).isActive = true
        emptyAnimationView.centerYAnchor.constraint(equalTo: emptyView!.centerYAnchor).isActive = true

        emptyAnimationView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        emptyAnimationView.heightAnchor.constraint(equalToConstant: 300).isActive = true

        view.bringSubviewToFront(topContainerView)

        cityLabel.text = "Add City"
        
    }

}
