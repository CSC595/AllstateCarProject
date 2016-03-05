
//
// File Name        : DEMEventInfo.h
// Purpose          : Maintain the properties of a event
// Author           : Tata Consultancy Services Limited.
// Copyright        : © Copyright 2015, Tata Consultancy Services Limited. All Rights Reserved.
//                    Document ID CGPD000204
//                    Unauthorized access, copying, replication, distribution, transmission, modification, adaptation or
//                    translation or use without express written permission is prohibited.
// Revision History : Created
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(int, EventType ) {
    
    EventBraking  = 1,
    EventAcceleration,
    EventSpeeding,
    EventNightDrive
};

@interface DEMEventInfo : NSObject

@property (nonatomic,assign) int eventID;
@property (nonatomic,assign) int sensorType;
@property (nonatomic,strong) NSString* tripID;
@property (nonatomic,assign) int gpsStrength;
@property (nonatomic,assign) float sampleSpeed;
@property (nonatomic,assign) double sensorStartReading;
@property (nonatomic,assign) double sensorEndReading;
@property (nonatomic,assign) double speedChange;
@property (nonatomic,assign) double milesDriven;
@property (nonatomic,strong) NSDate* eventEndTime;
@property (nonatomic,strong) NSDate* eventStartTime;
@property (nonatomic,strong) NSString* eventStartLocation;
@property (nonatomic,strong) NSString* eventEndLocation;
@property (nonatomic,assign) NSTimeInterval eventDuration;
@property (nonatomic,assign) EventType eventType;


@end
