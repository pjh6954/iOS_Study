//
//  ViewController.swift
//  ExceptionApp
//
//  Created by JunHo Park on 2023/08/23.
//

import UIKit
//import NSException.h
//import Foundation

enum TestError : Error {
    case TestExceptedError
}

class ViewController: UIViewController {

    @IBOutlet weak var btnException: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btnException.addTarget(self, action: #selector(actionBtnException(_:)), for: .touchUpInside)
        
//        NSSetUncaughtExceptionHandler { exception in
//            print(exception)
//            print(exception.callStackSymbols)
//        }
        
        
    }
    
    @objc private func actionBtnException(_ sender: UIButton) {
//        fatalError("TEST ERROR EXCEPTION?")
        
//        assert({
//            return false
//        }(), {
//            "TEST ASSERT MESSAGE"
//        }())
        
//        NSExceptionName.internalInconsistencyException
        
//        NSAssert(false, "Fatal test" as NSString)
        
        self.textLabel.text = ""
        
        let exception = NSException.init(name: .internalInconsistencyException, reason: "BLABLA")
        
        self.exceptionHandler(exception: exception)
        
        let array = NSArray()
        let elem = array.object(at: 99)
        
//        let arr = [1, 2, 3]
//        let elem2 = arr[4]
        
//        XCTAssertThrowsError(try functionThatThrows()) { error in
//            XCTAssertEqual(error as! TestError, TestError.TestExceptedError)
//        }
        
//        do {
//
//        } catch {
//
//        }
//        try! functionThatThrows()
    }
    
    func functionThatThrows() throws {
        throw TestError.TestExceptedError
    }
    
    func exceptionHandler(exception : NSException) {
        print(exception)
        print(exception.callStackSymbols)
    }
    
    @IBAction func test(_ sender: AnyObject) {
        
    }
}

extension ViewController : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
