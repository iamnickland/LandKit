# LandKit

A description of this package.

tools


#### ABThemeGradientView

```
public class LKThemeGradientView: UIView {
    private(set) lazy var gradientLayer = {
        let gradientLayer = CAGradientLayer()
        let colors = [...]
        // 转换成 cgColor
        var cgColors = [CGColor]()
        for color in colors {
            cgColors.append(color.cgColor)
        }
        gradientLayer.colors = cgColors
        gradientLayer.startPoint = .init(x: 0, y: 0)
        gradientLayer.endPoint = .init(x: 1, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 60, height: 44)
        self.layer.insertSublayer(gradientLayer, at: 0)
        return gradientLayer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        // 设置背景颜色
        backgroundColor = .clear
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = CGRect(x: 0.0,
                                     y: 0.0,
                                     width: frame.width,
                                     height: frame.height)
    }
}

```
