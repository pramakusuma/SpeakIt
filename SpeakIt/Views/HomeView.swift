//
//  HomeView.swift
//  SpeakIt
//
//  Created by Prama Kusuma on 16/11/23.
//

import UIKit

class HomeView : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak private var progressBar: UIProgressView!
    @IBOutlet weak private var progressLabel: UILabel!
    
    @IBOutlet weak private var lessonTableView: UITableView!
    
//    private var progress = 0.3
    
    private let lessonController = LessonController()
    private let userController = UserController()
    private var lessonData: [LessonModel]?
    private var lessonIdClicked = ""
    private var totalProgress = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllLesson()
//        getCurrentProgress()
        lessonTableView.backgroundColor = UIColor.clear
        progressBar.transform.scaledBy(x: 1, y: 5)
        progressBar.layer.cornerRadius = 10
        
    
        
        
        //Tabel View
//        lessonTableView.register(LessonTableViewCell.self, forCellReuseIdentifier: "LessonTableViewCell")
//        self.lessonTableView.register(UINib(nibName: "LessonTableViewCell", bundle: nil), forCellReuseIdentifier: "LessonTableViewCell")

        print("lesson data self: \(String(describing: self.lessonData))")
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToTopic") {
            let topicView = segue.destination as! TopicView
            topicView.lessonId = self.lessonIdClicked
        }
    }
    
    @IBAction func profileButton(_ sender: UIButton) {
        goToProfile()
    }
    
    func goToProfile() {
        self.performSegue(withIdentifier: "goToProfile", sender: self)
    }
    
    func goToTopic() {
        self.performSegue(withIdentifier: "goToTopic", sender: self)
    }
    
    
    func getAllLesson() {
        lessonController.getAllLesson() {(lessonData) in
            self.createSpinnerView()
            //notify when data loaded
            self.lessonData = lessonData
            
            //Get Total Topic
            for data in lessonData {
                self.totalProgress += data.topicCount
            }
            
            self.getCurrentProgress()
            
            print("lesson data get: \(String(describing: self.lessonData))")
            self.showTabelViewCells()
        }

    }
    
    func getCurrentProgress() {
        userController.getCurrentUser { (uid, email, username, progress) in
            let currentProgress = Float(progress)/Float(self.totalProgress)
            print("Progress: \(progress) \nTotal Progress: \(self.totalProgress) \nCurrent Progress: \(currentProgress)")
            self.progressBar.progress = currentProgress
            self.progressLabel.text = ("\(Int(currentProgress * 100))%")
        }
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Get TopicCount from database
        tableView.backgroundColor = UIColor.clear
        if let lessonData = self.lessonData {
            print("lesson data count: \(lessonData.count)")
            return lessonData.count
        } else {
            return 0
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "LessonTableViewCell", for: indexPath) as? LessonTableViewCell {
            cell.backgroundColor = UIColor.clear
            cell.lessonTitleLabel.text = self.lessonData![indexPath.row].name
            print("lesson title label: \(cell.lessonTitleLabel.text ?? "")")
            cell.lessonTopicCountLabel.text = "\(String(describing: self.lessonData![indexPath.row].topicCount)) topics"
            //lesson image view
            let imageURL = URL(string: self.lessonData![indexPath.row].imageURL)
//            let data = try? Data(contentsOf: imageURL!)
            URLSession.shared.dataTask(with: imageURL!) { (data, respose, error) in
                guard let imageData = data else { return }
                DispatchQueue.main.async {
                    cell.lessonImageURL.image = UIImage(data: imageData)
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
        self.lessonIdClicked = lessonData![indexPath.row].id
        print("Lessonid row: \(self.lessonIdClicked)")
        goToTopic()
    }
    
    func showTabelViewCells() {
        self.lessonTableView.dataSource = self
        self.lessonTableView.delegate = self
        self.lessonTableView.separatorColor = UIColor.clear
        self.registerTableViewCells()
        DispatchQueue.main.async {
            self.lessonTableView.reloadData()
        }
    }
    
    
    func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "LessonTableViewCell", bundle: nil)
        self.lessonTableView.register(textFieldCell, forCellReuseIdentifier: "LessonTableViewCell")
    }
    
    func createSpinnerView() {
        let child = SpinnerView()
        
        print("Run Spinner")
        
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        self.lessonTableView.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
            self.lessonTableView.isHidden = false
        }
    }
    

}
