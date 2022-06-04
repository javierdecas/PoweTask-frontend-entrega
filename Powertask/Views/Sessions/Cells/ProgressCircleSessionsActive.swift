//
//  ProgressCircleSessionsActive.swift
//  Powertask
//
//  Created by Andrea Martinez Bartolome on 27/3/22.
//  Updated by Javier de castro on 03/05/2022
//

import SwiftUI
import Combine

public var numSessions: CGFloat = CGFloat(UserDefaults.standard.value(forKey: "sessionNumber") as! Int)
public var stepsLeft = numSessions
public var actualStatus: SessionStatus = .study
public var isRunning = true

let lineWithActive: CGFloat = 20
let radiusActive: CGFloat = 80

struct SessionActive: View {
    @State private var timeRemaining: CGFloat = CGFloat((UserDefaults.standard.value(forKey: "sessionTime") as! Int * 60))
    @State public var totalTime = CGFloat((UserDefaults.standard.value(forKey: "sessionTime") as! Int * 60))
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 25) {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), style: StrokeStyle(lineWidth: lineWith, lineCap: .round))
                Circle()
                    .trim(from: 0, to: 1 - ((totalTime - timeRemaining) / totalTime))
                    .stroke(timeRemaining > 6 ? Color.green : timeRemaining > 3 ? Color.yellow : Color.red, style: StrokeStyle(lineWidth: lineWith, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut)
                Text("\(String(format: "%02d", Int(timeRemaining/60))):\(String(format: "%02d", Int(timeRemaining.truncatingRemainder(dividingBy: 60))))").font(.system(size: 50, weight: .light, design: .default))
            }.frame(width: radius * 4, height: radius * 4)
        }.onReceive(timer, perform: { _ in
            guard isRunning else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                isRunning = false
                switchStatusOver(status: actualStatus)
            }
        })
        
        
    }
    
    /**
     * Función para determinar el siguiente estado y determinar los valores del temporizador en la siguiente fase usando el método pomodoro
     * - parameter status estado actual del temporizador una vez termina
     */
    func switchStatusOver(status: SessionStatus){

        // Se decide el siguiente estado
        if status == .study {
            if ceil(numSessions / 2) == stepsLeft {
                actualStatus = .longBreak
            }else if stepsLeft > 1 {
                actualStatus = .shortBreak
            }
            else {
                actualStatus = .shortBreak
            }
            stepsLeft -= 1
        }
        else if status == .shortBreak || status == .longBreak {
            if stepsLeft > 0 {
                actualStatus = .study
            }else{
                actualStatus = .finish
            }
        }else {
            actualStatus = .finish
        }
        
        // Se determina el tiempo de la siguiente sesión
        switch actualStatus{
            case .study:
                totalTime = CGFloat((UserDefaults.standard.value(forKey: "sessionTime") as! Int * 60))
            case .shortBreak:
                totalTime = CGFloat(UserDefaults.standard.value(forKey: "sessionShortBreak") as! Int * 60)
            case .longBreak:
                totalTime = CGFloat(UserDefaults.standard.value(forKey: "sessionLongBreak") as! Int * 60)
            case .finish:
                totalTime = 0
            case .paused:
                return
        }
        timeRemaining = totalTime
        return
    }
}

class SessionActive_Previews: ObservableObject {
    @Published var text: String

    init(text: String) {
        self.text = text
    }
}
