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
            }).disposed(by: disposeBag)
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
    }

    private func setupCollectionView() {
        heroCollectionView.register(HeroCardCollectionViewCell.nib(), forCellWithReuseIdentifier: HeroCardCollectionViewCell.cellReuseIdentifier())
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
        tableView.cellForRow(at: indexPath)?.backgroundColor = .blue
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.backgroundColor = .white
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
        cell.setupUI(heroName: selectedHero.localizedName, heroImage: selectedHero.image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
