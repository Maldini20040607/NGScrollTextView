//
//  ViewController.m
//  NGScrollTextView
//
//  Created by Ning Gang on 2017/3/21.
//  Copyright © 2017年 Nelson. All rights reserved.
//

#import "ViewController.h"

#import "NGScrollTextView.h"

@interface ViewController ()<NGScrollTextViewDelegate>

@property (nonatomic,strong) NGScrollTextView * scrollTextView;

@end

@implementation ViewController

- (NGScrollTextView *)scrollTextView
{
    if (!_scrollTextView) {
        _scrollTextView = [[NGScrollTextView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 50) Delegate:self];
    }
    return _scrollTextView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.scrollTextView];
    
    NSArray * arr = @[@{@"content":@"测试内容1测试内容1测试内容1测试内容1测试内容1测试内容1"},@{@"content":@"测试内容2测试内容2测试内容2测试内容2测试内容2测试内容2测试内容2测试内容2"},@{@"content":@"测试内容3"}];
    [self.scrollTextView setDataWithImage:@"notifyIcon" contentArr:arr];
}

-(void)clickScrollTextMessage:(NSDictionary *)dict
{
    NSLog(@"touch %@",dict);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
