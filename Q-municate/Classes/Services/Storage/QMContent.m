//
//  QMContent.m
//  Q-municate
//
//  Created by Igor Alefirenko on 26/02/2014.
//  Copyright (c) 2014 Quickblox. All rights reserved.
//

#import "QMContent.h"

@interface QMContent () <QBActionStatusDelegate>

@property (copy, nonatomic) QBContentBlock resultBlock;

@end


@implementation QMContent

- (void)loadImageForBlob:(UIImage *)image named:(NSString *)name completion:(QBContentBlock)block
{
    NSData *data = UIImagePNGRepresentation(image);
    _resultBlock = block;
    [QBContent TUploadFile:data fileName:name contentType:@"image/png" isPublic:YES delegate:self];
}

- (void)loadImageFromFacebookWithUserID:(NSString *)facebookID accessToken:(NSString *)accessToken completion:(QBDataBlock)block
{
    //NSString *urlString = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?access_token=%@", facebookID, accessToken];
    
    NSString *terminate = @"https://s3.amazonaws.com/qbprod/e3b37058ea324fcabf829767d7fd641400";

    
    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(q, ^{
        /* Fetch the image from the server... */
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:terminate]];
        UIImage *img = [[UIImage alloc] initWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            /* This is the main thread again, where we set the tableView's image to
             be what we just fetched. */
            block(img);
        });
    });
}

#pragma mark - QBActionStatusDelegate

- (void)completedWithResult:(Result *)result
{
    if (result.success && [result isKindOfClass:[QBCFileUploadTaskResult class]]) {
        QBCBlob *blob = ((QBCFileUploadTaskResult *)result).uploadedBlob;
        _resultBlock(blob);
        _resultBlock = nil;
        return;
    }
    _resultBlock(nil);
    _resultBlock = nil;
}

@end
