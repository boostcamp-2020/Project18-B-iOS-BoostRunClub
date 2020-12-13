//
//  DetailTotalView.swift
//  BoostRunClub
//
//  Created by 김신우 on 2020/12/12.
//

import UIKit

class DetailTotalView: UIView {
    private var distanceValueLabel = NikeLabel(with: 80)
    private var distancelabel = UILabel.makeNormal(text: "킬로미터")
    private var avgPaceValueLabel = UILabel.makeBold()
    private var avgPaceLabel = UILabel.makeNormal(text: "평균 페이스")
    private var runningTimeValueLabel = UILabel.makeBold()
    private var runningTimeLabel = UILabel.makeNormal(text: "시간")
    private var calorieValueLabel = UILabel.makeBold()
    private var calorieLabel = UILabel.makeNormal(text: "칼로리")
    private var elevationValueLabel = UILabel.makeBold()
    private var elevationLabel1 = UILabel.makeNormal(text: "고도")
    private var elevationLabel2 = UILabel.makeNormal(text: "상승")
    private var bpmValueLabel = UILabel.makeBold()
    private var bpmLabel1 = UILabel.makeNormal(text: "평균")
    private var bpmLabel2 = UILabel.makeNormal(text: "심박수")
    private var cadenceValueLabel = UILabel.makeBold()
    private var cadenceLabel = UILabel.makeNormal(text: "케이던스")

    private var distanceValue: Double = 0
    private var startTime: TimeInterval = 0
    private var displayLink: CADisplayLink?

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func configure(with config: ActivityDetailConfig) {
        distanceValue = config.distance
        avgPaceValueLabel.text = config.avgPace
        runningTimeValueLabel.text = config.runningTime
        calorieValueLabel.text = "\(config.calorie)"
        elevationValueLabel.text = "\(config.elevation)"
        bpmValueLabel.text = "\(config.avgBPM)"
        cadenceValueLabel.text = "\(config.cadence)"
        displayLink = CADisplayLink(target: self, selector: #selector(displayFrameUpdated))
    }

    func startAppear() {
        startTime = Date.timeIntervalSinceReferenceDate
        displayLink?.add(to: RunLoop.main, forMode: .default)
    }
}

// MARK: - Actions

extension DetailTotalView {
    @objc
    func displayFrameUpdated() {
        var elapsedTime = Date.timeIntervalSinceReferenceDate - startTime

        if elapsedTime > 2 {
            displayLink?.invalidate()
            elapsedTime = 2
        }

        let newValue = distanceValue * (elapsedTime / 2)
        distanceValueLabel.text = String(format: "%.2f", newValue / 1000)
    }
}

// MARK: - Configure

extension DetailTotalView {
    private func commonInit() {
        distanceValueLabel.text = "0.00"
        configureLayout()
    }

    // swiftlint:disable:next function_body_length
    private func configureLayout() {
        let distanceVStack = UIStackView.make(
            with: [distanceValueLabel, distancelabel],
            axis: .vertical, alignment: .leading, distribution: .fill
        )

        let avgPaceVStack = UIStackView.make(
            with: [avgPaceValueLabel, avgPaceLabel],
            axis: .vertical, alignment: .leading, distribution: .fill
        )

        let elevationVStack = UIStackView.make(
            with: [elevationValueLabel, elevationLabel1, elevationLabel2],
            axis: .vertical, alignment: .leading, distribution: .fill
        )

        let runningTimeVStack = UIStackView.make(
            with: [runningTimeValueLabel, runningTimeLabel],
            axis: .vertical, alignment: .leading, distribution: .fill
        )

        let bpmVStack = UIStackView.make(
            with: [bpmValueLabel, bpmLabel1, bpmLabel2],
            axis: .vertical, alignment: .leading, distribution: .fill
        )

        let calorieVStack = UIStackView.make(
            with: [calorieValueLabel, calorieLabel],
            axis: .vertical, alignment: .leading, distribution: .fill
        )

        let cadenceVStack = UIStackView.make(
            with: [cadenceValueLabel, cadenceLabel],
            axis: .vertical, alignment: .leading, distribution: .fill
        )

        let colVStacks = [
            UIStackView.make(
                with: [avgPaceVStack, elevationVStack],
                axis: .vertical, alignment: .leading, distribution: .fill, spacing: 10
            ),
            UIStackView.make(
                with: [runningTimeVStack, bpmVStack],
                axis: .vertical, alignment: .leading, distribution: .fill, spacing: 10
            ),
            UIStackView.make(
                with: [calorieVStack, cadenceVStack],
                axis: .vertical, alignment: .leading, distribution: .fill, spacing: 10
            ),
        ]

        let subDataHStack = UIStackView.make(
            with: colVStacks,
            axis: .horizontal, alignment: .leading, distribution: .fillEqually
        )

        let mainVStack = UIStackView.make(
            with: [distanceVStack, subDataHStack],
            axis: .vertical, alignment: .fill, distribution: .equalSpacing, spacing: 20
        )

        addSubview(mainVStack)
        mainVStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainVStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            mainVStack.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            mainVStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            mainVStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])
    }
}
