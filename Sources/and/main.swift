import Foundation // Provides exit() function (and many others)

func usage() {
    print("Usage: and epochs learningRate")
    exit(-1)
}


if CommandLine.arguments.count != 3 {
    usage()
} else if let e = Int(CommandLine.arguments[1]), let lr = Float(CommandLine.arguments[2]) {
    train(epochs: e, learningRate: lr)
} else {
    usage()
}


func train(epochs: Int, learningRate: Float) {

    var model = Perceptron()
    let andGateData: [(x: SIMD2<Float>, y: Float)] = [
      (x: [0, 0], y: 0),
      (x: [0, 1], y: 0),
      (x: [1, 0], y: 0),
      (x: [1, 1], y: 1),
    ]
    for epoch in 0..<epochs {
        let (loss, 𝛁loss) = valueWithGradient(at: model) { model -> Float in
            var loss: Float = 0
            for (x, y) in andGateData {
                let ŷ = model(x)
                let error = y - ŷ
                loss = loss + error * error / 2
            }
            return loss
        }
        if epoch % 100 == 0 {
            print("\(epoch)\t\(loss)\t\(model(andGateData[0].x))\t\(model(andGateData[1].x))\t\(model(andGateData[2].x))\t\(model(andGateData[3].x))")
        }
        model.weight -= 𝛁loss.weight * learningRate
        model.bias -= 𝛁loss.bias * learningRate
    }

}
