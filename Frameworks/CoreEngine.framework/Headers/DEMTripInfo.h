
//
// File Name        : DEMTripInfo.h
// Purpose          : Trip summary model class
// Author           : Tata Consultancy Services Limited.
// Copyright        : © Copyright 2015, Tata Consultancy Services Limited. All Rights Reserved.
//                    Document ID CGPD000204
//                    Unauthorized access, copying, replication, distribution, transmission, modification, adaptation or
//                    translation or use without express written permission is prohibited.
// Revision History : Created
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface DEMTripInfo : NSObject

@property (nonatomic, strong) NSString* tripID;
@property (nonatomic, strong) NSString *startLocation;
@property (nonatomic, strong) NSString *endLocation;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, strong) NSDate *tripIgnoreTime;
@property (nonatomic, assign) float distanceCovered;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) float averageSpeed;
@property (nonatomic, assign) float maximumSpeed;
@property (nonatomic, strong) NSMutableArray *eventList;
@property (nonatomic, assign) int terminationId;
@property (nonatomic, assign) NSInteger speedingCount;
@property (nonatomic, assign) NSInteger brakingCount;
@property (nonatomic, assign) NSInteger accelerationCount;
@property (nonatomic, assign) int terminationType;
@property (nonatomic, assign) NSTimeInterval idleTime;
@property (nonatomic, strong) NSMutableArray *gpsTrailArray;
@property (nonatomic, assign) float mileageWhileSpeeding;
@property (nonatomic, strong) NSArray *timeSlots;
@property (nonatomic, strong) NSString *tripRejectionReason;
@property (nonatomic, strong) NSArray *speedHistogram;
@property (nonatomic, strong) NSArray *brakeHistogram;
@property (nonatomic, strong) NSArray *brakeEventsHistogram;
@property (nonatomic, strong) NSArray *accelerationHistogram;
@property (nonatomic, strong) NSArray *accelerationEventsHistogram;
@end
