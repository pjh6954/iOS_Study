//
//  MemoryLeakViewController.swift
//  MainProject
//
//  Created by JunHo Park on 2023/03/21.
//

import UIKit

final class MemoryLeakViewController : UIViewController {
    private var b: ClassB?
    private var a: ClassA?
    override func viewDidLoad() {
        super.viewDidLoad()
        // print("Reference Counting A : \(CFGetRetainCount(a))")
        // print("Reference Counting B : \(CFGetRetainCount(b))")
        
        self.a = ClassA()
        self.b = ClassB()
        
        print("Reference Counting A 1 : \(CFGetRetainCount(a))")
        print("Reference Counting B 1 : \(CFGetRetainCount(b))")
        
        self.b?.a = a
        self.a?.b = b
        
        print("Reference Counting A 2 : \(CFGetRetainCount(a))")
        print("Reference Counting B 2 : \(CFGetRetainCount(b))")
    }
    
    deinit {
        print("Deinit in MemoryLeakViewController")
        
        print("Deinit Reference Counting A : \(CFGetRetainCount(a))")
        print("Deinit Reference Counting B : \(CFGetRetainCount(b))")
    }
    
}

// Reference Cycle 테스트를 위한 `클래스` 정의
fileprivate class ClassA {
    weak var b: ClassB?
    
    init(b: ClassB? = nil) {
        print("Reference Counting A - self : \(CFGetRetainCount(self))")
        self.b = b
    }
    
    deinit {
        print("DEINIT in CLASS A : \(CFGetRetainCount(self))")
    }
}

fileprivate class ClassB {
    weak var a: ClassA?
    
    init(a: ClassA? = nil) {
        print("Reference Counting B - self : \(CFGetRetainCount(self))")
        self.a = a
    }
    
    deinit {
        print("DEINIT in CLASS B : \(CFGetRetainCount(self))")
    }
}

// weak를 ClassA의 b에 둘지, ClassB의 a에 둘지에 따라 deinit 되는 순서가 달라진다.
/*
 ex)
 ClassA의 b가 weak일 때 :
 Reference Counting A - self : 2
 Reference Counting B - self : 2
 Reference Counting A 1 : 2
 Reference Counting B 1 : 2
 Reference Counting A 2 : 3
 Reference Counting B 2 : 2
 Deinit in MemoryLeakViewController
 Deinit Reference Counting A : 3
 Deinit Reference Counting B : 2
 DEINIT in CLASS B : 2
 DEINIT in CLASS A : 2
 ---------------------------------
 ClassB의 a가 weak일 때 :
 Reference Counting A - self : 2
 Reference Counting B - self : 2
 Reference Counting A 1 : 2
 Reference Counting B 1 : 2
 Reference Counting A 2 : 2
 Reference Counting B 2 : 3
 Deinit in MemoryLeakViewController
 Deinit Reference Counting A : 2
 Deinit Reference Counting B : 3
 DEINIT in CLASS A : 2
 DEINIT in CLASS B : 2
 
 weak로 되어있는 Class가 deinit 되어 reference count가 줄어들면, 그 때 Strong으로 되어있는 객체가 해제 됨.
 
 둘 다 weak일 때 :
 Reference Counting A - self : 2
 Reference Counting B - self : 2
 Reference Counting A 1 : 2
 Reference Counting B 1 : 2
 Reference Counting A 2 : 2
 Reference Counting B 2 : 2
 Deinit in MemoryLeakViewController
 Deinit Reference Counting A : 2
 Deinit Reference Counting B : 2
 DEINIT in CLASS A : 2
 DEINIT in CLASS B : 2
 
 이 때는 가장 마지막의 DEINIT in ClASS A/B 호출 순서가 다음에 의해 정해진다.
 private var b: ClassB?
 private var a: ClassA?
 
 위 순서로 된 경우는
 DEINIT in CLASS B : 2
 DEINIT in CLASS A : 2
 순서로 호출됨.
 
 관련된 내용은 Heap, Stack 관련. 다음 링크 참조.
 https://shark-sea.kr/entry/iOS-Swift-%EB%A9%94%EB%AA%A8%EB%A6%AC%EC%9D%98-Stack%EA%B3%BC-Heap-%EC%98%81%EC%97%AD-%ED%86%BA%EC%95%84%EB%B3%B4%EA%B8%B0
*/


/*
// Reference Cycle 테스트를 위한 `Struct` 정의
// Value type 'StructA' cannot have a stored property that recursively contains it
// Value type 'StructB' cannot have a stored property that recursively contains it
// 이렇게 체크가 된다.
// https://stackoverflow.com/questions/53626802/struct-cannot-have-stored-property-that-references-itself-but-it-can-have-an-arr
fileprivate struct StructA {
    var b: StructB?
}

fileprivate struct StructB {
    var a: StructA?
}
*/
