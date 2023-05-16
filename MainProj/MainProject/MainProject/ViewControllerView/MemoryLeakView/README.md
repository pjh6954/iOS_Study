#  메모리 누수(Memory Leak)

Swift는 ARC(Auto Reference Counting)를 통해서 메모리를 관리하는데, 서로에 대해 강한참조(Strong Reference)를 하는 경우 Retain Cycle이 발생한다. 이로 인해 결과적으로 Reference Counting이 0이 되지 않아서 Deinit이 되지 않음. - 즉 메모리에 계속 남아있는 현상이 발생한다.(메모리에서 객체를 해제할 수 없는 상황)

이를 방지하기 위해서 객체간에 상호 참조를 하는 경우 weak, unowned 키워드를 통해서 약한참조를 사용한다.

(ARC관련 내용은 별도 정리 및 테스트)


## 1. 코드를 통한 확인

```swift
final class MemoryLeakViewController : UIViewController {
    // a, b 객체 순서 변경 테스트.
    private var a: ClassA? // 설명에서 a?
    private var b: ClassB? // 설명에서 b?
    override func viewDidLoad() {
        super.viewDidLoad()
        // print("Reference Counting A : \(CFGetRetainCount(a))")
        // print("Reference Counting B : \(CFGetRetainCount(b))")
        
        self.a = ClassA()
        self.b = ClassB()
        
        print("Reference Counting A 1 : \(CFGetRetainCount(a))")
        print("Reference Counting B 1 : \(CFGetRetainCount(b))")
        
        self.a?.b = b
        self.b?.a = a
        
        print("Reference Counting A 2 : \(CFGetRetainCount(a))")
        print("Reference Counting B 2 : \(CFGetRetainCount(b))")
    }
    // 아래는 공통 사용 코드
    deinit {
        print("Deinit in MemoryLeakViewController")
        
        print("Deinit Reference Counting A : \(CFGetRetainCount(a))")
        print("Deinit Reference Counting B : \(CFGetRetainCount(b))")
    }
    
}

// 아래는 공통 사용 코드
// Reference Cycle 테스트를 위한 `클래스` 정의
fileprivate class ClassA {
    var b: ClassB?
    
    init(b: ClassB? = nil) {
        print("Reference Counting A - self : \(CFGetRetainCount(self))")
        self.b = b
    }
    
    deinit {
        print("DEINIT in CLASS A : \(CFGetRetainCount(self))")
    }
}

fileprivate class ClassB {
    var a: ClassA?
    
    init(a: ClassA? = nil) {
        print("Reference Counting B - self : \(CFGetRetainCount(self))")
        self.a = a
    }
    
    deinit {
        print("DEINIT in CLASS B : \(CFGetRetainCount(self))")
    }
}
```

위 기본 코드에서는 Reference Cycle이 발생한다.
<img width="215" alt="image" src="https://user-images.githubusercontent.com/37360920/227129966-056c73ab-7237-4217-b6cc-b7b9e35b991d.png">
위 이미지처럼 서로를 참조하여 Reference Count를 체크하면 각각 3으로 체크가 된다.

설명하자면 a?의 b는 ClassB의 인스턴스인 b?를 참조하고, ClassB의 인스턴스인 b?의 a는 ClassA의 인스턴스인 a?를 참조하고 있는 상황이다.
서로를 참조하고 있는 상황에서 레퍼런스 카운트가 줄어들지 않기 때문에 할당 해제 되지 않아 메모리 누수가 발생하게 된다.

위 코드를 실행하면 다음의 print가 출력된다.
```
Reference Counting A - self : 2
Reference Counting B - self : 2
Reference Counting A 1 : 2
Reference Counting B 1 : 2
Reference Counting A 2 : 3
Reference Counting B 2 : 3
Deinit in MemoryLeakViewController
Deinit Reference Counting A : 3
Deinit Reference Counting B : 3
```
print된 내용을 보면 MemoryLeakViewController는 deinit이 호출되었지만, ClassA와 ClassB의 deinit은 호출되지 않은 것을 볼 수 있다.
서로 순환참조를 하기 때문에 그런 상황인데, 이 상황을 해결하기 위해서는 다음 방법을 사용 할 수 있겠다.

1. weak(약한참조)를 통한 순환참조 해결

ClassA의 b를 weak로 변경하면 다음과 같이 된다.
```
fileprivate class ClassA {
    weak var b: ClassB? // 변경
    
    init(b: ClassB? = nil) {
        print("Reference Counting A - self : \(CFGetRetainCount(self))")
        self.b = b
    }
    
    deinit {
        print("DEINIT in CLASS A : \(CFGetRetainCount(self))")
    }
}
```
이 때 앱을 실행하여 나온 print문을 확인하면 다음과 같다.
```
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
```
서로 강한 참조가 일어날 때와 달리 ClassB의 인스턴스인 b?의 reference count값이 2로 유지가 되는 것을 볼 수 있다.
즉, Reference count를 올리지 않는 상태로, 강한 참조가 실선이라고 한다면 약한 참조는 점선이라고 생각할 수 있다.


### References - Memory Leak, ARC
1. [1.](https://developer.apple.com/forums/thread/719957)
2. [2.](https://yeonduing.tistory.com/47)
3. [3.](https://developer.apple.com/forums/thread/119809)
4. [4.](https://stackoverflow.com/questions/61404517/swift-combine-sink-receivevalue-memory-leak)
5. [5.](https://seolhee2750.tistory.com/123)
6. [6.](https://sujinnaljin.medium.com/ios-arc-%EB%BF%8C%EC%8B%9C%EA%B8%B0-9b3e5dc23814)
7. [7.](https://silver-g-0114.tistory.com/149)
8. [8.](https://ios-development.tistory.com/604)
9. [9.](https://seizze.github.io/2019/12/20/iOS-%EB%A9%94%EB%AA%A8%EB%A6%AC-%EB%9C%AF%EC%96%B4%EB%B3%B4%EA%B8%B0,-%EB%A9%94%EB%AA%A8%EB%A6%AC-%EC%9D%B4%EC%8A%88-%EB%94%94%EB%B2%84%EA%B9%85%ED%95%98%EA%B8%B0,-%EB%A9%94%EB%AA%A8%EB%A6%AC-%EB%A6%AD-%EC%B0%BE%EA%B8%B0.html)
10. [10.](https://infinitt.tistory.com/403)
11. [11.](https://github.com/regi93/MemoryLeaks/tree/main/MemoryLeaksApp)
