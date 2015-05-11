//
//  BYConditionBar.m
//  BYDailyNews
//
//  Created by bassamyan on 15/1/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "BYConditionBar.h"

@interface BYConditionBar()
@property (nonatomic, assign) CGFloat max_width;

@property (nonatomic, strong)   UIView *buttonBg_view;
@property (nonatomic, strong)   UIButton *select_button;

@property (nonatomic, strong) NSMutableArray *lists;
@property (nonatomic, strong) NSMutableArray *buttons_lists;

@end

@implementation BYConditionBar
{
    CGFloat first_buttonX ;
}
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = Color_maingray;
        [self makeConditionBar];
    }
    return self;
}

-(NSMutableArray *)lists
{
    if (_lists == nil) {
        _lists = [NSMutableArray array];
    }
    return _lists;
}

-(NSMutableArray *)buttons_lists
{
    if (_buttons_lists == nil) {
        _buttons_lists = [NSMutableArray array];
    }
    return _buttons_lists;
}

/******************************
 
 初始化conditionBar
 
 ******************************/
-(void)makeConditionBar
{
    self.max_width = 20;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"properties" ofType:@"plist"];
//    _lists = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    _lists = [[NSMutableArray alloc] init];
    _lists = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"array1"]];
//    _lists = [defaults objectForKey:@"array1"];
    self.showsHorizontalScrollIndicator = NO;
    CGFloat first_buttonW = 0;

    for (int i =0; i<_lists.count; i++) {
        UIButton *button = [self makePropertyButtonWithTitle:_lists[i]];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *index = [userDefaults objectForKey:@"index"];
        if ([index integerValue]) {
            if ( i == [index integerValue] ) {
                button.selected = YES;
                self.select_button = button;
                first_buttonW = [self calculateSizeWithFont:16 Width:MAXFLOAT Height:conditionScrollH Text:_lists[i]].size.width;
                first_buttonX =  button.frame.origin.x;
            }
        }else{
            if (i == 0) {
                button.selected = YES;
                self.select_button = button;
                first_buttonW = [self calculateSizeWithFont:16 Width:MAXFLOAT Height:conditionScrollH Text:_lists[i]].size.width;
                first_buttonX =  button.frame.origin.x;

            }
        }

        [self addSubview:button];
    }
    self.contentSize = CGSizeMake(self.max_width+50, conditionScrollH);


    
    self.buttonBg_view = [[UIView alloc] initWithFrame:CGRectMake(first_buttonX - 10 ,(conditionScrollH-20)/2  ,first_buttonW+20, 20)];
    self.buttonBg_view.backgroundColor = Color_main;
    self.buttonBg_view.layer.cornerRadius = 4;
    [self insertSubview:self.buttonBg_view atIndex:0];

    [self viewSelectWithButton:self.select_button];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getOperationsWithNoti:)
                                                 name:@"operations_from_selectionView"
                                               object:nil];
}

-(UIButton *)makePropertyButtonWithTitle:(NSString *)title
{
    CGFloat buttonW = [self calculateSizeWithFont:16 Width:MAXFLOAT Height:conditionScrollH Text:title].size.width;
    UIButton *property_button = [[UIButton alloc] initWithFrame:CGRectMake(self.max_width, 0, buttonW, conditionScrollH)];
    property_button.titleLabel.font = [UIFont systemFontOfSize:16];
    [property_button setTitle:title forState:0];
    [property_button setTitleColor:Color_gray forState:0];
    [property_button setTitleColor:[UIColor whiteColor] forState:1<<2];
    [property_button setTitleColor:Color_gray forState:1<<0];
    [property_button addTarget:self
                        action:@selector(viewSelectWithButton:)
              forControlEvents:1 << 6];
    self.max_width += buttonW+32;
    [self.buttons_lists addObject:property_button];
    return property_button;
}

//外部调用
-(void)viewSelectWithOption:(NSString *)str{
    
    if(str){
        if ([str integerValue] < self.buttons_lists.count) {
            [self viewSelectWithButton:[self.buttons_lists objectAtIndex:[str integerValue]]];
        }
    }
    
}

