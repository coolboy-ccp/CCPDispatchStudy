//
//  SourceViewController.m
//  CCPDispatchStudy
//
//  Created by 储诚鹏 on 16/11/25.
//  Copyright © 2016年 RUIYI. All rights reserved.
//

#import "SourceViewController.h"
#define mainS [UIScreen mainScreen].bounds

@interface SourceViewController ()
@property (nonatomic,strong) UIProgressView *progressView;

@end

@implementation SourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Source";
    self.view.backgroundColor = [UIColor whiteColor];
    [self functionButtons];
    self.progressView = [[UIProgressView alloc] init];
    [self.view addSubview:self.progressView];
    self.progressView.progressTintColor = [UIColor redColor];
    self.progressView.trackTintColor = [UIColor brownColor];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(mainS.size.width, 20.0));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)functionButtons {
    NSArray *names = @[@"Timer(定时器)",@"data_add(监听多个线程进度)" ,@"developing(待续...)"];
    for (int i = 0; i < names.count; i ++) {
        __block UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:btn];
        [btn setTitle:names[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view);
            make.top.mas_equalTo(84 + 60 * i);
            make.size.mas_equalTo(CGSizeMake(200, 40));
        }];
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            switch (i) {
                case 0:
                {
                    btn.enabled = NO;
                    dispatch_source_t disTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
                    __block int i = 10;
                    dispatch_source_set_timer(disTimer, dispatch_walltime(NULL, 0), 1ull * NSEC_PER_SEC, 0ull * NSEC_PER_SEC);
                    dispatch_source_set_event_handler(disTimer, ^{
                        if (--i > 0) {
                            [btn setTitle:[NSString stringWithFormat:@"定时器还剩%d秒",i] forState:UIControlStateNormal];
                        }
                        else {
                           dispatch_source_cancel(disTimer);
                        }
                    });
                    dispatch_source_set_cancel_handler(disTimer, ^{
                        NSLog(@"timer cancle");
                        btn.enabled = YES;
                        [btn setTitle:@"定时器已经停止" forState:UIControlStateNormal];
                    });
                    dispatch_resume(disTimer);
                }
                    break;
                case 1:
                {
                    btn.enabled = NO;
                    self.progressView.progress = 0;
                    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, dispatch_get_main_queue());
                    dispatch_source_set_event_handler(source, ^{
                        NSLog(@"%lu----",dispatch_source_get_data(source));
                        [self updataProgress:dispatch_source_get_data(source)];
                        btn.enabled = YES;
                    });
                    dispatch_resume(source);
                    NSArray *arr = @[@"http://pic.58pic.com/58pic/15/39/92/15b58PICSAZ_1024.jpg",@"http://pic.58pic.com/58pic/15/39/92/15b58PICSAZ_1024.jpg"];
                    dispatch_apply([arr count], dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
                        NSURL *url = [NSURL URLWithString:[arr objectAtIndex:index]];
                        NSData *data = [NSData dataWithContentsOfURL:url];
                       //[NSThread sleepForTimeInterval:1];
                        dispatch_source_merge_data(source, 1);
                    });
                }
                    break;
                default:
                    break;
            }
        }];
    }
}

- (void)updataProgress:(unsigned long)progress {
    float a = (float)progress / 2;
    [self.progressView setProgress:a animated:YES];
}

@end
