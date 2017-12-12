

//
//  CustomView.m
//  BezierPathDemo
//
//  Created by LHL on 2017/12/12.
//  Copyright © 2017年 SVP. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.redView = [[UIView alloc] initWithFrame:CGRectMake(20, 100, 200, 200)];
        [self addSubview:self.redView];
        
        [self layerKeyFrameAnimation];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.redView = [[UIView alloc] initWithFrame:CGRectMake(20, 100, 20, 20)];
    self.redView.backgroundColor = [UIColor redColor];
    [self addSubview:self.redView];
    
    [self createTest12];

}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    UIColor *color = [UIColor redColor];
    [color set];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(100, 200)];
    path.lineWidth = 3;
    path.lineJoinStyle = kCGLineJoinRound;
    path.lineCapStyle = kCGLineCapRound;
    [path addCurveToPoint:CGPointMake(400, 200) controlPoint1:CGPointMake(200, 0) controlPoint2:CGPointMake(300, 400)];
    [path stroke];

}

// 贝塞尔曲线动画
- (void)createTest12{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(100, 200)];
    [path addCurveToPoint:CGPointMake(400, 200) controlPoint1:CGPointMake(200, 0) controlPoint2:CGPointMake(300, 400)];
    
    CAKeyframeAnimation *keyFA = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyFA.duration = 8;
    keyFA.repeatCount = 10;
    keyFA.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    keyFA.path = path.CGPath;
    keyFA.calculationMode = kCAAnimationPaced;
    //旋转的模式,auto就是沿着切线方向动，autoReverse就是转180度沿着切线动
    keyFA.rotationMode = kCAAnimationRotateAuto;
    //结束后是否移除动画
    keyFA.removedOnCompletion = NO;
    
    //添加动画
    [self.redView.layer addAnimation:keyFA forKey:@""];
}

