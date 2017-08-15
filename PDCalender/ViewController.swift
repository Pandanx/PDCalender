//
//  ViewController.swift
//  PDCalender
//
//  Created by 张晓鑫 on 2017/7/24.
//  Copyright © 2017年 张晓鑫. All rights reserved.
//

import UIKit

let kScreenHeight = UIScreen.main.bounds.size.height
let kScreenWidth = UIScreen.main.bounds.size.width
let kHeightRation = kScreenHeight / 670.0
let kWidthRation = kScreenWidth / 375.0

let kButtonWidth: CGFloat = 80.0
let kButtonHeight: CGFloat = 40.0
let kHorizontailyPadding: CGFloat = 20.0
let kVerticalPading: CGFloat = 100.0

class ViewController: UIViewController {
    
    let calendarManager:CalandarManager = CalandarManager()
    var calenderCellColor: UIColor?
    var selectedCellColor: UIColor?
    var tadayCellColor: UIColor?
    var weekMode: Bool = false {
        didSet {
            let barItemTitle: String = weekMode ? String(format:"%li年%.2ld月第%ld周", calendarManager.year(date: self.date), calendarManager.month(date: self.date), calendarManager.weekOfMonth(date: date)) : String(format:"%li-%.2ld-%.2ld", calendarManager.year(date: self.date), calendarManager.month(date: self.date), calendarManager.day(date: self.date))
            self.navigationItem.leftBarButtonItem?.title = barItemTitle
            collectionView.reloadData()
            nextCollectionView.reloadData()
            lastCollectionView.reloadData()
        }
    }

    var lastMonthButton: UIButton!
    var nextMonthButton: UIButton!
    var calenderLabel: UILabel!
    var collectionView: UICollectionView!
    var nextCollectionView: UICollectionView!
    var lastCollectionView: UICollectionView!
    var scrollView: UIScrollView!
    var flagContent: CGPoint!
    
    var itemHeight: CGFloat = kScreenWidth / 7 - 5
    var itemWidth: CGFloat = kScreenWidth / 7 - 5
    
