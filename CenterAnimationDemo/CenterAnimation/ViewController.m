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

@property(nonatomic)UIImageView *minuteHand;
@property(nonatomic)UIImageView *hourHand;
@property(nonatomic)UIImageView *secondHand;


@property (nonatomic,weak) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}
#pragma mark 时钟
-(void)initUI{
    //背景
    CGFloat cornerWidth = 5;
    CGFloat backView_wh = 200;
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake((UISCREEN_WIDTH-200)/2, (UISCREEN_HEIGHT-200)/2, backView_wh, backView_wh)];
    backView.backgroundColor = [UIColor clearColor];
    backView.layer.borderColor = RandCOLOR.CGColor;
    backView.layer.borderWidth = cornerWidth;
    backView.layer.cornerRadius = backView_wh/2;
    backView.layer.masksToBounds = YES;
    
    //刻度
    for(int i = 0;i<12;i++){
        UIView *scaleMark = [[UIView alloc]init];
        scaleMark.backgroundColor = RandCOLOR;
        scaleMark.layer.anchorPoint = CGPointMake(0.5,(backView_wh/2-cornerWidth*2)/cornerWidth);
        scaleMark.frame = CGRectMake((backView_wh-cornerWidth)/2, cornerWidth*2, cornerWidth, cornerWidth);
        CGFloat transAngle = M_PI * 2/12 * i;
        scaleMark.transform = CGAffineTransformMakeRotation(transAngle);
        
        [backView addSubview:scaleMark];
    }
    
    [self.view addSubview:backView];
    
    //三根针
    self.secondHand = [[UIImageView alloc]init];
    self.minuteHand = [[UIImageView alloc]init];
    self.hourHand = [[UIImageView alloc]init];
    [self.secondHand setBackgroundColor:RandCOLOR];
    [self.minuteHand setBackgroundColor:RandCOLOR];
    [self.hourHand setBackgroundColor:RandCOLOR];
    //调整anchorpoint,调整完之后再设置Frame所以不会变形。
    self.secondHand.layer.anchorPoint = CGPointMake(0.5f, 1);
    self.minuteHand.layer.anchorPoint = CGPointMake(0.5f, 1);
    self.hourHand.layer.anchorPoint = CGPointMake(0.5f, 1);
    CGFloat secondHand_h = backView_wh/2 - 20;
    CGFloat minuteHand_h = backView_wh/2 - 35;
    CGFloat hourHand_h = backView_wh/2 - 50;
    self.secondHand.frame = CGRectMake((backView_wh-3)/2, 20, 3, secondHand_h);//秒针
    self.minuteHand.frame = CGRectMake((backView_wh-6)/2, 35, 6, minuteHand_h);//分针
    self.hourHand.frame = CGRectMake((backView_wh-9)/2, 50, 9, hourHand_h);//时针
    [backView addSubview:self.secondHand];
    [backView addSubview:self.minuteHand];
    [backView addSubview:self.hourHand];
    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
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
