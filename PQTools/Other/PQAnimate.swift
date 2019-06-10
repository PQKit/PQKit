
import UIKit

public enum PQAnimateType: String {
    case rotation = "transform.rotation"
    case rotationX = "transform.rotation.x"
    case rotationY = "transform.rotation.y"
    case rotationZ = "transform.rotation.z"
    case scale = "transform.scale"
    case scaleX = "transform.scale.x"
    case scaley = "transform.scale.y"
    case scalez = "transform.scale.z"
    case translation = "transform.translation"
    case translationX = "transform.translation.x"
    case translationY = "transform.translation.y"
    case translationZ = "transform.translation.z"
    case shadowOpaicy = "shadowOpaicy"
    case shadowRadius = "shadowRadius"
    case shadowOffset = "shadowOffset"
    case shadowColor = "shadowColor"
    case position = "position"
    case positionX = "position.x"
    case positionY = "position.y"
    case origin = "origin"
    case originX = "origin.x"
    case originY = "origin.y"
    case size = "size"
    case sizeX = "size.x"
    case sizeY = "size.y"
    case opacity = "opacity"
    case backgroundColor = "backgroundColor"
    case cornerRadius = "cornerRadius"
    case borderWidth = "borderWidth"
    case borderColor = "borderColor"
    case contents = "contents"
}

public class PQAnimate: NSObject {
    
    /// 快速创建一个动画
    ///
    /// - Parameters:
    ///   - type: 执行类型
    ///   - fromValue: 起始值
    ///   - toValue: 结束值
    ///   - byValue: 当前的值
    ///   - duration: 时间
    ///   - repeatCount: 重复次数 default  0
    ///   - repeatDuration: 重复时间 default 0
    ///   - timingFunction: 运行效果选择（贝塞尔曲线） default linear
    ///   - fillMode: 填充模式 default .forwards
    ///   - autoreverses: 是否反转运行动画 default false
    ///   - isRemovedOnCompletion: 是否移除完成效果 需要配合 fillMode 使用
    /// - Returns: a动画
    public class func baseAnimationWithKeyType(
        type : PQAnimateType ,
        fromValue : Any? ,
        toValue : Any?,
        byValue: Any?,
        duration : CFTimeInterval,
        beginTime: Double,
        repeatCount : Float = 0 ,
        repeatDuration: Float = 0,
        timingFunction : CAMediaTimingFunctionName = .linear,
        fillMode: CAMediaTimingFillMode = .forwards,
        autoreverses: Bool = false,
        isRemovedOnCompletion: Bool = false) -> CABasicAnimation {
        
        let animate = CABasicAnimation(keyPath: type.rawValue)
        //起始值
        animate.fromValue = fromValue;
        
        //变成什么，或者说到哪个值
        animate.toValue = toValue
        
        //所改变属性的起始改变量 比如旋转360°，如果该值设置成为0.5 那么动画就从180°开始
        animate.byValue = byValue
        
        //动画结束是否停留在动画结束的位置
        animate.isRemovedOnCompletion = isRemovedOnCompletion
        
        //动画时长
        animate.duration = duration
        
        //重复次数 Float.infinity 一直重复 OC：HUGE_VALF
        animate.repeatCount = repeatCount
        
        //设置动画在该时间内重复
        animate.repeatDuration = 5
        
        //延时动画开始时间，使用CACurrentMediaTime() + 秒(s)
        animate.beginTime = CACurrentMediaTime() + beginTime;
        
        //设置动画的速度变化
        /*
         kCAMediaTimingFunctionLinear: String        匀速
         kCAMediaTimingFunctionEaseIn: String        先慢后快
         kCAMediaTimingFunctionEaseOut: String       先快后慢
         kCAMediaTimingFunctionEaseInEaseOut: String 两头慢，中间快
         kCAMediaTimingFunctionDefault: String       默认效果和上面一个效果极为类似，不易区分
         */
        
        animate.timingFunction = CAMediaTimingFunction(name: timingFunction)
        
        
        //动画在开始和结束的时候的动作
        /*
         kCAFillModeForwards    保持在最后一帧，如果想保持在最后一帧，那么isRemovedOnCompletion应该设置为false
         kCAFillModeBackwards   将会立即执行第一帧，无论是否设置了beginTime属性
         kCAFillModeBoth        该值是上面两者的组合状态
         kCAFillModeRemoved     默认状态，会恢复原状
         */
        animate.fillMode = fillMode
        
        //动画结束时，是否执行逆向动画
        animate.autoreverses = autoreverses
        
        return animate
    }
    
