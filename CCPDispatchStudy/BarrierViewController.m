//
//  BarrierViewController.m
//  CCPDispatchStudy
//
//  Created by 储诚鹏 on 16/11/25.
//  Copyright © 2016年 RUIYI. All rights reserved.
//

#import "BarrierViewController.h"

@interface BarrierViewController ()

@end

@implementation BarrierViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Barrier";
    self.view.backgroundColor = [UIColor whiteColor];
    [self explainLabel];
    [self simpleDemo];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)explainLabel {
    NSString *explainString = @"dispatch_barrier_async的主要作用就相当于一个栅栏，它起到一个阻拦的作用，将其前面的线程和后面的线程阻隔开来。barrier必须在其前面的线程执行完成之后才会进行，barrier执行完成之后才会进行后面的线程。只会在串行队列中起作用.";
    UILabel *label = [[UILabel alloc] init];
    CGSize size = [explainString boundingRectWithSize:CGSizeMake(300, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18.0]} context:nil].size;
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = explainString;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(size);
    }];
}

- (void)simpleDemo {
    dispatch_queue_t gqueue = dispatch_queue_create("demoQueue", DISPATCH_QUEUE_PRIORITY_DEFAULT);
   // dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(gqueue, ^{
        NSLog(@"first");
    });
    dispatch_async(gqueue, ^{
        NSLog(@"second");
    });
    dispatch_barrier_async(gqueue, ^{
        NSLog(@"I'm barrier");
    });
    dispatch_async(gqueue, ^{
        NSLog(@"third");
    });
}


@end
