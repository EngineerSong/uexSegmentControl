//
//  EUExSegmentControl.m
//  EUExSegmentControl
//
//  Created by zhijian du on 15/2/2.
//  Copyright (c) 2015年 zhijian du. All rights reserved.
//

#import "EUExSegmentControl.h"
#import <AppCanKit/ACEXTScope.h>


@interface EUExSegmentControl()
@property (nonatomic , assign) BOOL skipItemClickCallback;

@end


@implementation EUExSegmentControl


- (instancetype)initWithWebViewEngine:(id<AppCanWebViewEngineObject>)engine{
    self = [super initWithWebViewEngine:engine];
    if (self) {
        
    }
    return self;
}



-(void)open:(NSMutableArray *)inArguments{

    NSInteger x= 0, y = 0, width = 0, height = BYScreenHeight;
    NSString *isExpand =@"1";
    NSString *btnIconUp = nil;
    NSString *btnIconDown = nil;
    NSString *subLabelText = nil;
    NSString *morLabelText = nil;
    NSNumber *maxShow = nil;
    
    
    ACArgsUnpack(NSDictionary *dict) = inArguments;
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
        maxShow = numberArg([dic objectForKey:@"maxShow"]);
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
    [userDefaults setObject:[NSString stringWithFormat:@"%ld",(long)y] forKey:@"top"];
    [userDefaults synchronize];
    

    self.conditionBar = [[BYConditionBar alloc] initWithFrame:CGRectMake(x, y, BYScreenWidth, conditionScrollH)];

    [[self.webViewEngine webView] addSubview:self.conditionBar];
    
    @weakify(self);
    self.conditionBar.callBackBlock = ^(NSMutableDictionary *callBackData){
        @strongify(self);
        
        if (!self.skipItemClickCallback) {
            [self.webViewEngine callbackWithFunctionKeyPath:@"uexSegmentControl.onItemClick" arguments:ACArgsPack(callBackData)];
        }
        self.skipItemClickCallback = NO;
    };
    self.conditionBar.dataChangeBlock = ^(NSMutableDictionary *dataChangeData){
        @strongify(self);
        if (dataChangeData) {
            [self.webViewEngine callbackWithFunctionKeyPath:@"uexSegmentControl.onDataChange" arguments:ACArgsPack(dataChangeData)];
        }

    };
    
    
    self.selection_details = [[BYSelectionDetails alloc] initWithFrame:CGRectMake(0, BYScreenHeight, BYScreenWidth, height - conditionScrollH)];
    [[self.webViewEngine webView] addSubview:self.selection_details];
    
    self.selection_newBar = [[BYSelectNewBar alloc] initWithFrame:CGRectMake(x, y, BYScreenWidth, conditionScrollH)];
    [[self.webViewEngine webView] addSubview:self.selection_newBar];
    
    if ([isExpand integerValue] == 1) {
        self.arrow = [[SelectionButton alloc] initWithFrame:CGRectMake(BYScreenWidth-arrow_width, y, arrow_width, conditionScrollH)];
        self.arrow.Detail =self.selection_details;
        self.arrow.Newbar =self.selection_newBar;
        [[self.webViewEngine webView] addSubview:self.arrow];
    }
    
}


+ (void)applicationDidEnterBackground:(UIApplication *)application{
    [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"segmentIndex"];
}




-(void)setCurrentItem:(NSMutableArray *)inArguments{
    ACArgsUnpack(NSDictionary *dic) = inArguments;
    NSNumber *idxNum = numberArg(dic[@"index"]);
    if (!idxNum) {
        return;
    }
    if ([dic[@"isCallBack"] integerValue] != 0) {
        self.skipItemClickCallback = YES;
    };
    [self.conditionBar selectButtonWithIndex:idxNum.integerValue];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:idxNum  forKey:@"segmentIndex"];
}

-(void)close:(NSMutableArray *)inArguments{
    [self clean];
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
        [ud setValue:nil forKey:obj];
    }];

}

-(void)dealloc{
    [self clean];
}
@end
