//
//  SwiftUIExampleRootView.swift
//  MainProject
//
//  Created by JunHo Park on 2023/02/27.
//

import SwiftUI
import UIKit

struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}

enum ViewName: String {
    case TestView = "TestView"
    case MVVMExmaple = "MVVMExmaple"
    case MVVMObservedObjectExample = "MVVMObservedObjectExample"
    case ObservedObjectExample = "ObservedObjectExample"
    case RadarView = "RadarView"
}

// Identifiable 안넣으면 List(data.vcs) 할 경우, "Initializer 'init(_:rowContent:)' requires that 'VCModel' conform to 'Identifiable'" 발생.
struct VCModel: Identifiable {
    let id = UUID()
    let title: String
    let vcType: UIViewController.Type?
    let swiftUIview: ViewName?
}

struct VCListModel {
    let vcs : [VCModel] = [
        // VCModel(title: "Convert UIKit View Controller", vcType: ConvertUIKitViewController.self, swiftUIview: nil),
        // VCModel(title: "MVVM Example SwiftUI(name change)", vcType: nil, swiftUIview: .MVVMExmaple),
        // VCModel(title: "MVVM Observed Object Example(Count)", vcType: nil, swiftUIview: .MVVMObservedObjectExample),
        // VCModel(title: "Observed Object View Example(Timer)", vcType: nil, swiftUIview: .ObservedObjectExample)
        .init(title: "Radar View", vcType: nil, swiftUIview: .RadarView)
    ]
}

struct SwiftUIExampleRootView: View {
    weak var navigationController: UINavigationController?
    let data = VCListModel()
    var body: some View {
        // Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        // self.navigationTitle("TEST001")
        NavigationView {
            List(data.vcs) { element in
                let cell = SwiftListCellView(vcModel: element)
                var vc: UIViewController? = nil
                // var view: ViewName? = nil
                
                if let navi = navigationController {
                    cell.onTapGesture {
                        print("element? \(element.vcType)")
                        if let vcType = element.vcType {
                            let str = String(describing: vcType)
                            print("STR : \(str)")
                            if vcType == ConvertUIKitViewController.self {
                                vc = UIStoryboard(name: "SwiftUInUIKitConvertViewController", bundle: nil).instantiateViewController(withIdentifier: str) as? ConvertUIKitViewController
                            } else {
                                
                            }
                            print("BREAKER")
                        } else if let swiftUIview = element.swiftUIview {
                            switch swiftUIview {
                            case .TestView:
                                // let hostingViewController = UIHostingController(rootView: view)
                                break
                            case .MVVMExmaple:
                                /*
                                let view = MVVMExampleView()
                                let hostingView = UIHostingController(rootView: LazyView(view))
                                vc = hostingView
                                */
                                break
                            case .MVVMObservedObjectExample:
                                /*
                                let view = MVVMObservedObjectView()
                                vc = UIHostingController(rootView: LazyView(view))
                                */
                                break
                            case .ObservedObjectExample:
                                /*
                                let view = ObservedObjectView()
                                vc = UIHostingController(rootView: LazyView(view))
                                */
                                break
                            case .RadarView:
                                let view = RadarView()
                                vc = UIHostingController(rootView: LazyView(view))
                            }
                        }
                        guard let vc = vc else { return }
                        print("VC : \(vc)")
                        
                        navi.pushViewController(viewController: vc, animated: true) {
                            
                        }
                    }
                } else {
                    // https://stackoverflow.com/questions/68368791/why-is-my-navigationlink-not-working-i-get-this-error-result-of-navigationl
                    /*
                    NavigationLink(destination: NewConvertUIKitViewController()) {
                        Text("VCTest")
                    }
                    */
                    
                }
                
            }
        }
        /*
        // working code
        // https://sarunw.com/posts/custom-navigation-bar-title-view-in-swiftui/
        .navigationBarTitleDisplayMode(.automatic)
        .toolbar {
            ToolbarItem.init(placement: .principal) {
                VStack {
                    Text("Title").font(.headline)
                    Text("Subtitle").font(.subheadline)
                }
            }
        }
        */
    }
}

struct SwiftListCellView: View {
    let vcModel: VCModel
    
    var body: some View {
        Text(vcModel.title)
    }
}

struct SwiftUIExampleRootView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIExampleRootView()
    }
}

// SwiftUI -> UIKit(not navigation controller using) : https://stackoverflow.com/questions/63784668/how-to-push-to-uiviewcontroller-from-swiftui-view-that-is-in-navigationcontrolle
struct NewConvertUIKitViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ConvertUIKitViewController {
        var sb = UIStoryboard(name: "SwiftUInUIKitConvertViewController", bundle: nil)
        var vc = sb.instantiateViewController(identifier: "ConvertUIKitViewController") as! ConvertUIKitViewController
        return vc
    }
    
    func updateUIViewController(_ uiViewController: ConvertUIKitViewController, context: Context) {
    }
    
    typealias UIViewControllerType = ConvertUIKitViewController
}


class ConvertUIKitViewController: UIViewController {
    // https://exception-log.tistory.com/158
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "test convertUIKit view"
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
