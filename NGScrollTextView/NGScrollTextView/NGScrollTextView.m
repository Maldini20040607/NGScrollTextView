//
//  NGScrollTextView.m
//  NGScrollTextView
//
//  Created by Ning Gang on 2017/3/21.
//  Copyright © 2017年 Nelson. All rights reserved.
//

#import "NGScrollTextView.h"
#import "NGScrollContentView.h"

@interface NGScrollTextView()<NGScrollContentViewDelegate>

@property (nonatomic,strong) UIImageView * iconIV;

@property (nonatomic,assign) NSInteger currentPageIndex;

@property (nonatomic,strong) NSMutableArray * dataArr;
@property (nonatomic,strong) NSMutableArray * contentViews;

@property (nonatomic,strong) NSTimer* animationTimer;

@property (nonatomic,strong) UIView * gestureView;

@property (nonatomic,weak) id<NGScrollTextViewDelegate> delegate;

@end

@implementation NGScrollTextView

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

-(UIImageView *)iconIV
{
    if (!_iconIV) {
        _iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 12, 15, 15)];
    }
    return _iconIV;
}

-(UIView * )gestureView
{
    if (!_gestureView) {
        _gestureView = [[UIView alloc] initWithFrame:CGRectMake(self.iconIV.frame.origin.x + self.iconIV.frame.size.width + 5, 0, SCREEN_WIDTH - 32 , self.frame.size.height)];
        _gestureView.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [_gestureView addGestureRecognizer:tapGesture];
        
    }
    return _gestureView;
}

-(id)initWithFrame:(CGRect) rect Delegate:(id<NGScrollTextViewDelegate>) delegate
{
    if (self = [super initWithFrame:rect]) {
        
        self.delegate = delegate;
        
        self.currentPageIndex = 0;
        
        self.clipsToBounds = YES;
        
        self.contentViews = [[NSMutableArray alloc] init];
        
        self.dataArr = [[NSMutableArray alloc] init];
        
        [self addSubview:self.iconIV];

    }
    return self;
}



-(void)setDataWithImage:(NSString*)imagePath contentArr:(NSArray<NSDictionary*>*)arr
{
    
    for (UIView * view in self.subviews) {
        [view removeFromSuperview];
    }
    
    [self.dataArr removeAllObjects];
    [self.contentViews removeAllObjects];
    
    [self.dataArr addObjectsFromArray:arr];
    
    self.iconIV.image = [UIImage imageNamed:imagePath];
    for (int i = 0; i < arr.count; i++) {
        
        NSDictionary * dict = (NSDictionary *)[arr objectAtIndex:i];;
        NSString *text = [dict objectForKey:@"content"];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByClipping;
        
        NSDictionary *textAttribute = @{NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName: [UIFont systemFontOfSize:26],NSForegroundColorAttributeName: [UIColor blackColor]};
        
        
        if (text.length > 0) {
            
        }
        else
        {
            text = @" ";
        }
        
        NSMutableAttributedString * attText = [[NSMutableAttributedString alloc] initWithString:text attributes:textAttribute];

        
        NSAttributedString * attText1 = [[NSAttributedString alloc] initWithString:@"点击查看详情" attributes:textAttribute];
        
        [attText appendAttributedString:attText1];

        NGScrollContentView * scrollContentView = [[NGScrollContentView alloc] initWithFrame:CGRectMake(self.iconIV.frame.origin.x + self.iconIV.frame.size.width + 5, 0, SCREEN_WIDTH - 32 , self.frame.size.height) Text:attText Attribute:textAttribute Delegate:self];
        
        [self.contentViews addObject:scrollContentView];
        
    }
    
    if (self.contentViews.count > 0) {
        
        [self.contentViews objectAtIndex:[self getValidNextPageIndexWithPageIndex:self.currentPageIndex]];
        NGScrollContentView * view1 = (NGScrollContentView *)[self.contentViews objectAtIndex:[self getValidNextPageIndexWithPageIndex:self.currentPageIndex]];
        
        [self addSubview:view1];
        [view1 runText];
        
        [self addSubview:self.iconIV];
        [self addSubview:self.gestureView];
    }
    
}


- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)currentPageIndex;
{
    if(currentPageIndex == -1) {
        return self.contentViews.count - 1;
    } else if (currentPageIndex >= self.contentViews.count) {
        return 0;
    } else {
        return currentPageIndex;
    }
}

-(void)animationTimerDidFired:(NSTimer *)timer{
    
    if (self.contentViews.count > 1)
    {
        NGScrollContentView * view1 = (NGScrollContentView *)[self.contentViews objectAtIndex:[self getValidNextPageIndexWithPageIndex:self.currentPageIndex]];

        NGScrollContentView * view2 = (NGScrollContentView *)[self.contentViews objectAtIndex:[self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1]];
        
        [self addSubview:view2];
        [self addSubview:self.gestureView];
        
        view2.frame = CGRectMake(view2.frame.origin.x, view2.frame.size.height, view2.frame.size.width, view2.frame.size.height);
        
        [UIView animateWithDuration:0.3 delay:2 options:UIViewAnimationOptionCurveLinear animations:^{
            
            view1.frame = CGRectMake(view1.frame.origin.x, -view1.frame.size.height, view1.frame.size.width, view1.frame.size.height);
            view2.frame = CGRectMake(view2.frame.origin.x, 0, view2.frame.size.width, view2.frame.size.height);
            
            
            
        } completion:^(BOOL finished) {
            
            self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
            [view2 runText];
            
        }];
    }
    else
    {
        NGScrollContentView * view1 = (NGScrollContentView *)[self.contentViews objectAtIndex:[self getValidNextPageIndexWithPageIndex:self.currentPageIndex]];
        
        
        [UIView animateWithDuration:0.3 delay:2 options:UIViewAnimationOptionCurveLinear animations:^{
            
        } completion:^(BOOL finished) {
            
            self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
            [view1 runText];
            
        }];
    }
}

-(void)tapAction
{
   
    if ([self.delegate respondsToSelector:@selector(clickScrollTextMessage:)]) {
        [self.delegate clickScrollTextMessage: (NSDictionary *) [self.dataArr objectAtIndex:[self getValidNextPageIndexWithPageIndex:self.currentPageIndex]] ];
        
    }    
}
-(void)textFlowFinished
{
    NGScrollContentView * view1 = (NGScrollContentView *)[self.contentViews objectAtIndex:[self getValidNextPageIndexWithPageIndex:self.currentPageIndex]];
    [view1 setNeedsDisplay];
    
    [self.animationTimer invalidate];
    self.animationTimer = nil;
    
    [self.animationTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:2]];
}

-(NSTimer *)animationTimer
{
    if (!_animationTimer) {
        _animationTimer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(animationTimerDidFired:) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop]addTimer:_animationTimer forMode:NSDefaultRunLoopMode];
    }
    return _animationTimer;
}

@end