    var dateArray: Array<String> = ["日","一","二","三","四","五","六"]
    var currentDay: Int = 0
    var date: Date = Date() {
        didSet {
            let barItemTitle: String = weekMode ? String(format:"%li年%.2ld月第%ld周", calendarManager.year(date: self.date), calendarManager.month(date: self.date), calendarManager.weekOfMonth(date: date)) : String(format:"%li-%.2ld-%.2ld", calendarManager.year(date: self.date), calendarManager.month(date: self.date), calendarManager.day(date: self.date))
            self.navigationItem.leftBarButtonItem?.title = barItemTitle
            collectionView.reloadData()
            lastCollectionView.reloadData()
            nextCollectionView.reloadData()
        }
    }
    var monthCount: Int = 0
    var upViewY: CGFloat?
    let calenderIdentifier = "CalendarCell"
    let dateIdentifier = "DateCell"
    let leftBarButton: UIButton = UIButton()
    let animationController: CalenderAnimationCotroller = CalenderAnimationCotroller()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addViews()
        collectionView.register(CalendarCell.classForCoder(), forCellWithReuseIdentifier: calenderIdentifier)
        collectionView.register(DateCell.classForCoder(), forCellWithReuseIdentifier: dateIdentifier)
        nextCollectionView.register(CalendarCell.classForCoder(), forCellWithReuseIdentifier: calenderIdentifier)
        nextCollectionView.register(DateCell.classForCoder(), forCellWithReuseIdentifier: dateIdentifier)
        lastCollectionView.register(CalendarCell.classForCoder(), forCellWithReuseIdentifier: calenderIdentifier)
        lastCollectionView.register(DateCell.classForCoder(), forCellWithReuseIdentifier: dateIdentifier)
        currentDay = calendarManager.day(date: date)
        prepareNavigationBar()
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
        collectionView.reloadData()
    }
    func prepareNavigationBar() {
        let barItemTitle: String = weekMode ? String(format:"%li年%.2ld月第%ld周", calendarManager.year(date: self.date), calendarManager.month(date: self.date), calendarManager.weekOfMonth(date: date)) : String(format:"%li-%.2ld-%.2ld", calendarManager.year(date: self.date), calendarManager.month(date: self.date), calendarManager.day(date: self.date))
        let item = UIBarButtonItem(title: barItemTitle, style: UIBarButtonItemStyle.plain, target: self, action: #selector(leftItemBarAction(_:)))
        item.tintColor = UIColor.orange
        self.navigationItem.leftBarButtonItem=item
    }
    func addViews() {
        prepareScrollView()
    }
    
    func rightSwipeAction(_ sender: UISwipeGestureRecognizer) {
        UIView.transition(with: self.collectionView, duration: 0.5, options: .curveEaseInOut, animations: {
            self.date = self.calendarManager.lastMonth(date: self.date)
            self.navigationItem.leftBarButtonItem?.title = String(format: "%li-%.2ld-%.2ld", self.calendarManager.year(date: self.date), self.calendarManager.month(date: self.date), self.calendarManager.day(date: self.date))
            
        }, completion: nil)
        
    }
    func leftSwipeAction(_ sender: UISwipeGestureRecognizer) {
        UIView.transition(with: collectionView, duration: 0.5, options: .curveEaseInOut, animations: {
            self.date = self.calendarManager.nextMonth(date: self.date)
            self.navigationItem.leftBarButtonItem?.title = String(format: "%li-%.2ld-%.2ld", self.calendarManager.year(date: self.date), self.calendarManager.month(date: self.date), self.calendarManager.day(date: self.date))
            
        }, completion: nil)
    }
    
    func upSwipeAction(_ sender: UISwipeGestureRecognizer) {
        if !weekMode {
            weekMode = true
        }
    }
    
    func downSwipeAction(_ sender: UISwipeGestureRecognizer) {
        if weekMode {
            weekMode = false
        }
    }
    
    func leftItemBarAction(_ sender: UINavigationItem) {
        print(sender)
        _ = PDDatePickerPopView.showDatePicker( self.date, datePickerCallBack: { (pickerDate) in
            print("call Back")
            self.date = pickerDate!
        })
    }
    
    func nextMonthAction() {
        self.date = calendarManager.nextMonth(date: self.date)
        self.navigationItem.leftBarButtonItem?.title = String(format: "%li-%.2ld-%.2ld", calendarManager.year(date: self.date), calendarManager.month(date: self.date), calendarManager.day(date: self.date))
    }
    
    func lastMonthAction() {
        self.date = calendarManager.lastMonth(date: self.date)
        self.navigationItem.leftBarButtonItem?.title = String(format: "%li-%.2ld-%.2ld", calendarManager.year(date: self.date), calendarManager.month(date: self.date), calendarManager.day(date: self.date))
        
    }
    
    func nextWeekAction() {
        self.date = calendarManager.nextWeek(date: self.date)
        self.navigationItem.leftBarButtonItem?.title = String(format: "%li年%.2ld月第%ld周", calendarManager.year(date: self.date), calendarManager.month(date: self.date), calendarManager.weekOfMonth(date: date))
    }
    
    func lastWeekAction() {
        self.date = calendarManager.lastWeek(date: self.date)
        self.navigationItem.leftBarButtonItem?.title = String(format: "%li年%.2ld月%ld周", calendarManager.year(date: self.date), calendarManager.month(date: self.date), calendarManager.weekOfMonth(date: date))
    }
}
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: itemWidth, height: 20)
        } else {
            return CGSize(width: itemWidth, height: itemHeight)
        }
    }
    
    func prepareCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        let layoutNext = UICollectionViewFlowLayout()
        layoutNext.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layoutNext.minimumLineSpacing = 2
        layoutNext.minimumInteritemSpacing = 2
        let layoutLast = UICollectionViewFlowLayout()
        layoutLast.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layoutLast.minimumLineSpacing = 2
        layoutLast.minimumInteritemSpacing = 2
        
        lastCollectionView = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height:500), collectionViewLayout: layoutLast)
        collectionView = UICollectionView.init(frame:  CGRect(x: kScreenWidth, y: 0, width: kScreenWidth, height:500), collectionViewLayout: layout)
        nextCollectionView = UICollectionView.init(frame: CGRect(x: kScreenWidth*2, y: 0, width: kScreenWidth, height:500), collectionViewLayout: layoutNext)
        
        let downSwipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(downSwipeAction(_:)))
        downSwipe.direction = .down
        collectionView.addGestureRecognizer(downSwipe)
        
        let upSwipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(upSwipeAction(_:)))
        upSwipe.direction = .up
        collectionView.addGestureRecognizer(upSwipe)
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        scrollView.addSubview(collectionView)
        
        lastCollectionView.dataSource = self
        lastCollectionView.delegate = self
        scrollView.addSubview(lastCollectionView)
        
        nextCollectionView.dataSource = self
        nextCollectionView.delegate = self
        scrollView.addSubview(nextCollectionView)
        
        collectionView.backgroundColor = UIColor.white
        nextCollectionView.backgroundColor = UIColor.white
        lastCollectionView.backgroundColor = UIColor.white
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 7
        } else {
            
            let lastDate = calendarManager.lastMonth(date: date)
            let nextDate = calendarManager.nextMonth(date: date)
            var day: Int = 0
            if weekMode {
                return 7
            } else {
                if collectionView == lastCollectionView {
                    
                    let daysInThisMonth = calendarManager.totaldaysInThisMonth(date: lastDate)
                    let fisrtWeekDay = calendarManager.firstWeekdayInThisMoth(date: lastDate)
                    day = daysInThisMonth + fisrtWeekDay
                } else if collectionView == self.collectionView {
                    let daysInThisMonth = calendarManager.totaldaysInThisMonth(date: date)
                    let fisrtWeekDay = calendarManager.firstWeekdayInThisMoth(date: date)
                    day = daysInThisMonth + fisrtWeekDay
                } else if collectionView == nextCollectionView {
                    let daysInThisMonth = calendarManager.totaldaysInThisMonth(date: nextDate)
                    let fisrtWeekDay = calendarManager.firstWeekdayInThisMoth(date: nextDate)
                    day = daysInThisMonth + fisrtWeekDay
                }
                return day
            }
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let lastDate = calendarManager.lastMonth(date: date)
        let nextDate = calendarManager.nextMonth(date: date)
        let lastWeekDate = calendarManager.lastWeek(date: date)
        let nextWeekDate = calendarManager.nextWeek(date: date)

        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dateIdentifier, for: indexPath) as! DateCell
            cell.backgroundColor = UIColor.white
            cell.dateString = dateArray[indexPath.row];
            return cell
        } else {
            if collectionView == self.collectionView {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: calenderIdentifier, for: indexPath) as! CalendarCell
                if weekMode {
    
                    let weekday = calendarManager.weekday(date: date)
                    let flag = calendarManager.day(date: date) - weekday
                    var day: Int = 0
                    let i = indexPath.item
                    cell.backgroundColor = UIColor.white
                    if i == weekday {
                        if calendarManager.weekOfMonth(date: date) == calendarManager.weekOfMonth(date: Date()) {
                            cell.backgroundColor = UIColor.red
                        }
                    }
                    day = flag + i
                    
                    if day > 0 && day < calendarManager.totaldaysInThisMonth(date: date) {
                        cell.dateString = String(day)
                    }
                } else {
                    
                    let daysInThisMonth = calendarManager.totaldaysInThisMonth(date: date)
                    let firstWeekday = calendarManager.firstWeekdayInThisMoth(date: date)
                    var day: Int = 0
                    let i = indexPath.item
                    cell.backgroundColor = UIColor.white
                    if i < firstWeekday {
                        //                    cell.backgroundColor = UIColor.brown
                    } else if i > firstWeekday + daysInThisMonth - 1 {
                        //                    cell.backgroundColor = UIColor.red
                    } else {
                        print("CurrentDay = \(currentDay), FirstWeekDay = \(calendarManager.firstWeekdayInThisMoth(date: date))")
                        if i == currentDay + calendarManager.firstWeekdayInThisMoth(date: date) - 1 {
                            if calendarManager.month(date: date) == calendarManager.month(date: Date()) {
                                cell.backgroundColor = UIColor.red
                            }
                            
                        }
                        
                        day = i - firstWeekday + 1
                        cell.dateString = String(day)
                    }

                }
                return cell
            } else if collectionView == self.nextCollectionView {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: calenderIdentifier, for: indexPath) as! CalendarCell
                if weekMode {
                    let weekday = calendarManager.weekday(date: nextWeekDate)
                    let flag = calendarManager.day(date: nextWeekDate) - weekday
                    var day: Int = 0
                    let i = indexPath.item
                    cell.backgroundColor = UIColor.white
                    if i == weekday {

                        if calendarManager.weekOfMonth(date: nextWeekDate) == calendarManager.weekOfMonth(date: Date()) {
                            cell.backgroundColor = UIColor.red
                        }
                    }
                    day = flag + i
                    
                    if day > 0 && day < calendarManager.totaldaysInThisMonth(date: nextDate) {
                        cell.dateString = String(day)
                    }
                } else {
                    let daysInThisMonth = calendarManager.totaldaysInThisMonth(date: nextDate)
                    let firstWeekday = calendarManager.firstWeekdayInThisMoth(date: nextDate)
                    var day: Int = 0
                    let i = indexPath.item
                    cell.backgroundColor = UIColor.white
                    if i < firstWeekday {
                        
                    } else if i > firstWeekday + daysInThisMonth - 1 {
                        
                    } else {
                        day = i - firstWeekday + 1
                        cell.dateString = String(day)
                    }
                }
                return cell
            } else if collectionView == self.lastCollectionView {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: calenderIdentifier, for: indexPath) as! CalendarCell
                if weekMode {
                    let weekday = calendarManager.weekday(date: lastWeekDate)
                    let flag = calendarManager.day(date: lastWeekDate) - weekday
                    var day: Int = 0
                    let i = indexPath.item
                    cell.backgroundColor = UIColor.white
                    if i == weekday {
                        if calendarManager.weekOfMonth(date: lastWeekDate) == calendarManager.weekOfMonth(date: Date()) {
                            cell.backgroundColor = UIColor.red
                        }
                    }
                    day = flag + i

                    if day > 0 && day < calendarManager.totaldaysInThisMonth(date: lastDate) {
                        cell.dateString = String(day)
                    }
                } else {
                    
                    let daysInThisMonth = calendarManager.totaldaysInThisMonth(date: lastDate)
                    let firstWeekday = calendarManager.firstWeekdayInThisMoth(date: lastDate)
                    var day: Int = 0
                    let i = indexPath.item
                    cell.backgroundColor = UIColor.white
                    if i < firstWeekday {
                        
                    } else if i > firstWeekday + daysInThisMonth - 1 {
                        
                    } else {
                        day = i - firstWeekday + 1
                        cell.dateString = String(day)
                    }
                }
            
                return cell
            } else {
                return UICollectionViewCell()
            }
        
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}
extension ViewController: UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animationController.reverse = (operation == UINavigationControllerOperation.pop)
        animationController.upViewY = upViewY
        return animationController
    }
}
extension ViewController: UIGestureRecognizerDelegate {
    func tapGestureAction(_ gesture: UITapGestureRecognizer){
        let location = gesture.location(in: self.view)
        upViewY = location.y
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let testVC:TestViewController = storyboard.instantiateViewController(withIdentifier: "textViewController") as! TestViewController
        navigationController?.pushViewController(testVC, animated: true);
        
    }
}
extension ViewController: UIScrollViewDelegate {
    
    func prepareScrollView() {
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height:500))
        scrollView.backgroundColor = UIColor.white
        scrollView.contentSize = CGSize(width:kScreenWidth*3, height: 0)
        scrollView.delegate = self
        scrollView.isScrollEnabled = true
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentOffset = CGPoint(x:kScreenWidth, y: 0)
        self.view.addSubview(scrollView)
        
        prepareCollectionView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(_:)))
        tapGesture.delegate = self
        collectionView.addGestureRecognizer(tapGesture)
        
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("1111111")
        if scrollView.contentOffset.x == 2*kScreenWidth {
            print("Right Swipe")
            weekMode ? nextWeekAction() : nextMonthAction()
            
        }
        if scrollView.contentOffset.x == 0 {
            print("Left Swipe")
            weekMode ? lastWeekAction() : lastMonthAction()

        }
        self.scrollView.contentOffset = CGPoint(x: kScreenWidth , y:self.scrollView.contentOffset.y)
    }
}
