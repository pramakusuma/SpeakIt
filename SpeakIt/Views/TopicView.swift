//
//  TopicView.swift
//  SpeakIt
//
//  Created by Prama Kusuma on 21/11/23.
//

import UIKit

class TopicView : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak private var lessonTitleLabel: UILabel!
    @IBOutlet weak private var allFilterButton: UIButton!
    @IBOutlet weak private var basicFilterButton: UIButton!
    @IBOutlet weak private var intermediateFilterButton: UIButton!

    @IBOutlet weak private var topicTableView: UITableView!
    
    private var lessonController = LessonController()
    private var topicData: [TopicModel]?
    private var filteredTopic: [TopicModel]?
    private var isFiltering = false
    var lessonId: String = ""
    private var topicIdClicked = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topicTableView.backgroundColor = UIColor.clear
        //Filter Button View
        filterButtonView()
        self.allFilterButton.layer.backgroundColor = #colorLiteral(red: 1, green: 0.7354277968, blue: 0.5653079152, alpha: 1)
        getAllTopic(lessonId: self.lessonId)
        getLessonDetail(lessonId: self.lessonId)
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTopicDetail" {
            let topicDetailView = segue.destination as! TopicDetailView
            topicDetailView.topicId = self.topicIdClicked
            topicDetailView.lessonId = self.lessonId
        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        print("Lessonid: \(self.lessonId)")
        goToHome()
    }   
    
    @IBAction func allFilterButton(_ sender: UIButton) {
        self.filterButtonView()
        sender.backgroundColor = #colorLiteral(red: 1, green: 0.7354277968, blue: 0.5653079152, alpha: 1)
        self.allFilterButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        
        //Show all topic
        filteredTopic = topicData
        self.topicTableView.reloadData()
    }
    
    @IBAction func basicFilterButton(_ sender: UIButton) {
        self.filterButtonView()
        sender.backgroundColor = #colorLiteral(red: 1, green: 0.7354277968, blue: 0.5653079152, alpha: 1)
        self.basicFilterButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        
        //Show basic topic
        filteredTopic = topicData?.filter {
            $0.difficulity.range(of: "Basic", options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        self.topicTableView.reloadData()
        
    }
    
    @IBAction func intermediateFilterButton(_ sender: UIButton) {
        self.filterButtonView()
        sender.backgroundColor = #colorLiteral(red: 1, green: 0.7354277968, blue: 0.5653079152, alpha: 1)
        self.intermediateFilterButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        
        //Show intermediate topic
        filteredTopic = topicData?.filter {
            $0.difficulity.range(of: "Intermediate", options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        self.topicTableView.reloadData()
    }
    
    func filterButtonView() {
        self.allFilterButton.layer.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        self.allFilterButton.configuration?.attributedTitle?.font = .systemFont(ofSize: 17, weight: .semibold)
        self.allFilterButton.titleLabel?.textColor = UIColor.black
        self.allFilterButton.layer.cornerRadius = 10
        self.basicFilterButton.layer.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        self.basicFilterButton.configuration?.attributedTitle?.font = .systemFont(ofSize: 17, weight: .semibold)
        self.basicFilterButton.titleLabel?.textColor = UIColor.black
        self.basicFilterButton.layer.cornerRadius = 10
        self.intermediateFilterButton.layer.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        self.intermediateFilterButton.configuration?.attributedTitle?.font = .systemFont(ofSize: 17, weight: .semibold)
        self.intermediateFilterButton.titleLabel?.textColor = UIColor.black
        self.intermediateFilterButton.layer.cornerRadius = 10
    }
    
    func goToHome() {
        performSegue(withIdentifier: "goToHome", sender: self)
    }
    
    func goToTopicDetail() {
        performSegue(withIdentifier: "goToTopicDetail", sender: self)
    }
    
    func getAllTopic(lessonId: String) {
        print("lesson id getalltopic: \(lessonId)")
        lessonController.getAllTopic(lessonId: lessonId) { (topicData) in
            self.createSpinnerView()
            self.topicData = topicData
            self.filteredTopic = topicData
            self.showTableViewCells()
            print("topic data get: \(String(describing: self.topicData))")
            print("topic data get id: \(lessonId)")
            
        }
//            self.showTableViewCells()
            
        print("dispatched")
        
    }
    
    func getLessonDetail(lessonId: String) {
        lessonController.getLessonDetail(lessonId: lessonId) { (lessonData) in
            let lessonData = lessonData
            self.lessonTitleLabel.text = lessonData.name
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundColor = UIColor.clear
        if let topicData = self.filteredTopic {
            print("topic data count: \(topicData.count)")
            return topicData.count
        } else {
            return 0
        }
//        return topicData?.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TopicTableViewCell") as? TopicTableViewCell {
            cell.backgroundColor = UIColor.clear
            cell.topicTitleLabel.text = self.filteredTopic![indexPath.row].name
            print("topic title label: \(cell.topicTitleLabel.text ?? "")")
            cell.topicDifficulityLabel.text = self.filteredTopic![indexPath.row].difficulity
            let imageURL = URL(string: self.filteredTopic![indexPath.row].imageURL)
            URLSession.shared.dataTask(with: imageURL!) { (data, respose, error) in
                guard let imageData = data else { return }
                DispatchQueue.main.async {
                    cell.topicImageView.image = UIImage(data: imageData)
                }
                
            }.resume()
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = tableView.cellForRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        self.topicIdClicked = filteredTopic![indexPath.row].id
        goToTopicDetail()
//        goToTopic(lessonId: lessonId)
    }
    
    func showTableViewCells() {
        self.topicTableView.dataSource = self
        self.topicTableView.delegate = self
        self.topicTableView.separatorColor = UIColor.clear
        self.registerTableViewCells()
        DispatchQueue.main.async {
            self.topicTableView.reloadData()
        }
        
    }
    
    func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "TopicTableViewCell", bundle: nil)
        self.topicTableView.register(textFieldCell, forCellReuseIdentifier: "TopicTableViewCell")
        self.topicTableView.reloadData()
    }
    
    func createSpinnerView() {
        let child = SpinnerView()
        
        print("Run Spinner")
        
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        self.topicTableView.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
            self.topicTableView.isHidden = false
        }
    }
    
}
