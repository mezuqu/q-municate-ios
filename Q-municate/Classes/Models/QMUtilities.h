//
//  Utilities.h
//  Q-municate
//
//  Created by Igor Alefirenko on 19/02/2014.
//  Copyright (c) 2014 Quickblox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QMIncomingCallController.h"
#import "NSDateFormatter+SinceDateFormat.h"


@interface QMUtilities : NSObject

@property (strong, nonatomic) NSDateFormatter *dateFormatter;
//@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) QMIncomingCallController *incomingCallController;

+ (instancetype)shared;

- (void)dismissIncomingCallController;

- (NSString *)formattedTimeFromTimeInterval:(double_t)time;

@end
