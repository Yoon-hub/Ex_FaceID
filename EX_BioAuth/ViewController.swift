//
//  ViewController.swift
//  EX_BioAuth
//
//  Created by 윤제 on 5/9/24.
//

import UIKit
import LocalAuthentication


class ViewController: UIViewController {
    
    let button: UIButton = {
       let view = UIButton()
        view.setTitle("생체인증 호출", for: .normal)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        button.addTarget(self, action: #selector(touchBioAuthButton), for: .touchUpInside)
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 100),
            button.heightAnchor.constraint(equalToConstant: 100)
        ])
        
    }
    
    func authenticateUser() {
        let context = LAContext()
        context.localizedFallbackTitle = ""
        var error: NSError?
        var error2: NSError?
        
        // 생체 인증 가능한지 확인
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // 생체 인증 실행
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "생체 인증을 사용하여 액세스 해주세요.") { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        // 생체 인증 성공
                        print("생체 인증 성공")
                    } else {
                        // 생체 인증 실패
                        if let error = authenticationError as? LAError {
                            // 생체 인증 에러 처리
                            switch error.code {
                            case .userCancel:
                                print("사용자가 취소했습니다.")
                            case .authenticationFailed:
                                print("생체 인증 실패")
                            case .userFallback:
                                print("비밀번호 입력")
                            default: // 4회시도 실패
                                print("다른 생체 인증 오류: \(error.localizedDescription)")
                               
                            }
                        }
                    }
                }
            }
        } else {
            // 생체 인증을 사용할 수 없는 경우
            if let error = error {
                print("생체 인증을 사용할 수 없습니다. 오류: \(error.localizedDescription)")
                // 생체인증 대신 os 비밀번호 입력 시나리오
                
            }
        }
    }

    
    @objc func touchBioAuthButton() {
        authenticateUser()
    }
}

