//
//  WeeXViewController.m
//  WeeXTemplate
//
//  Created by Jon on 2017/9/25.
//  Copyright © 2017年 droi. All rights reserved.
//
#import <WeexSDK/WeexSDK.h>
#import "WeeXViewController.h"
@interface WeeXViewController ()
@property (nonatomic, strong) WXSDKInstance *instance;
@property (nonatomic, strong) UIView *weexView;
@property (nonatomic, strong) NSURL *url;

@end

@implementation WeeXViewController
    
- (void)dealloc{
    [_instance destroyInstance];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"refresh" style:UIBarButtonItemStylePlain target:self action:@selector(refresh)];
    self.url = [NSURL URLWithString:self.uri];
    [self WXRender];
}

- (void)refresh{
    [self WXRender];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    _instance.frame = self.view.frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
    
- (void)WXRender{
    [_instance destroyInstance];
    _instance = [[WXSDKInstance alloc] init];
    NSLog(@"_instance:%@",_instance);
    _instance.viewController = self;
    __weak typeof(self) weakSelf = self;
    _instance.onCreate = ^(UIView *view) {
        [weakSelf.weexView removeFromSuperview];
        weakSelf.weexView = view;
        [weakSelf.view addSubview:weakSelf.weexView];
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, weakSelf.weexView);
    };
    _instance.onFailed = ^(NSError *error) {
        NSLog(@"%@",error);
    };
    _instance.renderFinish = ^(UIView *view) {
        NSLog(@"%@", @"Render Finish...");
        [weakSelf updateInstanceState:WeexInstanceAppear];
    };
    
    _instance.updateFinish = ^(UIView *view) {

        NSLog(@"%@", @"Update Finish...");
    };
    if (!self.url) {
        NSLog(@"error: render url is nil");
        return;
    }
    NSURL *URL = self.url;
    [_instance renderWithURL:URL options:@{@"bundleUrl":URL.absoluteString} data:nil];
}
    
- (void)updateInstanceState:(WXState)state
    {
        if (_instance && _instance.state != state) {
            _instance.state = state;
            if (state == WeexInstanceAppear) {
                [[WXSDKManager bridgeMgr] fireEvent:_instance.instanceId ref:WX_SDK_ROOT_REF type:@"viewappear" params:nil domChanges:nil];
            }
            else if (state == WeexInstanceDisappear) {
                [[WXSDKManager bridgeMgr] fireEvent:_instance.instanceId ref:WX_SDK_ROOT_REF type:@"viewdisappear" params:nil domChanges:nil];
            }
        }
}


@end
