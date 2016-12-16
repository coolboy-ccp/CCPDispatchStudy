//
//  ShowViewController.m
//  CCPDispatchStudy
//
//  Created by 储诚鹏 on 16/11/24.
//  Copyright © 2016年 RUIYI. All rights reserved.
//

#import "ShowViewController.h"
#import "GroupViewController.h"
#import "ApplyViewController.h"
#import "BarrierViewController.h"
#import "SourceViewController.h"

@interface ShowViewController ()

@end

@implementation ShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择";
    self.view.backgroundColor = [UIColor whiteColor];
    [self buttons];
    
}

- (void)buttons {
    NSArray *btnName = @[@"dispatch_group",@"dispatch_apply",@"dispatch_barrier",@"dispatch_source"];
    for (int i = 0;i < btnName.count;i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:btnName[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        btn.titleLabel.font = [UIFont systemFontOfSize:18.0];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.mas_equalTo(84 + 60 * i);
            make.size.mas_equalTo(CGSizeMake(160, 40));
        }];
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
            switch (i) {
                case 0:
                {
                    GroupViewController *group = [[GroupViewController alloc] init];
                    [self.navigationController pushViewController:group animated:YES];
                }
                    break;
                case 1:
                {
                    ApplyViewController *apply = [[ApplyViewController alloc] init];
                    [self.navigationController pushViewController:apply animated:YES];
                }
                    break;
                case 2:
                {
                    BarrierViewController *barrier = [[BarrierViewController alloc] init];
                    [self.navigationController pushViewController:barrier animated:YES];
                }
                    break;
                case 3:
                {
                    SourceViewController *source = [[SourceViewController alloc] init];
                    [self.navigationController pushViewController:source animated:YES];
                }
                default:
                    break;
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
