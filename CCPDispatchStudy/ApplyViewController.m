//
//  ApplyViewController.m
//  CCPDispatchStudy
//
//  Created by 储诚鹏 on 16/11/25.
//  Copyright © 2016年 RUIYI. All rights reserved.
//

#import "ApplyViewController.h"

@interface ApplyViewController ()

@end

@implementation ApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Apply";
    self.view.backgroundColor = [UIColor whiteColor];
    [self copyItemsToDesktop];
    [self explainLabel];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*使用之前按指定目录创建文件*/
- (void)copyItemsToDesktop {
    NSArray *array = [NSArray arrayWithObjects:@"/Users/iosyidong/Desktop/sourceGroup/first.text",
                      @"/Users/iosyidong/Desktop/sourceGroup/second.text",
                      @"/Users/iosyidong/Desktop/sourceGroup/third.text",
                      nil];
    NSString *copyDes = @"/Users/iosyidong/Desktop/targetGroup/";
    NSFileManager *fileManager = [NSFileManager defaultManager];
     __block  NSError *error = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_apply([array count], dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
            NSLog(@"%ld",index);
            NSString *sourcePath = [array objectAtIndex:index];
            NSString *targetPath = [NSString stringWithFormat:@"%@%@",copyDes,[sourcePath lastPathComponent]];
            [fileManager copyItemAtPath:sourcePath toPath:targetPath error:&error];
            if (error) {
                NSLog(@"error:%@",[error localizedDescription]);
            }
        });
        NSLog(@"file has been copied");
    });
}

- (void)explainLabel {
    NSString *explainString = @"dispatch_apply的作用与apply_group的作用相似，主要用于开启多个并发线程，提高效率。dispatch_apply里面的并发线程是无序的。";
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
@end