    public class func baseAnimationWithKeyPath(
        _ path : String ,
        fromValue : Any? ,
        toValue : Any?,
        duration : CFTimeInterval,
        repeatCount : Float? ,
        timingFunction : String?) -> CABasicAnimation{
        
        let animate = CABasicAnimation(keyPath: path)
        //起始值
        animate.fromValue = fromValue;
        
        //变成什么，或者说到哪个值
        animate.toValue = toValue
        
        //所改变属性的起始改变量 比如旋转360°，如果该值设置成为0.5 那么动画就从180°开始
        //        animate.byValue =
        
        //动画结束是否停留在动画结束的位置
        //        animate.isRemovedOnCompletion = false
        
        //动画时长
        animate.duration = duration
        
        //重复次数 Float.infinity 一直重复 OC：HUGE_VALF
        animate.repeatCount = repeatCount ?? 0
        
        //设置动画在该时间内重复
        //        animate.repeatDuration = 5
        
        //延时动画开始时间，使用CACurrentMediaTime() + 秒(s)
        //        animate.beginTime = CACurrentMediaTime() + 2;
        
        //设置动画的速度变化
        /*
         kCAMediaTimingFunctionLinear: String        匀速
         kCAMediaTimingFunctionEaseIn: String        先慢后快
         kCAMediaTimingFunctionEaseOut: String       先快后慢
         kCAMediaTimingFunctionEaseInEaseOut: String 两头慢，中间快
         kCAMediaTimingFunctionDefault: String       默认效果和上面一个效果极为类似，不易区分
         */
        
        animate.timingFunction = CAMediaTimingFunction(name: timingFunction.map { CAMediaTimingFunctionName(rawValue: $0) } ?? CAMediaTimingFunctionName.easeInEaseOut)
        
        
        //动画在开始和结束的时候的动作
        /*
         kCAFillModeForwards    保持在最后一帧，如果想保持在最后一帧，那么isRemovedOnCompletion应该设置为false
         kCAFillModeBackwards   将会立即执行第一帧，无论是否设置了beginTime属性
         kCAFillModeBoth        该值是上面两者的组合状态
         kCAFillModeRemoved     默认状态，会恢复原状
         */
        animate.fillMode = CAMediaTimingFillMode.both
        
        //动画结束时，是否执行逆向动画
        //        animate.autoreverses = true
        
        return animate
        
    }
    
    public class func keyFrameAnimationWithKeyPath(_ keyPath : String , values : [Any]? , keyTimes : [NSNumber]? , path : CGPath? , duration : CFTimeInterval , cacluationMode : String , rotationMode : String?) -> CAKeyframeAnimation{
        
        let keyFrame = CAKeyframeAnimation(keyPath: keyPath)
        
        //由关键帧（关键值），通过关键帧对应的值执行动画
        keyFrame.values = values
        
        //当设置了path之后，values就没有效果了
        keyFrame.path = path
        
        //计算模式
        /*
         `discrete', 离散的，不进行插值运算
         `linear',   线性插值
         `paced',    节奏动画，自动计算动画的运动时间，是的动画均匀运行，而不是根据keyTimes的值进行动画，设置这个模式keyTimes和timingFunctions无效
         `cubic'      对关键帧为坐标点的关键帧进行圆滑曲线相连后插值计算，需要设置timingFunctions。还可以通过tensionValues，continueityValues，biasValues来进行调整自定义
         `cubicPaced' 结合了paced和cubic动画效果
         */
        keyFrame.calculationMode = CAAnimationCalculationMode(rawValue: cacluationMode)
        
        //旋转模式
        /*
         `auto' = kCAAnimationRotateAuto                根据路径自动旋转
         `autoReverse' = kCAAnimationRotateAutoReverse  根据路径自动翻转
         */
        keyFrame.rotationMode = rotationMode.map { CAAnimationRotationMode(rawValue: $0) }
        
        /*
         用来区分动画的分割时机。值区间为0.0 ~ 1.0 ，数组中的后一个值比前一个大或者相等，最好的是和Values或者Path控制的值对应
         这个属性只在 calculationMode = linear/discrete/cubic是被使用
         */
        keyFrame.keyTimes = keyTimes
        
        //动画时长
        keyFrame.duration = duration
        
        return keyFrame
        
    }
    
    public class func transitionAnimationWith(duration : CFTimeInterval, type : String , subtype : String? , startProgress : Float , endProgress : Float) -> CATransition{
        let transitionAni = CATransition()
        
        //转场类型
        transitionAni.type = CATransitionType(rawValue: type)
        
        /*
         kCATransitionFromTop       从顶部转场
         kCATransitionFromBottom    从底部转场
         kCATransitionFromLeft      从左边转场
         kCATransitionFromRight     从右边转场
         */
        transitionAni.subtype = subtype.map { CATransitionSubtype(rawValue: $0) } ?? CATransitionSubtype.fromLeft
        
        //动画开始的进度
        transitionAni.startProgress = startProgress
        
        //动画结束的进度
        transitionAni.endProgress = endProgress
        
        //动画的时间
        transitionAni.duration = duration
        
        return transitionAni
    }
    
    public class func springAnimationWithPath(_ path : String , mass : CGFloat , stiffness : CGFloat , damping : CGFloat , fromValue : Any? , toValue : Any) -> CASpringAnimation{
        let springAni = CASpringAnimation(keyPath: path)
        
        //质量：影响图层运动时的弹簧惯性，质量越大，弹簧的拉伸和压缩的幅度越大，动画的速度变慢，且波动幅度变大
        springAni.mass = mass
        
        //刚度：越大动画越快
        springAni.stiffness = stiffness
        
        //阻尼：越大停止越快
        springAni.damping = damping
        
        //初始速率
        springAni.initialVelocity = 0
        
        //初始值
        springAni.fromValue = fromValue
        
        //结束值
        springAni.toValue = toValue
        
        //        print("动画停止预估时间" + "\(springAni.settlingDuration)")
        
        springAni.duration = springAni.settlingDuration
        
        return springAni
    }
}

/*
 CATransform3D Key Paths : (example)transform.rotation.z
 rotation.x
 rotation.y
 rotation.z
 rotation
 scale.x
 scale.y
 scale.z
 scale
 translation.x
 translation.y
 translation.z
 translation
 CGPoint Key Paths : (example)position.x
 x
 y
 CGRect Key Paths : (example)bounds.size.width
 origin.x
 origin.y
 origin
 size.width
 size.height
 size
 opacity
 backgroundColor
 cornerRadius
 borderWidth
 contents
 Shadow Key Path:
 shadowColor
 shadowOffset
 shadowOpacity
 shadowRadius
 */

