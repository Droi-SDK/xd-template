//
//  SDWebImageDownloader+WXImgLoader.m
//  WeeXTemplate
//
//  Created by Jon on 2017/10/13.
//  Copyright © 2017年 droi. All rights reserved.
//
#import "SDWebImageDownloader+WXImgLoader.h"

@implementation SDWebImageDownloadToken (WXImgLoader)
- (void)cancel{
    NSLog(@"canel image downloader");
    [[SDWebImageDownloader sharedDownloader] cancel:self];
}

@end
