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
-(UIImage *)getImageFromLocalFile:(NSString*)imageName{
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]];
}

/******************************
 
 初始化ArrowButton
 
 ******************************/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:[self getImageFromLocalFile:@"uexSegmentControl/Arrow"] forState:0];
        [self setImage:[self getImageFromLocalFile:@"uexSegmentControl/Arrow"] forState:1<<0];

//        [self setImage:[UIImage imageNamed:@"Arrow.png"] forState:0];
//        [self setImage:[UIImage imageNamed:@"Arrow.png"] forState:1<<0];
        self.backgroundColor = Color_maingray;
        [self addTarget:self
                 action:@selector(ArrowClick)
       forControlEvents:1 << 6];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(ArrowClick)
                                                     name:@"arrow_change"
                                                   object:nil];
    }
    return self;
}

-(void)ArrowClick{
//    self.Newbar.hidden = (self.Detail.frame.origin.y<0)?NO:YES;
    self.Newbar.hidden = (self.Detail.frame.origin.y>=BYScreenHeight)?NO:YES;

    [UIView animateWithDuration:arrow_animation_time animations:^{
        CGAffineTransform rotation = self.imageView.transform;
        self.imageView.transform = CGAffineTransformRotate(rotation,M_PI);
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSInteger y = [[userDefaults objectForKey:@"y"] integerValue];
//        self.Detail.transform = (self.Detail.frame.origin.y<0)?CGAffineTransformMakeTranslation(0, BYScreenHeight+y ):CGAffineTransformMakeTranslation(0, -BYScreenHeight-y);
        self.Detail.transform = (self.Detail.frame.origin.y>= BYScreenHeight)?CGAffineTransformMakeTranslation(0, -BYScreenHeight + y +conditionScrollH  ):CGAffineTransformMakeTranslation(0, BYScreenHeight);
    }];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat image_width = 18;
    return CGRectMake((contentRect.size.width-image_width)/2, (conditionScrollH-image_width)/2, image_width, image_width);
}

@end