//关键帧动画
-(void)layerKeyFrameAnimation
{
    //画一个path
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:CGPointMake(-40, 100)];
//    [path addLineToPoint:CGPointMake(360, 100)];
//    [path addLineToPoint:CGPointMake(360, 200)];
//    [path addLineToPoint:CGPointMake(-40, 200)];
//    [path addLineToPoint:CGPointMake(-40, 300)];
//    [path addLineToPoint:CGPointMake(360, 300)];
    
    //几个固定点
    NSValue *orginalValue = [NSValue valueWithCGPoint:self.redView.layer.position];
    NSValue *value_1 = [NSValue valueWithCGPoint:CGPointMake(300, 300)];
    NSValue *value_2 = [NSValue valueWithCGPoint:CGPointMake(500, 300)];
    NSValue *value_3 = [NSValue valueWithCGPoint:CGPointMake(100, 400)];
    NSValue *value_4 = orginalValue;

    //变动的属性,keyPath后面跟的属性是CALayer的属性
    CAKeyframeAnimation *keyFA = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    //value数组，放所有位置信息，如果设置path，此项会被忽略
    keyFA.values = @[orginalValue,value_1,value_2,value_3,value_4];
    //动画路径
    //    keyFA.path = path.CGPath;
    //该属性是一个数组，用以指定每个子路径(AB,BC,CD)的时间。如果你没有显式地对keyTimes进行设置，则系统会默认每条子路径的时间为：ti=duration/(帧数)，即每条子路径的duration相等
    keyFA.keyTimes = @[@(0.0),@(0.5),@(0.9),@(2)];
    //动画总时间
    keyFA.duration = 5.0f;
    //重复次数，小于0无限重复
    keyFA.repeatCount = 10;
    
    /*
     这个属性用以指定时间函数，类似于运动的加速度
     kCAMediaTimingFunctionLinear//线性
     kCAMediaTimingFunctionEaseIn//淡入
     kCAMediaTimingFunctionEaseOut//淡出
     kCAMediaTimingFunctionEaseInEaseOut//淡入淡出
     kCAMediaTimingFunctionDefault//默认
     */
    keyFA.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    /*
     fillMode的作用就是决定当前对象过了非active时间段的行为. 比如动画开始之前,动画结束之后。如果是一个动画CAAnimation,则需要将其removedOnCompletion设置为NO,要不然fillMode不起作用.
     
     下面来讲各个fillMode的意义
     kCAFillModeRemoved 这个是默认值,也就是说当动画开始前和动画结束后,动画对layer都没有影响,动画结束后,layer会恢复到之前的状态
     kCAFillModeForwards 当动画结束后,layer会一直保持着动画最后的状态
     kCAFillModeBackwards 这个和kCAFillModeForwards是相对的,就是在动画开始前,你只要将动画加入了一个layer,layer便立即进入动画的初始状态并等待动画开始.你可以这样设定测试代码,将一个动画加入一个layer的时候延迟5秒执行.然后就会发现在动画没有开始的时候,只要动画被加入了layer,layer便处于动画初始状态
     kCAFillModeBoth 理解了上面两个,这个就很好理解了,这个其实就是上面两个的合成.动画加入后开始之前,layer便处于动画初始状态,动画结束后layer保持动画最后的状态.
     //添加动画
     */
    keyFA.fillMode = kCAFillModeForwards;
    
    /*
     在关键帧动画中还有一个非常重要的参数,那便是calculationMode,计算模式.该属性决定了物体在每个子路径下是跳着走还是匀速走，跟timeFunctions属性有点类似
     其主要针对的是每一帧的内容为一个座标点的情况,也就是对anchorPoint 和 position 进行的动画.当在平面座标系中有多个离散的点的时候,可以是离散的,也可以直线相连后进行插值计算,也可以使用圆滑的曲线将他们相连后进行插值计算. calculationMode目前提供如下几种模式
     
     kCAAnimationLinear calculationMode的默认值,表示当关键帧为座标点的时候,关键帧之间直接直线相连进行插值计算;
     kCAAnimationDiscrete 离散的,就是不进行插值计算,所有关键帧直接逐个进行显示;
     kCAAnimationPaced 使得动画均匀进行,而不是按keyTimes设置的或者按关键帧平分时间,此时keyTimes和timingFunctions无效;
     kCAAnimationCubic 对关键帧为座标点的关键帧进行圆滑曲线相连后插值计算,对于曲线的形状还可以通过tensionValues,continuityValues,biasValues来进行调整自定义,这里的数学原理是Kochanek–Bartels spline,这里的主要目的是使得运行的轨迹变得圆滑;
     kCAAnimationCubicPaced 看这个名字就知道和kCAAnimationCubic有一定联系,其实就是在kCAAnimationCubic的基础上使得动画运行变得均匀,就是系统时间内运动的距离相同,此时keyTimes以及timingFunctions也是无效的.
     */
    keyFA.calculationMode = kCAAnimationPaced;
    
    //旋转的模式,auto就是沿着切线方向动，autoReverse就是转180度沿着切线动
    keyFA.rotationMode = kCAAnimationRotateAuto;
    
    //结束后是否移除动画
    keyFA.removedOnCompletion = NO;
    
    //添加动画
    [self.redView.layer addAnimation:keyFA forKey:@""];
}


// 给CAShapeLayer赋值 CGPath
-(void)createTest11
{
    //贝塞尔画圆
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(100, 100) radius:100 startAngle:0 endAngle:M_PI clockwise:NO];
    
    //初始化shapeLayer
    CAShapeLayer *_myShapeLayer = [CAShapeLayer layer];
    _myShapeLayer.frame = _redView.bounds;
    
    _myShapeLayer.strokeColor = [UIColor greenColor].CGColor;//边沿线色
    _myShapeLayer.fillColor = [UIColor grayColor].CGColor;//填充色
    
    _myShapeLayer.lineJoin = kCALineJoinMiter;//线拐点的类型
    _myShapeLayer.lineCap = kCALineCapSquare;//线终点
    
    //从贝塞尔曲线获得形状
    _myShapeLayer.path = path.CGPath;
    
    //线条宽度
    _myShapeLayer.lineWidth = 10;
    
    //起始和终止
    _myShapeLayer.strokeStart = 0.0;
    _myShapeLayer.strokeEnd = 1.0;
    
    //将layer添加进图层
    [self.redView.layer addSublayer:_myShapeLayer];
}

