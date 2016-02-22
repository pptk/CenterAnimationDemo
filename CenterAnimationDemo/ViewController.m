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

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *minuteHand;
@property (weak, nonatomic) IBOutlet UIImageView *hourHand;
@property (weak, nonatomic) IBOutlet UIImageView *secondHand;
@property (nonatomic,weak) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self caLayer1];
//    [self caLayer2];
//    [self caLayer3];
    [self caLayer4];

    
}
#pragma mark calayer简单使用
-(void)caLayer1{
    //CALayer添加一张图片。
    [self.view setBackgroundColor:[UIColor blueColor]];
    UIView *layerView = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    UIImage *image = [UIImage imageNamed:@"abc.jpg"];
    layerView.layer.contents = (__bridge id)image.CGImage;
    
    //    layerView.layer.contentsGravity = kCAGravityResizeAspect;
    layerView.layer.contentsGravity = kCAGravityCenter;
    //    layerView.layer.contentsScale = 1;//一个位置一个像素点。
    //    layerView.contentMode = UIViewContentModeScaleAspectFit;//与上(kCAGravityResizeAspect)效果等同。
    
    [self.view addSubview:layerView];
}

#pragma mark calayer 使用contentsRect切图。
-(void)caLayer2{
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH/2, UISCREEN_HEIGHT/2)];
    view1.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:view1];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(UISCREEN_WIDTH/2, 0, UISCREEN_WIDTH/2, UISCREEN_HEIGHT/2)];
    view2.backgroundColor = [UIColor redColor];
    [self.view addSubview:view2];
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, UISCREEN_HEIGHT/2, UISCREEN_WIDTH/2, UISCREEN_HEIGHT/2)];
    view3.backgroundColor = [UIColor greenColor];
    [self.view addSubview:view3];
    UIView *view4 = [[UIView alloc]initWithFrame:CGRectMake(UISCREEN_WIDTH/2, UISCREEN_HEIGHT/2, UISCREEN_WIDTH/2, UISCREEN_HEIGHT/2)];
    view4.backgroundColor = [UIColor blueColor];
    [self.view addSubview:view4];
    
    UIImage *image = [UIImage imageNamed:@"abc.jpg"];
    [self addSpriteImage:image withContentRect:CGRectMake(0, 0, 0.5, 0.5) toLayer:view1.layer];
    [self addSpriteImage:image withContentRect:CGRectMake(0.5, 0, 0.5, 0.5) toLayer:view2.layer];
    [self addSpriteImage:image withContentRect:CGRectMake(0, 0.5, 0.5, 0.5) toLayer:view3.layer];
    [self addSpriteImage:image withContentRect:CGRectMake(0.5, 0.5, 0.5, 0.5) toLayer:view4.layer];
    
}
-(void)addSpriteImage:(UIImage *)image withContentRect:(CGRect)rect toLayer:(CALayer *)layer{
    layer.contents = (__bridge id)image.CGImage;
    layer.contentsGravity = kCAGravityCenter;
    layer.contentsRect = rect;//去掉其中我们不想显示的部分。
}

#pragma mark calayer delegate
-(void)caLayer3{
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    blueLayer.delegate = self;
    
    blueLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:blueLayer];
    [blueLayer display];//如果不识闲displayLayer方法就会调用drawLayer
    
}
//-(void)displayLayer:(CALayer *)layer{

//}
-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    CGContextSetLineWidth(ctx, 10.0f);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokeEllipseInRect(ctx, CGRectMake(0, 0, 100, 100));
}

#pragma mark 时钟
-(void)caLayer4{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    
    //调整anchorpoint
    self.secondHand.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    self.minuteHand.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    self.hourHand.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    
    [self tick];
}
-(void)tick{
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unites = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [calendar components:unites fromDate:[NSDate date]];
    CGFloat hoursAngle = (components.hour /12.0) * M_PI *2.0;
    CGFloat minsAngle = (components.minute / 60.0) * M_PI *2.0;
    CGFloat secsAngle = (components.second / 60.0) * M_PI *2.0;
    
    self.hourHand.transform = CGAffineTransformMakeRotation(hoursAngle);
    self.minuteHand.transform = CGAffineTransformMakeRotation(minsAngle);
    self.secondHand.transform = CGAffineTransformMakeRotation(secsAngle);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
