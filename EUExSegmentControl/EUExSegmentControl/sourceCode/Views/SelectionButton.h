//
//  SelectionButton.h
//  BYDailyNews
//
//  Created by bassamyan on 15/1/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DY.h"
@class BYSelectionDetails;
@class BYSelectNewBar;
@class BYSelectionView;
@class BYConditionBar;

@interface SelectionButton : UIButton
@property (nonatomic,weak) BYSelectionDetails *Detail;
@property (nonatomic,weak) BYSelectNewBar *Newbar;
@property (nonatomic,weak) BYSelectionView *selectionView;
@property (nonatomic,weak) BYConditionBar *conditonBar;
@property (nonatomic,assign) BOOL changeImage;


@end