- (void)createTest10{
    CGContextRef context = UIGraphicsGetCurrentContext();//获取上下文
    CGMutablePathRef path = CGPathCreateMutable();//创建路径
    CGPathMoveToPoint(path, nil, 20, 50);//移动到指定位置（设置路径起点）
    CGPathAddLineToPoint(path, nil, 20, 100);//绘制直线（从起始位置开始）
    CGContextAddPath(context, path);//把路径添加到上下文（画布）中
    
    //设置图形上下文状态属性
    CGContextSetRGBStrokeColor(context, 1.0, 0, 0, 1);//设置笔触颜色
    CGContextSetRGBFillColor(context, 0, 1.0, 0, 1);//设置填充色
    CGContextSetLineWidth(context, 2.0);//设置线条宽度
    CGContextSetLineCap(context, kCGLineCapRound);//设置顶点样式
    CGContextSetLineJoin(context, kCGLineJoinRound);//设置连接点样式
    CGFloat lengths[2] = { 18, 9 };
    CGContextSetLineDash(context, 0, lengths, 2);
    CGContextSetShadowWithColor(context, CGSizeMake(2, 2), 0, [UIColor blackColor].CGColor);
    CGContextDrawPath(context, kCGPathFillStroke);//最后一个参数是填充类型
    CGPathRelease(path);
}

- (void)createTest9{
    //创建路径时间
    CGMutablePathRef cgPath = CGPathCreateMutable();
    
    //cgPath的画图接口
    //给一个cgPath里面添加了多个样式，圆和椭圆会发生关联
    
    //两个椭圆互不影响
    CGPathAddEllipseInRect(cgPath, NULL, CGRectMake(100, 100, 50, 100));
    
    CGPathAddEllipseInRect(cgPath, NULL, CGRectMake(250, 250, 100, 50));
    
    //矩形
    CGPathAddRect(cgPath, NULL, CGRectMake(200, 500, 30, 100));
    //    圆形
    //    CGPathAddArc(cgPath, NULL, 120, 400, 100, 0, M_PI*2, YES);
    
    //下面两句要搭配，先有起点
    CGPathMoveToPoint(cgPath, NULL, 200, 300);
    //加一段弧
    CGPathAddArcToPoint(cgPath, NULL, 320, 250, M_PI_4, M_PI*2, 50);
    
    
    //把CGPath赋给贝塞尔曲线
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    
    aPath.CGPath = cgPath;
    
    aPath.usesEvenOddFillRule = YES;
    
    //并不在ARC的管理范围之内。所以需要手动释放对象，释放cgPath
    CGPathRelease(cgPath);
    
    //划线
    [[UIColor redColor]setStroke];
    [aPath setLineWidth:5];
    [aPath stroke];
}


//绘制三次贝塞尔曲线
- (void)createTest8{
    UIColor *color = [UIColor redColor];
    [color set];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    path.lineWidth = 5;

    [path moveToPoint:CGPointMake(20, 200)];
    [path addCurveToPoint:CGPointMake(130, 200) controlPoint1:CGPointMake(75, 0) controlPoint2:CGPointMake(75, 400)];
    [path addCurveToPoint:CGPointMake(260, 200) controlPoint1:CGPointMake(195, 0) controlPoint2:CGPointMake(195, 400)];

    [path fill];
    
}

