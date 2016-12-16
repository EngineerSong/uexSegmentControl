//
//  SelectionButton.m
//  BYDailyNews
//
//  Created by bassamyan on 15/1/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SelectionButton.h"
#import "BYSelectNewBar.h"
#import "BYSelectionDetails.h"


@implementation SelectionButton

@synthesize changeImage;

-(UIImage *)getImageFromLocalFile:(NSString*)imageName{
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]];
}

/******************************
 
 初始化ArrowButton
 
 ******************************/
- (instancetype)initWithFrame:(CGRect)frame
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    
    self = [super initWithFrame:frame];
    if (self) {
        if ([user objectForKey:@"expandOpenIcon"] != nil) {
            NSString *btnIconUp = [NSString stringWithFormat:@"%@",[user objectForKey:@"expandOpenIcon"]];
            [self setImage:[UIImage imageWithContentsOfFile:btnIconUp] forState:0];
        }
        else{
            [self setImage:[self getImageFromLocalFile:@"uexSegmentControl/Arrow"] forState:0];
            [self setImage:[self getImageFromLocalFile:@"uexSegmentControl/Arrow"] forState:1<<0];
        }
        changeImage = NO;
        self.backgroundColor = Color_maingray;
        [self addTarget:self
                 action:@selector(ArrowClick)
       forControlEvents:UIControlEventTouchUpInside];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(ArrowClick)
                                                     name:@"arrow_change"
                                                   object:nil];
    }
    return self;
}

-(void)ArrowClick{
    self.Newbar.hidden = (self.Detail.frame.origin.y>=BYScreenHeight)?NO:YES;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    打开详情栏
    if (!changeImage) {
        if ([userDefaults objectForKey:@"expandCloseIcon"] != nil) {
            NSString *btnIConDown = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"expandCloseIcon"]];
            [self setImage:[UIImage imageWithContentsOfFile:btnIConDown] forState:0];
        }
        else
        {
            [UIView animateWithDuration:arrow_animation_time animations:^{
                CGAffineTransform rotation = self.imageView.transform;
                self.imageView.transform = CGAffineTransformRotate(rotation,M_PI);
            }];
        }
        
        changeImage = YES;
    }
    else
    {
        if ([userDefaults objectForKey:@"expandOpenIcon"] != nil) {
            NSString *btnIconUp = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"expandOpenIcon"]];
            [self setImage:[UIImage imageWithContentsOfFile:btnIconUp] forState:0];
        }
        else
        {
                [UIView animateWithDuration:arrow_animation_time animations:^{
                    CGAffineTransform rotation = self.imageView.transform;
                    self.imageView.transform = CGAffineTransformRotate(rotation,M_PI);
                }];
        }
        changeImage = NO;
    }
    NSInteger y = [[userDefaults objectForKey:@"top"] integerValue];
    self.Detail.transform = (self.Detail.frame.origin.y>= BYScreenHeight)?CGAffineTransformMakeTranslation(0, -BYScreenHeight + y +self.frame.size.height):CGAffineTransformMakeTranslation(0, BYScreenHeight);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat image_width = 18;
    return CGRectMake((contentRect.size.width-image_width)/2, (self.frame.size.height-image_width)/2, image_width, image_width);
}

@end
