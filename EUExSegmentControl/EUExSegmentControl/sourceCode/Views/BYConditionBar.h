//
//  BYConditionBar.h
//  BYDailyNews
//
//  Created by bassamyan on 15/1/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DY.h"

//回掉代码块
typedef void (^uexSegmentControlCallBackBlock)(NSMutableDictionary *callBackData);
typedef void (^uexSegmentControlDataChangeBlock)(NSMutableDictionary *dataChangeData);
@interface BYConditionBar : UIScrollView
<<<<<<< HEAD

=======
 
>>>>>>> origin/dev-4.0
@property (nonatomic, copy) uexSegmentControlCallBackBlock callBackBlock;//回调
@property (nonatomic, copy) uexSegmentControlDataChangeBlock  dataChangeBlock;
@property (nonatomic, assign) CGFloat  deleatWith;
//  显示的所有栏目
@property (nonatomic, strong) NSMutableDictionary *dataDictionary;

- (void)selectButtonWithIndex:(NSInteger)index;
@end
