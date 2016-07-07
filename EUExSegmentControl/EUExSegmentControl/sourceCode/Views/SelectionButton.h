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
@property (nonatomic,strong) BYSelectionDetails *Detail;
@property (nonatomic,strong) BYSelectNewBar *Newbar;
@property (nonatomic,strong) BYSelectionView *selectionView;
@property (nonatomic,strong) BYConditionBar *conditonBar;
@property (nonatomic,assign) BOOL changeImage;
 

@end
