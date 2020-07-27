//
//  HeroDetailViewController.swift
//  DotaHero
//
//  Created by Herlambang Prasetyo on 27/07/20.
//  Copyright © 2020 Herlambang. All rights reserved.
//

import Foundation
import RxSwift

class HeroDetailViewController: UIViewController {

    @IBOutlet weak var rightContainerView: UIView!
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var heroNameLabel: UILabel!
    @IBOutlet weak var rolesLabel: UILabel!
    @IBOutlet weak var similiarHeroCollectionView: UICollectionView!
    @IBOutlet weak var attackAttributView: HeroInformationView!
    @IBOutlet weak var armorAttributeView: HeroInformationView!
    @IBOutlet weak var healthAttributeView: HeroInformationView!
    @IBOutlet weak var movementAttributeView: HeroInformationView!
    @IBOutlet weak var manaAttributeView: HeroInformationView!
    @IBOutlet weak var primaryAttackView: HeroInformationView!
    var heroDetailViewModel: HeroDetailViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        heroDetailViewModel.viewLoad()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = heroDetailViewModel.heroModel.localizedName
    }
    
    func setHeroModel(heroModel: Hero) {
        heroDetailViewModel.setHeroModel(heroModel: heroModel)
    }
    
    private func setupViewModel() {
        heroDetailViewModel.rxEventLoadHeroDetail
            .subscribe(onNext: { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.setupUI()
                weakSelf.setRolesUI()
            }).disposed(by: disposeBag)
        
        heroDetailViewModel.rxEventLoadSimiliarHero
            .subscribe(onNext: { [weak self] in
                self?.similiarHeroCollectionView.reloadData()
            }).disposed(by: disposeBag)
        
        heroDetailViewModel.rxEventOpenHeroDetailPage
            .subscribe(onNext: { [weak self] similiarHero in
                self?.openSimiliarHeroDetailPage(similiarHero: similiarHero)
            }).disposed(by: disposeBag)
    }
    
    private func openSimiliarHeroDetailPage(similiarHero: Hero) {
        guard let destinationViewController = storyboard?.instantiateViewController(identifier: "HeroDetailViewController") as? HeroDetailViewController else { return }
        destinationViewController.setHeroModel(heroModel: similiarHero)
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    private func setupUI() {
        let heroModel = heroDetailViewModel.heroModel
        heroImageView.loadUrl(Domain.baseUrl + heroModel.image)
        heroNameLabel.text = heroModel.localizedName
        
        attackAttributView.setupUI(value: "\(heroModel.baseAttackMax) - \(heroModel.baseAttackMin)", imageName: "sword")
        armorAttributeView.setupUI(value: "\(heroModel.baseArmor)", imageName: "shield")
        healthAttributeView.setupUI(value: "\(heroModel.baseHealth)", imageName: "blood")
        movementAttributeView.setupUI(value: "\(heroModel.movementSpeed)", imageName: "speed")
        manaAttributeView.setupUI(value: "\(heroModel.baseMana)", imageName: "potion")
        primaryAttackView.setupUI(value: "\(heroModel.primaryAttr)", imageName: "attack")
    }
    
    private func setRolesUI() {
        let roles = heroDetailViewModel.heroModel.roles.joined(separator: ", ")
        rolesLabel.text = roles
    }
    
    private func setupCollectionView() {
        similiarHeroCollectionView.register(HeroCardCollectionViewCell.nib(), forCellWithReuseIdentifier: HeroCardCollectionViewCell.cellReuseIdentifier())
    }
    
}

extension HeroDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return heroDetailViewModel.similiarHero.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroCardCollectionViewCell.cellReuseIdentifier(), for: indexPath) as? HeroCardCollectionViewCell else { return UICollectionViewCell() }
        let selectedHero = heroDetailViewModel.similiarHero[indexPath.row]
        cell.setupData(heroName: selectedHero.localizedName, heroImage: selectedHero.image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (rightContainerView.frame.width / 3) - 16
        return CGSize(width: width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        heroDetailViewModel.openHeroDetailPage(index: indexPath.row)
    }
}
