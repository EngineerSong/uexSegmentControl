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


@interface EUExSegmentControl()
@property (nonatomic , assign) BOOL skipItemClickCallback;
@property BOOL isOpened;
@end


@implementation EUExSegmentControl


-(id)initWithBrwView:(EBrowserView *)eInBrwView{
    if (self = [super initWithBrwView:eInBrwView]) {
        _isOpened = NO;
    }
    return self;
}


-(void)open:(NSMutableArray *)inArguments{
    if (_isOpened) {
        return;
    }
    NSInteger x= 0, y = 0, width = 0, height = BYScreenHeight;
    NSString *isExpand =@"1";
    NSString *btnIconUp = nil;
    NSString *btnIconDown = nil;
    NSString *subLabelText = nil;
    NSString *morLabelText = nil;
    NSNumber *maxShow = nil;
    NSInteger mode = 0;
    NSInteger containerIndex = 0;
    NSString *containerID = nil;
    
    if(inArguments.count<1){
        return;
    }
    NSDictionary *dict = [[inArguments objectAtIndex:0] JSONValue];
    NSDictionary *dic = [dict objectForKey:@"dataInfo"];
    if ([dic objectForKey:@"expandOpenIcon"] ) {
        btnIconUp = [self absPath:[dic objectForKey:@"expandOpenIcon"]];
    }
    if ([dic objectForKey:@"expandCloseIcon"] ) {
        btnIconDown = [self absPath:[dic objectForKey:@"expandCloseIcon"]];
    }
    if ([dic objectForKey:@"showedLable"]) {
        subLabelText = [dic objectForKey:@"showedLable"];
    }
    if ([dic objectForKey:@"addLable"]) {
        morLabelText = [dic objectForKey:@"addLable"];
    }
    if ([dic objectForKey:@"isExpand"]) {
        isExpand = [dic objectForKey:@"isExpand"];
    }
    if ([dic objectForKey:@"maxShow"]) {
        maxShow = @([[dic objectForKey:@"maxShow"] intValue]);
    }
    
    NSMutableArray *array1 = [[NSMutableArray alloc]init];
    NSMutableArray *array2 = [[NSMutableArray alloc]init];
    NSArray *array;
    if ([dic objectForKey:@"showData"] ) {
        array = [dic objectForKey:@"showData"];
    }
    NSMutableArray *allArray = nil;
    if ([dic objectForKey:@"allData"] ) {
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
    if ([dict objectForKey:@"height"] ) {
        height = [[dict objectForKey:@"height"] integerValue];
    }
    if ([dict objectForKey:@"mode"]) {
        mode= [[dict objectForKey:@"mode"] integerValue];
    }
    if ([dict objectForKey:@"containerID"]) {
         containerID = [dict objectForKey:@"containerID"] ;
    }
    if ([dict objectForKey:@"containerIndex"]) {
         containerIndex = [[dict objectForKey:@"containerIndex"] integerValue];
    }
   
    [userDefaults setObject:[NSString stringWithFormat:@"%ld",(long)y] forKey:@"top"];
    [userDefaults synchronize];
    
    self.conditionBar = [[BYConditionBar alloc] initWithFrame:CGRectMake(x, y, BYScreenWidth, conditionScrollH)];
    if (mode == 0) {
        [EUtility brwView:self.meBrwView addSubview:self.conditionBar];
    }else{
        [EUtility brwView:self.meBrwView addSubviewToContainer:self.conditionBar WithIndex:containerIndex andIndentifier:containerID];
    }
    
    
    
     __weak typeof(self) weakSelf = self;
    self.conditionBar.callBackBlock = ^(NSMutableDictionary *callBackData){
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (!strongSelf.skipItemClickCallback) {
            NSString *jsonStr = [NSString stringWithFormat:@"if(uexSegmentControl.onItemClick != null){uexSegmentControl.onItemClick(%@);}",[callBackData JSONFragment]];
            [EUtility brwView:strongSelf.meBrwView evaluateScript:jsonStr];
        }
        strongSelf.skipItemClickCallback = NO;
    };
    self.conditionBar.dataChangeBlock = ^(NSMutableDictionary *dataChangeData){
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (dataChangeData) {
            NSString *jsonStr = [NSString stringWithFormat:@"if(uexSegmentControl.onDataChange !=null){uexSegmentControl.onDataChange(%@)}",[dataChangeData JSONFragment]];
            [EUtility brwView:strongSelf.meBrwView evaluateScript:jsonStr];
        }
        
    };
    
    
    self.selection_details = [[BYSelectionDetails alloc] initWithFrame:CGRectMake(0, BYScreenHeight, BYScreenWidth, height - conditionScrollH)];
   
    if (mode == 0) {
        [EUtility brwView:self.meBrwView addSubview:self.selection_details];
    }else{
        [EUtility brwView:self.meBrwView addSubviewToContainer:self.selection_details WithIndex:containerIndex andIndentifier:containerID];
    }
    
    self.selection_newBar = [[BYSelectNewBar alloc] initWithFrame:CGRectMake(x, y, BYScreenWidth, conditionScrollH)];
    if (mode == 0) {
        [EUtility brwView:self.meBrwView addSubview:self.selection_newBar];
    }else{
        [EUtility brwView:self.meBrwView addSubviewToContainer:self.selection_newBar WithIndex:containerIndex andIndentifier:containerID];
    }
    if ([isExpand integerValue] == 1) {
        self.arrow = [[SelectionButton alloc] initWithFrame:CGRectMake(BYScreenWidth-arrow_width, y, arrow_width, conditionScrollH)];
        self.arrow.Detail =self.selection_details;
        self.arrow.Newbar =self.selection_newBar;
        if (mode == 0) {
           [EUtility brwView:self.meBrwView addSubview:self.arrow];
        }else{
            [EUtility brwView:self.meBrwView addSubviewToContainer:self.arrow WithIndex:containerIndex andIndentifier:containerID];
        }
        
    }
    _isOpened = YES;
}


+ (void)applicationDidEnterBackground:(UIApplication *)application{
    [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"segmentIndex"];
}




-(void)setCurrentItem:(NSMutableArray *)inArguments{
    if (inArguments.count <1) {
        return;
    }
    NSDictionary *dic = [[inArguments objectAtIndex:0] JSONValue];
    NSNumber *idxNum = @([dic[@"index"] intValue]);
    if (!idxNum) {
        return;
    }
    if ([dic[@"isCallBack"] integerValue] != 0) {
        self.skipItemClickCallback = YES;
    };
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:idxNum  forKey:@"segmentIndex"];
    [self.conditionBar selectButtonWithIndex:idxNum.integerValue];
}

-(void)close:(NSMutableArray *)inArguments{
    [self clean];
    _isOpened = NO;
}

-(void)clean{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    if (self.conditionBar) {
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
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSArray *udKeys = @[@"showData",@"allData",@"expandOpenIcon",@"expandCloseIcon",@"showedLable",@"addLable",@"top",@"segmentIndex"];
    [udKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [ud setObject:nil forKey:obj];
    }];
    
}

-(void)dealloc{
    [self clean];
}
@end
