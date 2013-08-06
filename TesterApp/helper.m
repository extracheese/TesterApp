//
//  helper.m
//  TesterApp
//
//  Created by Naoki Ogishi on 8/6/13.
//  Copyright (c) 2013 Ogishi. All rights reserved.
//

#import "helper.h"
#import <QuartzCore/QuartzCore.h>


@implementation Helper

+(double) millisecondsSinceStart{
    static double startTime = 0;
    
    if(startTime == 0){
        startTime = CACurrentMediaTime();
    }
    return CACurrentMediaTime() - startTime;
}


@end
