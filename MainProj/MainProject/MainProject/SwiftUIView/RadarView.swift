//
//  RadarView.swift
//  MainProject
//
//  Created by JunHo Park on 2023/02/27.
//

import SwiftUI
import SpriteKit
import GameplayKit
import CoreImage

// https://gist.github.com/ConfusedVorlon/00d87cdc3cf0eb8d726f98bfe29ee34b
//Morten Just
//https://twitter.com/mortenjust/status/1625804715228540929
struct RadarView: View {
    @State var go = false
    @State var goba = false

    func ang(_ s: [Gradient.Stop]) -> AngularGradient {
        AngularGradient(gradient: Gradient(stops: s), center: .center)
    }
    
    var body: some View {
        let c = Color(hue: 0.3, saturation: 1, brightness: 1)
        
        let noiseSource = GKPerlinNoiseSource(frequency: 1,
                                              octaveCount: 4,
                                              persistence: 2,
                                              lacunarity: 2,
                                              seed: 2)
        let texture = SKTexture(noiseMap: GKNoiseMap(GKNoise(noiseSource)))
        let per = Image(texture.cgImage(),
                        scale: 1,
                        label: Text("")).resizable()
        
        let randomImage = CIFilter.randomGenerator().outputImage!
        let rect = CGRect(origin: .zero, size: CGSize(width: 512, height: 512))
        let sizedImage = CIContext().createCGImage(randomImage,
                                                   from: rect)!
        let ran = Image(sizedImage,
                        scale: 1,
                        label:Text(""))
        
        ZStack {
            
            //radar
            Circle().fill(
                ang([.init(color: c, location: 0.03),
                     .init(color: .clear, location: 0.4)])
                .shadow(.inner(color: .black, radius: 10)))
            .rotationEffect(.degrees(go ? 0 : 360))
            .overlay(
                ZStack {
                    per
                        .blur(radius: 2)
                        .blendMode(.multiply)
                        .blendMode(.hue)
                        .animation(.linear(duration: 10).repeatForever(autoreverses: true), value: goba)

                    ang([
                        .init(color: c, location: 0.0),
                        .init(color: .clear, location: 0.5)
                    ])
                    .blendMode(.plusLighter)
                    .rotationEffect(.degrees(go ? 0 : 360))
                    .blendMode(.plusLighter)
                }
            )
            .mask(Circle())
        }
        .padding(10)
        .frame(maxWidth:.infinity)
        .background(.black)
        .onAppear(){
            goba = true
            go = true
        }
        .animation(.linear(duration: 10).repeatForever(autoreverses: false), value: go)
        .onDisappear {
            print("Disappear in RadarView")
        }
    }
}

struct RadarView_Previews: PreviewProvider {
    static var previews: some View {
        RadarView()
    }
}

extension CIFilter {
    static func randomGenerator() -> CIFilter {
        guard let filter = CIFilter(name: "CIRandomGenerator") else {
            fatalError()
        }
        filter.setDefaults()
        return filter
    }
}
