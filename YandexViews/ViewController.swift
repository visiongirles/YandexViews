//
//  ViewController.swift
//  YandexViews
//
//  Created by Maxim Sychenko on 19.07.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var triangle: UIImageView!
    @IBOutlet weak var shapeY: NSLayoutConstraint!
    @IBOutlet weak var shapeX: NSLayoutConstraint!
    @IBOutlet weak var gameFieldView: UIView!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBAction func stepperChanged(_ sender: UIStepper) {
        updateUI()
    }
    @IBAction func buttonChanged(_ sender: UIButton) {
        if gameIsActive {
            gameStop()
        } else {
            gameStart()
        }
    }
    @IBAction func triagnleTapped(_ sender: UITapGestureRecognizer) {
        guard gameIsActive else { return }
        repositionImage()
        score += 1
    }
    private var score = 0
    private var timeLeft: TimeInterval = 0
    private var gameTimer: Timer?
    private var timer: Timer?
    private var gameIsActive = false
    private let displayDuration: TimeInterval = 2
    
    private func repositionImage() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: displayDuration, target: self, selector: #selector(moveImage), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    private func gameStart() {
        score = 0
        repositionImage()
        gameTimer?.invalidate()
        gameTimer = Timer.scheduledTimer(
            timeInterval: 1, // как часто обновлять
            target: self, //объект у которого нужно вызвать функцию
            selector: #selector(gameTimeTicker), // чтобы вызвать функцию позже
            userInfo: nil, // доп инфа
            repeats: true)
        timeLeft = stepper.value
        gameIsActive = true
        updateUI()
    }
    private func gameStop() {
        gameTimer?.invalidate()
        timer?.invalidate()
        gameIsActive = false
        scoreLabel.text = "Последний счет: \(score)"
        updateUI()
    }
    
    @objc private func gameTimeTicker() {
        timeLeft -= 1
        if timeLeft <= 0 {
            gameStop()
        } else {
            updateUI()
        }
    }
    
    @objc private func moveImage() {
        let maxX = gameFieldView.bounds.maxX - triangle.frame.width
        let maxY = gameFieldView.bounds.maxY - triangle.frame.height
        shapeY.constant = CGFloat(arc4random_uniform(UInt32(maxX)))
        shapeX.constant = CGFloat(arc4random_uniform(UInt32(maxY)))
    }
    
    func updateUI() {
        triangle.isHidden = !gameIsActive
        stepper.isEnabled = !gameIsActive
        if gameIsActive {
            timeLabel.text = "Осталось: \(Int(timeLeft)) сек"
            startButton.setTitle("Остановить", for: .normal)
        } else {
            timeLabel.text = "Время: \(Int(stepper.value)) сек"
            startButton.setTitle("Начать", for: .normal)
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        gameFieldView.layer.borderWidth = 1
        gameFieldView.layer.borderColor = UIColor.gray.cgColor
        gameFieldView.layer.cornerRadius = 5
        updateUI()
    }
    
    
}

