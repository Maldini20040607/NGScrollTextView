//
//  NGScrollContentView.m
//  NGScrollTextView
//
//  Created by Ning Gang on 2017/3/21.
//  Copyright © 2017年 Nelson. All rights reserved.
//

#import "NGScrollContentView.h"

@interface NGScrollContentView()

//定时器
@property (nonatomic,strong) NSTimer *timer;

//显示的文本
@property (nonatomic,strong) NSAttributedString *text;

//是否需要滚动
@property (nonatomic,assign) BOOL needFlow;

//文本的字体属性
@property (nonatomic,strong) NSDictionary *attrDict;

@property (nonatomic,weak) id<NGScrollContentViewDelegate> delegate;

////当前第一个控件的索引
//@property (nonatomic,assign) NSInteger startIndex;

//定时器每次执行偏移后，累计的偏移量之和
@property (nonatomic,assign) CGFloat XOffset;

//文本显示一行，需要的大小
@property (nonatomic,assign) CGSize textSize;
//
//@property (nonatomic,assign) NSInteger index;
@end

@implementation NGScrollContentView

#define SPACE_WIDTH 50

- (id)initWithFrame:(CGRect)frame Text:(NSMutableAttributedString *)text Attribute:(NSDictionary *) attrDict Delegate:(id<NGScrollContentViewDelegate>)delegate
{
    if (self = [super initWithFrame:frame])
    {
        self.frame = frame;
        
        self.attrDict = attrDict;
        
        self.text = text;
        
        self.delegate = delegate;
        
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

-(void)runText{
    
    UIFont * font = [self.attrDict objectForKey:NSFontAttributeName];
    
    if (font == nil) {
        font = [UIFont systemFontOfSize:26];
    }

    self.textSize = [self computeTextSize:self.text.string Font:font];
    
    self.XOffset = 0;
    //需要滚动效果
    if (self.textSize.width > self.frame.size.width)
    {
        self.needFlow = YES;
        [self setNeedsDisplay];
        [self startRun];
    }
    else
    {
        [self setNeedsDisplay];
        
        if ([self.delegate respondsToSelector:@selector(textFlowFinished)]) {
            [self.delegate textFlowFinished];
        }
    }
}

- (CGSize)computeTextSize:(NSString *)text Font:(UIFont *) font
{
    if (text == nil)
    {
        return CGSizeMake(0, 0);
    }
    
    CGSize stringSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes: @{NSFontAttributeName: font} context:nil].size;
    
    return stringSize;
}

- (void)startRun
{
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:1]];
}

-(NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    }
    return _timer;
}
//关闭定时器
- (void)cancelRun
{
    if (self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)timerAction
{
    static CGFloat offsetOnce = -1;
    self.XOffset += offsetOnce;
    if (self.XOffset +  self.textSize.width <= self.frame.size.width - 30 )
    {
        
        [self cancelRun];
        
        if ([self.delegate respondsToSelector:@selector(textFlowFinished)]) {
            [self.delegate textFlowFinished];
        }
        
    }
    [self setNeedsDisplay];

}

- (CGRect)moveNewPoint:(CGPoint)point rect:(CGRect)rect
{
    CGSize tmpSize;
    tmpSize.height = rect.size.height + (rect.origin.y - point.y);
    tmpSize.width = rect.size.width + (rect.origin.x - point.x);
    return CGRectMake(point.x, point.y, tmpSize.width, tmpSize.height);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context= UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    // Drawing code
    CGFloat startYOffset = (rect.size.height - self.textSize.height)/2;
    CGPoint origin = rect.origin;
    if (self.needFlow == YES)
    {
        rect = [self moveNewPoint:CGPointMake(self.XOffset, startYOffset) rect:rect];
        while (rect.origin.x <= rect.size.width+rect.origin.x)
        {
            [self.text drawInRect:rect];
            
            rect = [self moveNewPoint:CGPointMake(rect.origin.x + self.textSize.width+SPACE_WIDTH, rect.origin.y) rect:rect];
        }
        
    }
    else
    {
        //在控件的中间绘制文本
        origin.x = 0;
        origin.y = (rect.size.height - self.textSize.height)/2;
        rect.origin = origin;
        [self.text drawInRect:rect];
    }
}

@end
