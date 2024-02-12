//
//  TouchView.swift
//  Haptics
//
//  Created by yc on 2/12/24.
//

import UIKit

class TouchView: UIView {
    var isOnRecord = false
    
    var waitStartDate: Date?
    var waitEndDate: Date?
    var tapStartDate: Date?
    var tapEndDate: Date?
    
    var recordResultArr = [Haptic]()
    
    var tapView: UIView?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard isOnRecord else { return }
        
        let vp = touches.first?.location(in: self)
        
        showAndHideTapView(isShow: true, vp: vp)
        
        // wait time 가공
        calcWaitTime()
        
        tapStartDate = .now
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        guard isOnRecord else { return }
        
        showAndHideTapView(isShow: false)
        
        // Tap time 가공
        calcTapTime()
        
        waitStartDate = .now
    }
    
    func startRecording() {
        isOnRecord = true
        recordResultArr = []
        waitStartDate = .now
    }
    
    func stopRecording() {
        isOnRecord = false
        
        calcWaitTime()
    }
    
    func getResult() -> [Haptic] {
        return recordResultArr
    }
    
    func calcWaitTime() {
        waitEndDate = .now
        
        guard let waitStartDate = waitStartDate,
              let waitEndDate = waitEndDate else {
            return
        }
              
        let waitTime = waitEndDate.millisecondsSince1970 - waitStartDate.millisecondsSince1970
        let waitTimeSec = Double(waitTime) / 1000.0
        print(waitTimeSec)
        
        let haptic = Haptic(type: .wait, duration: waitTimeSec)
        
        recordResultArr.append(haptic)
    }
    
    func calcTapTime() {
        tapEndDate = .now
        
        guard let tapStartDate = tapStartDate,
              let tapEndDate = tapEndDate else {
            return
        }
              
        let tapTime = tapEndDate.millisecondsSince1970 - tapStartDate.millisecondsSince1970
        let tapTimeSec = Double(tapTime) / 1000.0
        print(tapTimeSec)
        
        let haptic = Haptic(type: .ring, duration: tapTimeSec)
        
        recordResultArr.append(haptic)
    }
    
    func showAndHideTapView(isShow: Bool, vp: CGPoint? = nil) {
        if isShow {
            let vp = vp ?? .zero
            
            tapView = UIView()
            
            tapView?.backgroundColor = .systemPink
            tapView?.frame = CGRect(
                origin: CGPoint(x: vp.x - 40, y: vp.y - 40),
                size: CGSize(width: 80, height: 80)
            )
            tapView?.layer.cornerRadius = 40
            
            addSubview(tapView!)
        } else {
            tapView?.removeFromSuperview()
            tapView = nil
        }
    }
}

extension Date {
    var millisecondsSince1970: Int {
        Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