//内部调用
-(void)viewSelectWithButton:(UIButton *)button
{
    
    if (self.select_button != button) {
        button.selected = YES;
        [button setTitleColor:[UIColor whiteColor] forState:0];
        self.select_button.selected = NO;
        [self.select_button setTitleColor:Color_gray forState:0];
        self.select_button = button;
    }
    CGFloat animate_time = 0.3;
    [UIView animateWithDuration:animate_time animations:^{

        CGRect buttonBg_view_frame     = self.buttonBg_view.frame;
        buttonBg_view_frame.size.width = button.frame.size.width+20;
        self.buttonBg_view.frame       = buttonBg_view_frame;
        CGFloat trans_width            = button.frame.origin.x-(buttonBg_view_frame.size.width-button.frame.size.width)/2-10 - first_buttonX + 20;
        self.buttonBg_view.transform  = CGAffineTransformMakeTranslation(trans_width, 0);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animate_time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:animate_time animations:^{
            if (button.frame.origin.x > BYScreenWidth-40-button.frame.size.width) {
                self.contentOffset = CGPointMake(button.frame.origin.x-200, 0);
            }
            else {
                self.contentOffset = CGPointMake(0, 0);
            }}];
    });
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"click_conditionBarItem"
                                                        object:button
                                                      userInfo:@{@"title":button.titleLabel.text}];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"click_conditionBarItem" object:nil];
    
    
    
    NSString *title = button.titleLabel.text;
    for (int i=0; i< self.lists.count ;i++) {
        if ([title isEqualToString:[self.lists objectAtIndex:i]]) {
            NSLog(@"%@         %d",title,i);
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setObject:title forKey:@"title"];
            [dict setObject:[NSString stringWithFormat:@"%d",i] forKey:@"i"];
            if (self.callBackBlock) {
                self.callBackBlock(dict);
            }
            break;
        }
    }
}



-(CGRect)calculateSizeWithFont:(NSInteger)Font Width:(NSInteger)Width Height:(NSInteger)Height Text:(NSString *)Text
{
    CGRect size;
    if ([[UIDevice currentDevice].systemVersion floatValue] >7.0) {
        NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:Font]};
//        boundingRectWithSize   7.0之后才有的方法
        size= [Text boundingRectWithSize:CGSizeMake(Width, Height)
                                         options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attr
                                         context:nil];
    }else{
        CGSize si = [Text sizeWithFont:[UIFont systemFontOfSize:Font]];
        size = CGRectMake(0, 0, si.width, si.height);
    }
    return size;
}


/******************************
 
 通知相关
 
 ******************************/

-(void)getOperationsWithNoti:(NSNotification *)noti
{
    NSString *noti_name  = [noti.userInfo objectForKey:@"noti_name"];
    NSString *noti_title = [noti.userInfo objectForKey:@"noti_title"];
    int noti_index       = [[noti.userInfo objectForKey:@"noti_index"] intValue];
    
    if ([noti_name isEqualToString:@"select_itemOfView"]) {
        NSInteger index = [self findIndexOfListsWithTitle:noti_title];
        [self viewSelectWithButton:self.buttons_lists[index]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"arrow_change" object:self];
    }else if ([noti_name isEqualToString:@"add_newItem"]){
        [self.lists addObject:noti_title];
        [self addSubview:[self makePropertyButtonWithTitle:noti_title]];
        self.contentSize = CGSizeMake(self.max_width+50, conditionScrollH);
    }else if ([noti_name isEqualToString:@"remove_item"]){
        if ([self.select_button.titleLabel.text isEqualToString:noti_title]) {
            [self viewSelectWithButton:self.buttons_lists[0]];
        }
        [self removeItemWithTitle:noti_title];
        [self resetFrame];
    }else if ([noti_name isEqualToString:@"move_itemToLast"]){
        [self switchPositionWithNotiTitle:noti_title index:_lists.count-1];
    }else if ([noti_name isEqualToString:@"switch_position"]){
        [self switchPositionWithNotiTitle:noti_title index:noti_index];
    }
}

-(void)switchPositionWithNotiTitle:(NSString *)noti_title index:(NSInteger)index
{
    UIButton *button = self.buttons_lists[[self findIndexOfListsWithTitle:noti_title]];
    [self.lists removeObject:noti_title];
    [self.buttons_lists removeObject:button];
    [self.lists insertObject:noti_title atIndex:index];
    [self.buttons_lists insertObject:button atIndex:index];
    [self viewSelectWithButton:self.select_button];
    [self resetFrame];
}

-(void)removeItemWithTitle:(NSString *)title
{
    NSInteger index = [self findIndexOfListsWithTitle:title];
    UIButton *select_button = self.buttons_lists[index];
    [self.buttons_lists[index] removeFromSuperview];
    [self.buttons_lists removeObject:select_button];
    [self.lists removeObject:title];
}

-(NSInteger)findIndexOfListsWithTitle:(NSString *)title
{
    NSInteger index = 0;
    for (int i =0; i < _lists.count; i++) {
        if ([title isEqualToString:_lists[i]]) {
            index = i;
        }
    }
    return index;
}

-(void)resetFrame
{
    self.max_width = 20;
    for (int i = 0; i < self.lists.count; i++) {
        [UIView animateWithDuration:0.0001 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            CGFloat buttonW = [self calculateSizeWithFont:16 Width:MAXFLOAT Height:conditionScrollH Text:self.lists[i]].size.width;
            [[self.buttons_lists objectAtIndex:i] setFrame:CGRectMake(self.max_width, 0, buttonW, conditionScrollH)];
            self.max_width += 32 + buttonW;
        } completion:^(BOOL finished){
        }];
    }
    self.contentSize = CGSizeMake(self.max_width+50, conditionScrollH);
}

@end
