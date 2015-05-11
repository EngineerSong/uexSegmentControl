//
//  EUExSegmentControl.h
//  EUExSegmentControl
//
//  Created by zhijian du on 15/2/2.
//  Copyright (c) 2015年 zhijian du. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EUExBase.h"
#import "JSON.h"
#import "BYConditionBar.h"
#import "SelectionButton.h"
#import "BYSelectionDetails.h"
#import "BYSelectNewBar.h"
@interface EUExSegmentControl : EUExBase
@property (nonatomic , retain) BYConditionBar *conditionBar;
@property (nonatomic , retain) BYSelectNewBar *selection_newBar;
@property (nonatomic , retain) BYSelectionDetails *selection_details ;
@property (nonatomic , retain) SelectionButton *arrow;

@end
