//
//  HeroListViewController.swift
//  DotaHero
//
//  Created by Herlambang Prasetyo on 25/07/20.
//  Copyright © 2020 Herlambang. All rights reserved.
//

import UIKit
import RxSwift

class HeroListViewController: UIViewController {

    @IBOutlet weak var heroListTableView: UITableView!
    @IBOutlet weak var heroCollectionView: UICollectionView!
    
    var heroListViewModel: HeroListViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heroListViewModel.viewLoad()
        setupTableView()
        setupCollectionView()
        setUpHeroListViewModel()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.NavigationIdentifier.openHeroDetailPage {
            guard let destinationViewController = segue.destination as? HeroDetailViewController, let heroModel = sender as? Hero else { return }
            destinationViewController.setHeroModel(heroModel: heroModel)
        }
    }
    
    private func setUpHeroListViewModel() {
        heroListViewModel.rxEventLoadHeroRoleList
            .subscribe(onNext: { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.heroListTableView.reloadData()
                weakSelf.initiateSelectedCategory()
            }).disposed(by: disposeBag)
        
        heroListViewModel.rxEventLoadHeroList
            .subscribe(onNext: { [weak self] heroList in
                guard let weakSelf = self else { return }
                weakSelf.heroCollectionView.reloadData()
                DispatchQueue.main.async {
                    weakSelf.heroCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
                }
            }).disposed(by: disposeBag)
        
        heroListViewModel.rxEventOpenHeroDetailPage
            .subscribe(onNext: { [weak self] hero in
                self?.performSegue(withIdentifier: Constant.NavigationIdentifier.openHeroDetailPage, sender: hero)
            }).disposed(by: disposeBag)
        
        heroListViewModel.rxEventShowAlert
            .subscribe(onNext: { [weak self] in
                self?.handleErrorRequest()
            }).disposed(by: disposeBag)
    }
    
    private func handleErrorRequest() {
        showAlertWithRetryButton(onClickCancelHandler: { [weak self] alert in
            self?.dismiss(animated: true, completion: nil)
            }, onClickRetryHandler: { [weak self] alertAction in
                self?.heroListViewModel.getHeroList()
        })
    }
    
    private func initiateSelectedCategory() {
        if heroListViewModel.isFirstLoad {
            let initiateIndex = IndexPath(row: 0, section: 0)
            heroListTableView.delegate?.tableView?(heroListTableView, didSelectRowAt: initiateIndex)
            heroListTableView.selectRow(at: initiateIndex, animated: true, scrollPosition: .top)
            heroListViewModel.isFirstLoad = false
        }
    }
    
    private func setupTableView() {
        heroListTableView.estimatedRowHeight = 30
        heroListTableView.rowHeight = UITableView.automaticDimension
        heroListTableView.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }

    private func setupCollectionView() {
        heroCollectionView.register(HeroCardCollectionViewCell.nib(), forCellWithReuseIdentifier: HeroCardCollectionViewCell.cellReuseIdentifier())
    }
        
    private func showAlertWithRetryButton(onClickCancelHandler: ((UIAlertAction) -> Void)? = nil, onClickRetryHandler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: Constant.Error.noInternetTitle, message: Constant.Error.noInternetMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Constant.Error.cancelButton, style: .cancel, handler: onClickCancelHandler))
        alertController.addAction(UIAlertAction(title: Constant.Error.retryButton, style: .default, handler: onClickRetryHandler))
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension HeroListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroListViewModel.heroCategoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryNameTableViewCell.cellReuseIdentifier()) as! CategoryNameTableViewCell
        cell.categoryNameLabel.text = heroListViewModel.heroCategoryList[indexPath.row]
        
        return cell
    }
            
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        heroListViewModel.didSelectHeroCategory(index: indexPath.row)
        self.title = heroListViewModel.heroCategoryList[indexPath.row]
    }
}

extension HeroListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return heroListViewModel.selectedHeroList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroCardCollectionViewCell.cellReuseIdentifier(), for: indexPath) as? HeroCardCollectionViewCell else { return UICollectionViewCell() }
        let selectedHero = heroListViewModel.selectedHeroList[indexPath.row]
        cell.setupData(heroName: selectedHero.localizedName, heroImage: selectedHero.image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 6, bottom: 12, right: 6)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        heroListViewModel.openHeroDetailPage(selectedHeroIndex: indexPath.row)
    }
    
}
