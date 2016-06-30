//
//  BYSelectNewBar.m
//  BYDailyNews
//
//  Created by bassamyan on 15/1/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "BYSelectNewBar.h"

@interface BYSelectNewBar()
{
    UILabel *sublabel;
    UIButton *button;
}

@end

@implementation BYSelectNewBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeNewBar];
        self.hidden= YES;
    }
    return self;
}
-(void)makeNewBar
{
    self.backgroundColor = Color_maingray;
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, (self.frame.size.height- 30)/2, 60, 30)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor blackColor];
    if ([user objectForKey:@"showedLable"]) {
        label.text = [NSString stringWithFormat:@"%@",[user objectForKey:@"showedLable"]];
    }
    else
    {
        label.text = @"我的频道";
    }
    label.backgroundColor = [UIColor clearColor];
    [self addSubview:label];
    
    sublabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+10,10, 100, 11)];
    sublabel.font = [UIFont systemFontOfSize:14];
    sublabel.text = @"拖拽可以编辑";
    sublabel.textColor = sublabel_gray;
    sublabel.backgroundColor = [UIColor clearColor];
    sublabel.hidden = YES;
    [self addSubview:sublabel];
    
    button = [[UIButton alloc] initWithFrame:CGRectMake(BYScreenWidth-100, (self.frame.size.height - 20)/2, 50, 20)];
    [button setTitle:@"编辑" forState:0];
    [button setTitleColor:[UIColor redColor] forState:0];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.layer.cornerRadius = 4;
    button.layer.borderWidth = 0.5;
    [button.layer setMasksToBounds:YES];
    button.layer.borderColor = [[UIColor redColor] CGColor];
    button.tag = 0;
    [button addTarget:self
               action:@selector(buttonclick)
     forControlEvents:1 << 6];
    [self addSubview:button];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(buttonclick)
                                                 name:@"press_longPressGesture"
                                               object:nil];
    
}


-(void)buttonclick
{
    if ([button.titleLabel.text isEqualToString:@"完成"]) {
        [button setTitle:@"编辑" forState:0];
        sublabel.hidden = YES;
    }
    else if([button.titleLabel.text isEqualToString:@"编辑"])
    {
        [button setTitle:@"完成" forState:0];
        sublabel.hidden = NO;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"srot_btn_click"
                                                        object:button
                                                      userInfo:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"srot_btn_click" object:nil];
}
@end
