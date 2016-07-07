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
typedef void (^CallBackBlock)(NSMutableDictionary *callBackDate);
typedef void (^DataChangeBlock)(NSMutableDictionary *dataChangeDate);
@interface BYConditionBar : UIScrollView
 
@property (nonatomic, copy) CallBackBlock callBackBlock;//回调
@property (nonatomic, copy) DataChangeBlock  dataChangeBlock;
@property (nonatomic, assign) CGFloat  deleatWith;
//  显示的所有栏目
@property (nonatomic, strong) NSMutableDictionary *dataDictionary;

-(void)viewSelectWithOption:(NSString *)str;
@end
