//
//  BYSelectionView.h
//  BYDailyNews
//
//  Created by bassamyan on 15/1/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DY.h"
typedef void(^operateBlock)(NSString * , NSString * , int);


@interface BYSelectionView : UIButton
{
    @public
    NSMutableArray *views_array;
    NSMutableArray *views1;
    NSMutableArray *views2;
}
 
@property (nonatomic,strong) UIView   *moreChanelslabel;
@property (nonatomic,strong) UIButton *delete_btn;
@property (nonatomic,strong) UIButton *hid_btn;
@property (nonatomic,copy)   operateBlock operations;
 

@property (nonatomic,assign) BOOL isEqualFirst;
@property (nonatomic,strong) UIPanGestureRecognizer *gesture;
@property (nonatomic,strong) UILongPressGestureRecognizer *longGesture;

@property (nonatomic,strong) NSString *maxShow;

-(void)makeSelectionViewWithTitle:(NSString *)title;
@end