// 绘制二次贝塞尔曲线
- (void)createTest7{
    UIColor *color = [UIColor redColor];
    [color set];

    UIBezierPath *path = [UIBezierPath bezierPath];
    
    path.lineWidth = 5;
    
    [path moveToPoint:CGPointMake(20, 200)];
    
    [path addQuadCurveToPoint:CGPointMake(20+40*1, 200) controlPoint:CGPointMake(40*1, 0)];
    
    [path addQuadCurveToPoint:CGPointMake(20+40*2, 200) controlPoint:CGPointMake(40*2, 0)];

    [path addQuadCurveToPoint:CGPointMake(20+40*3, 200) controlPoint:CGPointMake(40*3, 0)];

    [path addQuadCurveToPoint:CGPointMake(20+40*4, 200) controlPoint:CGPointMake(40*4, 0)];

//    [path addQuadCurveToPoint:CGPointMake(200, 200) controlPoint:CGPointMake(180*3/2., 180*1/5.)];
    
//    [path stroke];
    [path fill];
}


// 顺时针或者逆时针画线
- (void)createTest6{
    UIColor *color = [UIColor redColor];
    [color set];

    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(200, 200) radius:50 startAngle:M_PI_2 endAngle:M_PI*2 clockwise:YES];
    path.lineWidth = 10;

    [path stroke];
    
}

// 四个角里右上和左下圆角
- (void)createTest5{
    UIColor *color = [UIColor redColor];
    [color set];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(20, 20, 200, 200) byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomLeft cornerRadii:CGSizeMake(50, 50)];
    
    [path fill];
}

// 矩形圆角
- (void)createTest4{
    UIColor *color = [UIColor redColor];
    [color set];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(20, 20, 200, 200) cornerRadius:50];
    [path fill];
}

// 椭圆或者圆
- (void)createTest3{
    
    UIBezierPath* twoPath = [UIBezierPath bezierPath];
    twoPath.lineWidth = 5.0;//宽度
    twoPath.lineCapStyle = kCGLineCapRound;  //线条拐角
    twoPath.lineJoinStyle = kCGLineJoinRound;  //终点处理
    //起始点
    [twoPath moveToPoint:CGPointMake(20, 100)];
    //添加两个控制点
    [twoPath addQuadCurveToPoint:CGPointMake(220, 100) controlPoint:CGPointMake(170, 0)];
    //划线
    [twoPath stroke];
 
    
//
//    UIColor *color = [UIColor redColor];
//    [color set]; //设置线条颜色
//
//    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(20, 40, 300, 200)];
//    path.lineWidth = 5;
//    path.lineJoinStyle = kCGLineJoinRound;
//    path.lineCapStyle = kCGLineCapRound;
//    [path stroke];
}


// 正方形或者矩形
- (void)createTest2{
    UIColor *color = [UIColor redColor];
    [color set]; //设置线条颜色

    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(20, 40, 200, 200)];
    path.lineWidth = 5;
    path.lineJoinStyle = kCGLineJoinRound;
    path.lineCapStyle = kCGLineCapRound;
    
    [path stroke];
}

// 五边形
- (void)createTest1{
    UIColor *color = [UIColor redColor];
    [color set]; //设置线条颜色

    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 5;
    
    path.lineJoinStyle = kCGLineJoinRound;
    path.lineCapStyle = kCGLineCapRound;
    
    [path moveToPoint:CGPointMake(200, 50)];
    
    [path addLineToPoint:CGPointMake(300, 100)];
    [path addLineToPoint:CGPointMake(260, 200)];
    [path addLineToPoint:CGPointMake(100, 200)];
    [path addLineToPoint:CGPointMake(100, 70)];
    
    [path closePath];
    
    [path stroke];
//    [path fill];
    
}


// 画线
- (void)createTest0{
    UIColor *color = [UIColor redColor];
    [color set]; //设置线条颜色
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(10, 100)];
    [path addLineToPoint:CGPointMake(200, 250)];
    
    [path addLineToPoint:CGPointMake(100, 350)];
    path.lineWidth = 4;
    path.lineCapStyle = kCGLineCapRound ;//kCGLineCapRound; //线条拐角
    path.lineJoinStyle = kCGLineCapRound;  //终点处理
    
    [path stroke];
//    [path fill];
}

@end
