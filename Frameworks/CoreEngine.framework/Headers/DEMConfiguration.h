///////////////////////////////////////////////////////////////////////////////////////////////
// File Name        : DEMConfiguration.h
// Purpose          : Configuration parameter class. Default values are initialised.
// Author           : Tata Consultancy Services Limited.
// Copyright        : © Copyright 2015, Tata Consultancy Services Limited. All Rights Reserved.
//                    Document ID CGPD000204
//                    Unauthorized access, copying, replication, distribution, transmission, modification, adaptation or
//                    translation or use without express written permission is prohibited.
// Revision History : Created
///////////////////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>

@interface DEMConfiguration : NSObject

@property (nonatomic, assign) double maximumPermittedSpeed;
@property (nonatomic, assign) double autoStopSpeed;
@property (nonatomic, assign) double speedLimit;
@property (nonatomic, assign) double minSpeedToBeginTrip;
@property (nonatomic, assign) double autoStopDuration;
@property (nonatomic, assign) double maxTripRecordingTime;
@property (nonatomic, assign) double minBatteryLevelWhileCharging;
@property (nonatomic, assign) double minBatteryLevelWhileUnPlugged;
@property (nonatomic, assign) double distanceForSavingTrip;
@property (nonatomic, assign) double maxTripRecordingDistance;
@property (nonatomic, assign) double brakingThreshold;
@property (nonatomic, assign) double accelerationThreshold;
@property (nonatomic, assign) BOOL enableWebServices;
@property (nonatomic, assign) BOOL enableRawDataCollection;
@property (nonatomic, assign) BOOL captureFineLocation;
@property (nonatomic, assign) BOOL enable24HrTimeSlot;
@property (nonatomic, assign) BOOL enableDeveloperMode;

@end
