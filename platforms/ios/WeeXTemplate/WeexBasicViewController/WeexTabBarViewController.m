//
//  WeexTabBarViewController.m
//  WeeXTemplate
//
//  Created by Jon on 2017/10/12.
//  Copyright © 2017年 droi. All rights reserved.
//

#import "WeexTabBarViewController.h"
#import "WeexTabBarView.h"
#import "WeeXViewController.h"
#import <SDWebImage/SDWebImageDownloader.h>
#define kWXTabBarViewTag 19361569
@interface WeexTabBarViewController ()
@property (nonatomic, strong) WXSDKInstance *instance;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) UIView *weexView;

@end

@implementation WeexTabBarViewController

- (void)dealloc{
    [_instance destroyInstance];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *jsBundlePath = @"/Users/jon/Desktop/可视化编程/Weex/awesome-project/dist/index.js";
    self.url = [NSURL fileURLWithPath:jsBundlePath];
    [self WXRender];
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
        WeexTabBarView *tabBarView = [view viewWithTag:kWXTabBarViewTag];
        NSArray *jsonArray = tabBarView.attributes[@"info"];
        [weakSelf setupTabBar:jsonArray];
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

- (void)updateInstanceState:(WXState)state{
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

- (void)setupTabBar:(NSArray *)jsonArray{
    NSMutableArray *vcArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in jsonArray) {
        NSString *uri = [dict valueForKey:@"uri"];
        NSString *title = [dict valueForKey:@"title"];
        NSString *image = [dict valueForKey:@"image"];
        NSString *selectedImage = [dict valueForKey:@"selectedImage"];
        WeeXViewController *rootVC = [[WeeXViewController alloc] init];
//        UINavigationController *rootVC = [[UINavigationController alloc] initWithRootViewController:rootVC1];
        rootVC.uri = uri;
        rootVC.title = title;
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:image]  options:SDWebImageDownloaderLowPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            rootVC.tabBarItem.image = [[self scaleToSize:image size:CGSizeMake(30, 30)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }];
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:selectedImage]  options:SDWebImageDownloaderLowPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            rootVC.tabBarItem.selectedImage = [[self scaleToSize:image size:CGSizeMake(30, 30)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
        }];
        [vcArray addObject:rootVC];
    }
    self.viewControllers = vcArray;
}
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)newsize{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(newsize);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

@implementation WeexTabBarComponet
WX_EXPORT_METHOD(@selector(focus)) // 暴露该方法给js

- (instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events weexInstance:(WXSDKInstance *)weexInstance
{
    if (self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events weexInstance:weexInstance]) {
        
    }
    return self;
}

- (UIView *)loadView{
    WeexTabBarView *weexTabBarView = [[WeexTabBarView alloc] init];
    weexTabBarView.attributes = self.attributes;
    weexTabBarView.tag = kWXTabBarViewTag;
    return weexTabBarView;
}

- (void)focus{
    NSLog(@"you got it");
}
@end
