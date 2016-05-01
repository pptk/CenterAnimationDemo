//
//  ViewController.m
//  CenterAnimationDemo
//
//  Created by ianc-ios on 16/2/15.
//  Copyright © 2016年 彭雄辉10/9. All rights reserved.
//

#import "ViewController.h"

#define UISCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define UISCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define COLOR(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define RandCOLOR COLOR(arc4random()%255,arc4random()%255,arc4random()%255,1)

@interface ViewController ()

@end

@implementation ViewController
{
    CAShapeLayer *hourShapeLayer;
    CAShapeLayer *minuShapeLayer;
    CAShapeLayer *secondShapeLayer;
    NSTimer *timer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self initView];//初始化
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(ticker) userInfo:nil repeats:YES];
    [self ticker];
}
-(void)initView{
    //背景圆圈
    CALayer *backgroundLayer = [CALayer layer];
    backgroundLayer.frame = CGRectMake(100, 100, 200, 200);
    backgroundLayer.backgroundColor = [UIColor whiteColor].CGColor;
    UIBezierPath *pathshaperLayer = [[UIBezierPath alloc]init];
    [pathshaperLayer addArcWithCenter:CGPointMake(100, 100) radius:100 startAngle:0 endAngle:2*M_PI clockwise:YES];
    CAShapeLayer *shaperLayer = [CAShapeLayer layer];//矢量
    shaperLayer.strokeColor = [UIColor redColor].CGColor;
    shaperLayer.fillColor = [UIColor clearColor].CGColor;
    shaperLayer.lineWidth = 5;
    shaperLayer.path = pathshaperLayer.CGPath;
    [backgroundLayer addSublayer:shaperLayer];
    
    //在该Layer上的所有控件会自动重复12个（节省内存，方便处理倒影等）。
    CAReplicatorLayer *tickLayer = [CAReplicatorLayer layer];//表的刻度，在tickLayer内的每一个控件都会每次旋转30度，然后重复12个对象。
    tickLayer.frame = backgroundLayer.bounds;
    tickLayer.instanceCount = 12;
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, 0, 0, 0);
    transform = CATransform3DRotate(transform, M_PI/6, 0, 0, 1);//z轴旋转30度。
    transform = CATransform3DTranslate(transform, 0, 0, 0);
    tickLayer.instanceTransform = transform;
    CALayer *aTickLayer = [CALayer layer];
    aTickLayer.frame = CGRectMake(98, 0, 4, 6);
    aTickLayer.backgroundColor = [UIColor redColor].CGColor;
    [tickLayer addSublayer:aTickLayer];
    [backgroundLayer addSublayer:tickLayer];
    
    //指针
    //时针
    UIBezierPath *hourPath = [[UIBezierPath alloc]init];
    [hourPath moveToPoint:CGPointMake(8, 50)];
    [hourPath addLineToPoint:CGPointMake(0, 100)];
    [hourPath addLineToPoint:CGPointMake(16, 100)];
    [hourPath addLineToPoint:CGPointMake(8, 50)];
    hourShapeLayer = [CAShapeLayer layer];
    hourShapeLayer.anchorPoint = CGPointMake(0.5f, 1.0f);
    hourShapeLayer.frame = CGRectMake(92, 0, 16, 100);
    hourShapeLayer.strokeColor = [UIColor redColor].CGColor;
    hourShapeLayer.fillColor = [UIColor redColor].CGColor;
    hourShapeLayer.lineWidth = 1;
    hourShapeLayer.path = hourPath.CGPath;
    [backgroundLayer addSublayer:hourShapeLayer];
    
    //分针
    UIBezierPath *minuPath = [[UIBezierPath alloc]init];
    [minuPath moveToPoint:CGPointMake(5, 0)];
    [minuPath addLineToPoint:CGPointMake(0, 60)];
    [minuPath addLineToPoint:CGPointMake(10, 60)];
    [minuPath addLineToPoint:CGPointMake(5, 0)];
    minuShapeLayer = [CAShapeLayer layer];
    minuShapeLayer.anchorPoint = CGPointMake(0.5f, 1.0f);
    minuShapeLayer.frame = CGRectMake(95, 40, 10, 60);
    minuShapeLayer.strokeColor = [UIColor greenColor].CGColor;
    minuShapeLayer.fillColor = [UIColor greenColor].CGColor;
    minuShapeLayer.lineWidth = 1;
    minuShapeLayer.path = minuPath.CGPath;
    [backgroundLayer addSublayer:minuShapeLayer];
    
    //秒针
    UIBezierPath *secondPath = [[UIBezierPath alloc]init];
    [secondPath moveToPoint:CGPointMake(2, 0)];
    [secondPath addLineToPoint:CGPointMake(0, 75)];
    [secondPath addLineToPoint:CGPointMake(4, 75)];
    [secondPath addLineToPoint:CGPointMake(2, 0)];
    secondShapeLayer = [CAShapeLayer layer];
    secondShapeLayer.anchorPoint = CGPointMake(0.5f, 1.0f);
    secondShapeLayer.frame = CGRectMake(98, 25, 4, 75);
    secondShapeLayer.strokeColor = [UIColor blueColor].CGColor;
    secondShapeLayer.fillColor = [UIColor blueColor].CGColor;
    secondShapeLayer.lineWidth = 1;
    secondShapeLayer.path = secondPath.CGPath;
    NSLog(@"---%@",NSStringFromCGRect(secondShapeLayer.frame));
    [backgroundLayer addSublayer:secondShapeLayer];
    
    //center point
    UIBezierPath *pathCenterShaperLayer = [[UIBezierPath alloc]init];
    [pathCenterShaperLayer addArcWithCenter:CGPointMake(100, 100) radius:10 startAngle:0 endAngle:2*M_PI clockwise:YES];
    CAShapeLayer *centerShaperLayer = [CAShapeLayer layer];
    centerShaperLayer.strokeColor = [UIColor redColor].CGColor;
    centerShaperLayer.fillColor = [UIColor blackColor].CGColor;
    centerShaperLayer.lineWidth = 5;
    centerShaperLayer.path = pathCenterShaperLayer.CGPath;
    [backgroundLayer addSublayer:centerShaperLayer];
    
    
    [self.view.layer addSublayer:backgroundLayer];
}
-(void)ticker{
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger units = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [calendar components:units fromDate:[NSDate date]];
    CGFloat hoursAngle = (components.hour/12.0) * M_PI * 2.0;
    CGFloat minusAngle = (components.minute/60.0) * M_PI * 2.0;
    CGFloat secondsAngle = (components.second/60.0) * M_PI * 2.0;
    hourShapeLayer.transform = CATransform3DMakeRotation(hoursAngle, 0, 0, 1);
    minuShapeLayer.transform = CATransform3DMakeRotation(minusAngle, 0, 0, 1);
    secondShapeLayer.transform = CATransform3DMakeRotation(secondsAngle, 0, 0, 1);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
