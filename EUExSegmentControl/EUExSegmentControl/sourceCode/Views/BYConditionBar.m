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

@property (nonatomic, assign) int firstIndex;
@property (nonatomic, assign) NSInteger listCount;
@end

@implementation BYConditionBar
{
    CGFloat first_buttonX ;
}
@synthesize dataDictionary,deleatWith;

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
    dispatch_async(dispatch_get_main_queue(), ^{
        self.max_width = 20;
        dataDictionary = [NSMutableDictionary dictionary];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _lists = [[NSMutableArray alloc] init];
        NSArray *array = [defaults objectForKey:@"showData"];
        for ( int i = 0; i < array.count; i ++) {
            NSString *string = [NSString stringWithFormat:@"%@",array[i]];
            [_lists addObject:string];
        }
        self.showsHorizontalScrollIndicator = NO;
        CGFloat first_buttonW = 0;
        
        for (int i =0; i<_lists.count; i++) {
            UIButton *button = [self makePropertyButtonWithTitle:_lists[i]];
//            [dataDictionary setObject:_lists[i] forKey:[NSString stringWithFormat:@"%d",i]];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSNumber *index = [userDefaults objectForKey:@"segmentIndex"];
            if (index && i == [index integerValue] ) {
                button.selected = YES;
                self.select_button = button;
                first_buttonW = [self calculateSizeWithFont:16 Width:MAXFLOAT Height:self.frame.size.height Text:_lists[i]].size.width;
                first_buttonX =  button.frame.origin.x;
            }else{
                if (i == 0) {
                    button.selected = YES;
                    self.select_button = button;
                    first_buttonW = [self calculateSizeWithFont:16 Width:MAXFLOAT Height:self.frame.size.height Text:_lists[i]].size.width;
                    first_buttonX =  button.frame.origin.x;
                    
                }
            }
            
            [self addSubview:button];
        }
        self.contentSize = CGSizeMake(self.max_width+50, self.frame.size.height);
//        [self resetFrame];
        NSLog(@"self.frame.size.height   %f",self.frame.size.height);
        
        self.buttonBg_view = [[UIView alloc] initWithFrame:CGRectMake(first_buttonX - 10 ,(self.frame.size.height-20)/2  ,first_buttonW+20, 20)];
        self.buttonBg_view.backgroundColor = Color_main;
        self.buttonBg_view.layer.cornerRadius = 4;
        [self insertSubview:self.buttonBg_view atIndex:0];
        
        [self viewSelectWithButton:self.select_button];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(getOperationsWithNoti:)
                                                     name:@"operations_from_selectionView"
                                                   object:nil];
    });
}

-(UIButton *)makePropertyButtonWithTitle:(NSString *)title
{
    CGFloat buttonW = [self calculateSizeWithFont:16 Width:MAXFLOAT Height:self.frame.size.height Text:title].size.width;
    UIButton *property_button = [[UIButton alloc] initWithFrame:CGRectMake(self.max_width, 0, buttonW, self.frame.size.height)];
    property_button.titleLabel.font = [UIFont systemFontOfSize:16];
    [property_button setTitle:title forState:0];
    [property_button setTitleColor:Color_gray forState:0];
    [property_button setTitleColor:[UIColor whiteColor] forState:1<<2];
    [property_button setTitleColor:Color_gray forState:1<<0];
    [property_button addTarget:self
                        action:@selector(viewSelectWithButton:)
              forControlEvents:UIControlEventTouchUpInside];
    self.max_width += buttonW + 32;
    [self.buttons_lists addObject:property_button];
    return property_button;
}

//外部调用
- (void)selectButtonWithIndex:(NSInteger)index{
    if (index >= 0 && index < self.buttons_lists.count) {
        [self viewSelectWithButton:self.buttons_lists[index]];
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
    //    点击后button位置调整
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animate_time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:animate_time animations:^{
            
            if (button.frame.origin.x > BYScreenWidth -40 -20) {
                
                self.contentOffset = CGPointMake(button.frame.origin.x-BYScreenWidth/2 -20, 0);
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
//            NSLog(@"%@         %d",title,i);
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setObject:title forKey:@"name"];
            [dict setObject:[NSString stringWithFormat:@"%d",i] forKey:@"index"];
            if (self.callBackBlock) {
                self.callBackBlock(dict);
            }
            break;
        }
    }
}
-(void)viewSelectWithButtons:(UIButton *)button
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
        CGFloat trans_width;
        CGRect buttonBg_view_frame     = self.buttonBg_view.frame;
        buttonBg_view_frame.size.width = button.frame.size.width+20;
        self.buttonBg_view.frame       = buttonBg_view_frame;
        if (self.select_button == button) {
            buttonBg_view_frame.size.width = self.select_button.frame.size.width+20;
            if (self.listCount == self.lists.count) {
                trans_width = button.frame.origin.x - 20;
            }
            else
            {
                trans_width = self.select_button.frame.origin.x- self.deleatWith - 32 -20;
            }
            
        }else
        {
            trans_width = button.frame.origin.x-(buttonBg_view_frame.size.width-button.frame.size.width)/2-10 - first_buttonX + 20;
        }
        self.buttonBg_view.transform  = CGAffineTransformMakeTranslation(trans_width, 0);
    }];
    //    点击后button位置调整
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animate_time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:animate_time animations:^{
            if (button.frame.origin.x > BYScreenWidth-40-button.frame.size.width) {
                self.contentOffset = CGPointMake(button.frame.origin.x-170, 0);
            }
            else {
                self.contentOffset = CGPointMake(0, 0);
            }}];
        
    });
    [[NSNotificationCenter defaultCenter] postNotificationName:@"click_conditionBarItem"
                                                        object:button
                                                      userInfo:@{@"title":button.titleLabel.text}];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"click_conditionBarItem" object:nil];
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
            //       点击回调到主页
            NSInteger index = [self findIndexOfListsWithTitle:noti_title];
            [self viewSelectWithButton:self.buttons_lists[index]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"arrow_change" object:self];
        }else if ([noti_name isEqualToString:@"add_newItem"]){
            //       由下到上 点击添加后的回调
            [self.lists addObject:noti_title];
            [self addSubview:[self makePropertyButtonWithTitle:noti_title ]];
            //        添加到字典中
            [self addTitle:self.lists andIndex:(int)self.lists.count -1];
            self.contentSize = CGSizeMake(self.max_width+50, self.frame.size.height);
            if ([[UIDevice currentDevice].systemVersion floatValue] >9.0) {
                [self resetFrame];
            }
            else
            {
            [self resetFrames];
            }
        }else if ([noti_name isEqualToString:@"remove_item"]){
            //        删除时
            [self viewSelectWithButton:self.buttons_lists[0]];
            [self removeItemWithTitle:noti_title];
            [self removeTitle:self.lists andIndex:(int)noti_index];
            if ([[UIDevice currentDevice].systemVersion floatValue] >9.0) {
                [self resetFrame];
            }
            else
            {
                [self resetFrames];
            }
        }else if ([noti_name isEqualToString:@"switch_position"]){
            //        编辑时移动位置
            if ( self.firstIndex == 0) {
                self.firstIndex = noti_index;
            }
            self.listCount = self.lists.count;
            [self switchPositionWithNotiTitles:noti_title index:noti_index];
        }else if ([noti_name isEqualToString:@"move_itemToLast"]){
            [self switchPositionWithNotiTitle:noti_title index:noti_index];
            //        调换位置时
            [self moveTitle:self.lists atIndex:self.firstIndex toNext:noti_index];
            self.firstIndex = 0;
        }
 
}

