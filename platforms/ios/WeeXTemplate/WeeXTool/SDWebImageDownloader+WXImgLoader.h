//
//  SDWebImageDownloader+WXImgLoader.h
//  WeeXTemplate
//
//  Created by Jon on 2017/10/13.
//  Copyright © 2017年 droi. All rights reserved.
//

#import <WeexSDK/WeexSDK.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface SDWebImageDownloadToken (WXImgLoader)<WXImageOperationProtocol>
- (void)cancel;
@end
