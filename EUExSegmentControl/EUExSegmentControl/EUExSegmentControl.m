//
//  EUExSegmentControl.m
//  EUExSegmentControl
//
//  Created by zhijian du on 15/2/2.
//  Copyright (c) 2015年 zhijian du. All rights reserved.
//

#import "EUExSegmentControl.h"
#import "EUtility.h"
#import "JSON.h"
@implementation EUExSegmentControl
-(id)initWithBrwView:(EBrowserView *)eInBrwView{
    self = [super initWithBrwView:eInBrwView];
    if (self) {
    }
    return self;
}

-(void)open:(NSMutableArray *)inArguments{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterBackgroundNoti:) name:UIApplicationDidEnterBackgroundNotification  object:nil];
    NSInteger x= 0, y = 0, width = 0, height = 0;
    NSString *isExpand =@"1";
    NSString *btnIconUp = nil;
    NSString *btnIconDown = nil;
    NSString *subLabelText = nil;
    NSString *morLabelText = nil;
    NSString *maxShow = nil;
    if (inArguments.count > 0) {
        NSDictionary *dict = [[inArguments objectAtIndex:0]JSONValue];
        NSDictionary *dic = [dict objectForKey:@"dataInfo"];
        if ([dic objectForKey:@"expandOpenIcon"] != nil) {
            btnIconUp = [self absPath:[dic objectForKey:@"expandOpenIcon"]];
        }
        if ([dic objectForKey:@"expandCloseIcon"] != nil) {
            btnIconDown = [self absPath:[dic objectForKey:@"expandCloseIcon"]];
        }
        if ([dic objectForKey:@"showedLable"]!= nil) {
            subLabelText = [dic objectForKey:@"showedLable"];
        }
        if ([dic objectForKey:@"addLable"]!= nil) {
            morLabelText = [dic objectForKey:@"addLable"];
        }
        if ([dic objectForKey:@"isExpand"]!= nil) {
            isExpand = [dic objectForKey:@"isExpand"];
        }
        if ([dic objectForKey:@"maxShow"]!= nil) {
            maxShow = [NSString stringWithFormat:@"%@",[dic objectForKey:@"maxShow"]];
        }
        
        NSMutableArray *array1 = [[NSMutableArray alloc]init];
        NSMutableArray *array2 = [[NSMutableArray alloc]init];
        NSArray *array;
        if ([dic objectForKey:@"showData"] != nil) {
            array = [dic objectForKey:@"showData"];
        }
        NSMutableArray *allArray = nil;
        if ([dic objectForKey:@"allData"] != nil) {
            allArray = [dic objectForKey:@"allData"];
        }
        if (array.count > 0) {
            for ( int i = 0; i < array.count; i ++) {
                NSString *string = array[i];
                [array1 addObject:string];
            }
        }
        else
        {
            for (int i = 0; i < 5; i ++) {
                NSString *string = allArray[i];
                [array1 addObject:string];
            }
        }
        
        for (int i = 0; i < allArray.count; i ++) {
            NSString *string = allArray[i];
            [array2 addObject:string];
        }
        for (int i  = 0 ; i < array2.count;  i ++) {
            if ([array containsObject:[array2 objectAtIndex:i]]) {
                [array2 removeObjectAtIndex:i ];
            }
        }
        
        for (int i = 0; i < array1.count; i ++) {
            for (int j = 0; j < array2.count; j ++) {
                if ([array1[i] isEqualToString: array2[j]]) {
                    [array2 removeObject:array2[j]];
                }
            }
        }
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:array1 forKey:@"showData"];
        [userDefaults setObject:array2 forKey:@"allData"];
        [userDefaults setObject:btnIconUp forKey:@"expandOpenIcon"];
        [userDefaults setObject:btnIconDown forKey:@"expandCloseIcon"];
        [userDefaults setObject:subLabelText forKey:@"showedLable"];
        [userDefaults setObject:morLabelText forKey:@"addLable"];
        [userDefaults setObject:maxShow forKey:@"maxShow"];
        
        x = [[dict objectForKey:@"left"] integerValue] ;
        y = [[dict objectForKey:@"top"] integerValue];
        width = [[dict objectForKey:@"width"] integerValue];
        if ([dict objectForKey:@"height"] != nil) {
            height = [[dict objectForKey:@"height"] integerValue];
        }
        [userDefaults setObject:[NSString stringWithFormat:@"%ld",(long)y] forKey:@"top"];
        [array1 release];
        [array2 release];
        [userDefaults synchronize];
    }
    BYConditionBar *conditionBar;
    if (height > 0) {
        conditionBar = [[BYConditionBar alloc] initWithFrame:CGRectMake(x, y, BYScreenWidth, height)];
    }
    else
    {
        conditionBar = [[BYConditionBar alloc] initWithFrame:CGRectMake(x, y, BYScreenWidth, conditionScrollH)];
        
    }
    self.conditionBar = conditionBar;
    [conditionBar release];
    [EUtility brwView:self.meBrwView addSubview:self.conditionBar];
    
    
    self.conditionBar.callBackBlock = ^(NSMutableDictionary *callBackDate){
        if ([self.isShow isEqualToString:@"0"]) {
            self.isShow = nil;
        }else
        {
            if(callBackDate){
                NSString *jsonStr = [NSString stringWithFormat:@"if(uexSegmentControl.onItemClick != null){uexSegmentControl.onItemClick(%@);}",[callBackDate JSONFragment]];
                [EUtility brwView:meBrwView evaluateScript:jsonStr];
            }
            self.isShow = nil;
        }
    };
    self.conditionBar.dataChangeBlock = ^(NSMutableDictionary *dataChangeDate){
        if (dataChangeDate) {
            NSString *jsonStr = [NSString stringWithFormat:@"if(uexSegmentControl.onDataChange !=null){uexSegmentControl.onDataChange(%@)}",[dataChangeDate JSONFragment]];
            [EUtility brwView:meBrwView evaluateScript:jsonStr];
        }
    };
    
    if (height > 0) {
        BYSelectNewBar *selection_newBar = [[BYSelectNewBar alloc] initWithFrame:CGRectMake(x, y, BYScreenWidth, height)];
        self.selection_newBar = selection_newBar;
        [selection_newBar release];
    }
    else
    {
        BYSelectNewBar *selection_newBar = [[BYSelectNewBar alloc] initWithFrame:CGRectMake(x, y, BYScreenWidth, conditionScrollH)];
        self.selection_newBar = selection_newBar;
        [selection_newBar release];
    }
    [EUtility brwView:self.meBrwView addSubview:self.selection_newBar];
    
    BYSelectionDetails *selection_details = [[BYSelectionDetails alloc] initWithFrame:CGRectMake(0, BYScreenHeight, BYScreenWidth, BYScreenHeight-conditionScrollH)];
    self.selection_details = selection_details;
    [selection_details release];
    [EUtility brwView:self.meBrwView insertSubView:self.selection_details belowSubView:self.conditionBar];
    
    if ([isExpand integerValue] == 1) {
        if (height > 0) {
            SelectionButton *arrow = [[SelectionButton alloc] initWithFrame:CGRectMake(BYScreenWidth-arrow_width, y, arrow_width, height)];
            self.arrow = arrow;
            [arrow release];
            self.arrow.Detail =self.selection_details;
            self.arrow.Newbar =self.selection_newBar;
        }
        else
        {
            SelectionButton *arrow = [[SelectionButton alloc] initWithFrame:CGRectMake(BYScreenWidth-arrow_width, y, arrow_width, conditionScrollH)];
            self.arrow = arrow;
            [arrow release];
            self.arrow.Detail =self.selection_details;
            self.arrow.Newbar =self.selection_newBar;
        }
        [EUtility brwView:self.meBrwView addSubview:self.arrow];
    }
    
}
- (void)enterBackgroundNoti:(NSNotification *)noti
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"segmentIndex"] != nil) {
        [userDefaults removeObjectForKey:@"segmentIndex"];
    }
    
}
-(void)setCurrentItem:(NSMutableArray *)inArguments{
    if (inArguments.count >0) {
        NSDictionary *dic = [[inArguments objectAtIndex:0] JSONValue];
        if (dic.count > 1) {
            NSString *isShow = [NSString stringWithFormat:@"%@",[dic objectForKey:@"isCallBack"]];
            self.isShow = isShow;
        }
        else
        {
            self.isShow = @"1";
        }
        NSString *index = [NSString stringWithFormat:@"%@",[dic objectForKey:@"index"]];
        
        [self.conditionBar viewSelectWithOption:index];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:index  forKey:@"segmentIndex"];
        
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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"showData"] != nil) {
        [userDefaults removeObjectForKey:@"showData"];
    }
    if ([userDefaults objectForKey:@"allData"] != nil) {
        [userDefaults removeObjectForKey:@"allData"];
    }
    if ([userDefaults objectForKey:@"expandOpenIcon"] != nil) {
        [userDefaults removeObjectForKey:@"expandOpenIcon"];
    }
    if ([userDefaults objectForKey:@"expandCloseIcon"] != nil) {
        [userDefaults removeObjectForKey:@"expandCloseIcon"];
    }
    if ([userDefaults objectForKey:@"showedLable"] != nil) {
        [userDefaults removeObjectForKey:@"showedLable"];
    }
    if ([userDefaults objectForKey:@"addLable"] != nil) {
        [userDefaults removeObjectForKey:@"addLable"];
    }
    if ([userDefaults objectForKey:@"top"] != nil) {
        [userDefaults removeObjectForKey:@"top"];
    }
    if ([userDefaults objectForKey:@"segmentIndex"] != nil) {
        [userDefaults removeObjectForKey:@"segmentIndex"];
    }
    if (self.isShow) {
        self.isShow = nil;
    }
    if (self.conditionBar.dataDictionary) {
        self.conditionBar.dataDictionary = nil;
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
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
    if (self.isShow) {
        self.isShow = nil;
    }
    if (self.conditionBar.dataDictionary) {
        self.conditionBar.dataDictionary = nil;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"segmentIndex"] != nil) {
        [userDefaults removeObjectForKey:@"segmentIndex"];
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
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
    if (self.isShow) {
        self.isShow = nil;
    }
    if (self.conditionBar.dataDictionary) {
        self.conditionBar.dataDictionary = nil;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"segmentIndex"] != nil) {
        [userDefaults removeObjectForKey:@"segmentIndex"];
    }
    [super dealloc];
}
@end