- (void)addTitle:(NSMutableArray *)title andIndex:(int)index
{
    [dataDictionary setObject:title forKey:@"shows"];
    if (self.dataChangeBlock) {
        self.dataChangeBlock(dataDictionary);
    }
}
- (void)removeTitle:(NSMutableArray *)title  andIndex:(int)index
{
    [dataDictionary setObject:title forKey:@"shows"];
    if (self.dataChangeBlock) {
        self.dataChangeBlock(dataDictionary);
    }
}
- (void)moveTitle:(NSMutableArray *)title  atIndex:(int)index  toNext:(int)nextIndex
{
     [dataDictionary setObject:title forKey:@"shows"];
    if (self.dataChangeBlock) {
        self.dataChangeBlock(dataDictionary);
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
    if ([[UIDevice currentDevice].systemVersion floatValue] >9.0) {
        [self resetFrame];
    }
    else
    {
        [self resetFrames];
    }
}

-(void)switchPositionWithNotiTitles:(NSString *)noti_title index:(NSInteger)index
{
    UIButton *button = self.buttons_lists[[self findIndexOfListsWithTitle:noti_title]];
    [self.lists removeObject:noti_title];
    [self.buttons_lists removeObject:button];
    [self.lists insertObject:noti_title atIndex:index];
    [self.buttons_lists insertObject:button atIndex:index];
    CGFloat buttonW = [self calculateSizeWithFont:16 Width:MAXFLOAT Height:self.frame.size.height Text:noti_title].size.width ;
    self.deleatWith = buttonW;
    if ([noti_title isEqualToString:self.select_button.titleLabel.text]) {
        [self viewSelectWithButtons:self.select_button];
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >9.0) {
        [self resetFrame];
    }
    else
    {
        [self resetFrames];
    }
}
-(void)removeItemWithTitle:(NSString *)title
{
    NSInteger index = [self findIndexOfListsWithTitle:title];
    NSInteger firstIndex = [self findIndexOfListsWithTitle:self.select_button.titleLabel.text];
    CGFloat buttonW = [self calculateSizeWithFont:16 Width:MAXFLOAT Height:self.frame.size.height Text:title].size.width ;
    self.deleatWith = buttonW;
    UIButton *select_button = self.buttons_lists[index];
    [self.buttons_lists[index] removeFromSuperview];
    [self.buttons_lists removeObject:select_button];
    [self.lists removeObject:title];
    if (firstIndex > index && firstIndex != 0) {
        UIButton *select_button = self.buttons_lists[firstIndex - 1];
        [self viewSelectWithButtons: select_button];
    }
    
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
            CGFloat buttonW = [self calculateSizeWithFont:16 Width:MAXFLOAT Height:self.frame.size.height Text:self.lists[i]].size.width ;
            [[self.buttons_lists objectAtIndex:i] setFrame:CGRectMake(self.max_width, 0, buttonW, self.frame.size.height)];
            self.max_width  += buttonW + 32;
        } completion:^(BOOL finished){
            
        }];
    }
    self.contentSize = CGSizeMake(self.max_width+50, self.frame.size.height);
}
-(void)resetFrames
{
    self.max_width = 20;
    for (int i = 0; i < self.lists.count; i++) {
            CGFloat buttonW = [self calculateSizeWithFont:16 Width:MAXFLOAT Height:self.frame.size.height Text:self.lists[i]].size.width ;
            [[self.buttons_lists objectAtIndex:i] setFrame:CGRectMake(self.max_width, 0, buttonW, self.frame.size.height)];
            self.max_width  += buttonW + 32;
    };
    self.contentSize = CGSizeMake(self.max_width+50, self.frame.size.height);
}
@end
