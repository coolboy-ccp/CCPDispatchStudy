//
//  GroupViewController.m
//  CCPDispatchStudy
//
//  Created by 储诚鹏 on 16/11/24.
//  Copyright © 2016年 RUIYI. All rights reserved.
//

#import "GroupViewController.h"

@interface GroupViewController ()

@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"dispatch_group";
    [self imgsWithImageNames:@[@"http://pic.58pic.com/58pic/15/39/92/15b58PICSAZ_1024.jpg",@"http://pic.58pic.com/58pic/15/39/92/15b58PICSAZ_1024.jpg"] andSuccessBlock:^(NSArray *imgs) {
        for (int i = 0; i < imgs.count; i ++) {
            UIImageView *imgView = [[UIImageView alloc] initWithImage:imgs[i]];
            [self.view addSubview:imgView];
            CGFloat imgW = [UIScreen mainScreen].bounds.size.width / 5;
            int x = i % 5;
            int y = i / 5;
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(x * imgW);
                make.top.mas_equalTo(y * imgW + 64);
                make.size.mas_equalTo(CGSizeMake(imgW, imgW));
            }];
        }
    }];
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imgsWithImageNames:(NSArray *)imgPaths andSuccessBlock:(void (^)(NSArray *imgs))responseBlock{
    __block NSMutableArray *arr = [NSMutableArray array];
    dispatch_group_t dgp = dispatch_group_create();
    dispatch_queue_t gQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (NSString *path in imgPaths) {
        __block UIImage *img = nil;
        dispatch_group_async(dgp, gQueue, ^{
            NSURL *url = [NSURL URLWithString:path];
            NSData *data = [NSData dataWithContentsOfURL:url];
            img = [UIImage imageWithData:data];
            [arr addObject:img];
        });
    }
    //所有group结束时调用
    dispatch_group_notify(dgp, dispatch_get_main_queue(), ^{
        responseBlock([NSArray arrayWithArray:arr]);
    });
}

@end
