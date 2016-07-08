//
//  EUExSegmentControl.h
//  EUExSegmentControl
//
//  Created by zhijian du on 15/2/2.
//  Copyright (c) 2015年 zhijian du. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AppCanKit/AppCanKit.h>
#import "BYConditionBar.h"
#import "SelectionButton.h"
#import "BYSelectionDetails.h"
#import "BYSelectNewBar.h"
#import "BYSelectionView.h"

@interface EUExSegmentControl : EUExBase
@property (nonatomic , strong) BYConditionBar *conditionBar;
@property (nonatomic , strong) BYSelectNewBar *selection_newBar;
@property (nonatomic , strong) BYSelectionDetails *selection_details ;
@property (nonatomic , strong) SelectionButton *arrow;
@property (nonatomic , strong) BYSelectionView  *selectionView;

@end
