//
//  EUExSegmentControl.m
//  EUExSegmentControl
//
//  Created by zhijian du on 15/2/2.
//  Copyright (c) 2015年 zhijian du. All rights reserved.
//

#import "EUExSegmentControl.h"
#import "EUtility.h"

@implementation EUExSegmentControl
-(id)initWithBrwView:(EBrowserView *)eInBrwView{
    self = [super initWithBrwView:eInBrwView];
    if (self) {
    }
    return self;
}

-(void)open:(NSMutableArray *)inArguments{
    NSInteger x= 0, y = 0, width = 0, height = 0;
    if (inArguments.count > 0) {
        NSDictionary *dict = [[inArguments objectAtIndex:0] JSONValue];
        x = [[dict objectForKey:@"x"] integerValue] ;
        y = [[dict objectForKey:@"y"] integerValue];
        width = [[dict objectForKey:@"w"] integerValue];
        height = [[dict objectForKey:@"h"] integerValue];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:[NSString stringWithFormat:@"%ld",(long)y] forKey:@"y"];
        [userDefaults synchronize];
    }
    BYConditionBar *conditionBar = [[BYConditionBar alloc] initWithFrame:CGRectMake(x, y, BYScreenWidth, conditionScrollH)];
    self.conditionBar = conditionBar;
    [conditionBar release];
    
    //选择的回调
    self.conditionBar.callBackBlock = ^(NSMutableDictionary *callBackDate){
    
        NSLog(@"%@",[callBackDate JSONRepresentation]);
        
        [super jsSuccessWithName:@"uexSegmentControl.onItemClick" opId:0 dataType:0 strData:[callBackDate JSONRepresentation]];
    };
    
    [EUtility brwView:self.meBrwView addSubview:self.conditionBar];
    
    BYSelectNewBar *selection_newBar = [[BYSelectNewBar alloc] initWithFrame:conditionBar.frame];
    self.selection_newBar = selection_newBar;
    [selection_newBar release];
    [EUtility brwView:self.meBrwView addSubview:self.selection_newBar];
    
//    BYSelectionDetails *selection_details = [[BYSelectionDetails alloc] initWithFrame:CGRectMake(0, conditionScrollH-BYScreenHeight, BYScreenWidth, BYScreenHeight-conditionScrollH)];
    BYSelectionDetails *selection_details = [[BYSelectionDetails alloc] initWithFrame:CGRectMake(0, BYScreenHeight, BYScreenWidth, BYScreenHeight-conditionScrollH)];
    self.selection_details = selection_details;
    [selection_details release];
    [EUtility brwView:self.meBrwView insertSubView:self.selection_details belowSubView:self.conditionBar];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([[userDefaults objectForKey:@"flag"] integerValue] == 1) {
        SelectionButton *arrow = [[SelectionButton alloc] initWithFrame:CGRectMake(BYScreenWidth-arrow_width, y, arrow_width, conditionScrollH)];
        self.arrow = arrow;
        [arrow release];
        self.arrow.Detail = selection_details;
        self.arrow.Newbar = selection_newBar;
        
        [EUtility brwView:self.meBrwView addSubview:self.arrow];
    }
    
}

-(void)setData:(NSMutableArray *)inArguments{
    NSString *flag =@"1";
    NSArray  *array  = [[[inArguments objectAtIndex:0] JSONValue] objectForKey:@"data"];
    flag = [[[inArguments objectAtIndex:0] JSONValue] objectForKey:@"flag"];
    NSMutableArray *array1 = [[NSMutableArray alloc]init];
    NSMutableArray *array2 = [[NSMutableArray alloc]init];
    for(int i = 0;i< array.count ; i++){
        if (i < 17) {
            [array1 addObject:[array objectAtIndex:i]];
        }else{
            [array2 addObject:[array objectAtIndex:i]];
        }
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:array1 forKey:@"array1"];
    [userDefaults setObject:array2 forKey:@"array2"];
    [userDefaults setObject:flag forKey:@"flag"];
    [userDefaults synchronize];
    [array1 release];
    [array2 release];
}

-(void)setCurrentItem:(NSMutableArray *)inArguments{
    
    if (inArguments.count >0) {
        NSString *index = [inArguments objectAtIndex:0];
        
        [self.conditionBar viewSelectWithOption:index];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:index  forKey:@"index"];
        
        [userDefaults synchronize];
    }

    
}



-(void)close:(NSMutableArray *)inArguments{

    if (self.conditionBar) {
        [[NSNotificationCenter defaultCenter] removeObserver:_conditionBar name:@"operations_from_selectionView" object:nil];
        [_conditionBar removeFromSuperview];
        self.conditionBar = nil;
    }
    if (self.selection_details) {
        [_selection_details removeFromSuperview];
        self.selection_details = nil;
    }
    if (self.selection_newBar) {
        [_selection_newBar removeFromSuperview];
        self.selection_newBar = nil;
    }
    if (self.arrow) {
        [[NSNotificationCenter defaultCenter] removeObserver:_arrow name:@"arrow_change" object:nil];
        [_arrow removeFromSuperview];
        self.arrow = nil;
    }
}

-(void)clean{
    if (self.conditionBar) {
        [[NSNotificationCenter defaultCenter] removeObserver:_conditionBar name:@"operations_from_selectionView" object:nil];

        [_conditionBar removeFromSuperview];
        self.conditionBar = nil;
    }
    if (self.selection_details) {
        [_selection_details removeFromSuperview];
        self.selection_details = nil;
    }
    if (self.selection_newBar) {
        [_selection_newBar removeFromSuperview];
        self.selection_newBar = nil;
    }
    if (self.arrow) {
        [[NSNotificationCenter defaultCenter] removeObserver:_arrow name:@"arrow_change" object:nil];
        [_arrow removeFromSuperview];
        self.arrow = nil;
    }
}

-(void)dealloc{
    if (self.conditionBar) {
        [[NSNotificationCenter defaultCenter] removeObserver:_conditionBar name:@"operations_from_selectionView" object:nil];

        [_conditionBar removeFromSuperview];
        self.conditionBar = nil;
    }
    if (self.selection_details) {
        [_selection_details removeFromSuperview];
        self.selection_details = nil;
    }
    if (self.selection_newBar) {
        [_selection_newBar removeFromSuperview];
        self.selection_newBar = nil;
    }
    if (self.arrow) {
        [_arrow removeFromSuperview];
        self.arrow = nil;
    }
    [super dealloc];
}
@end
