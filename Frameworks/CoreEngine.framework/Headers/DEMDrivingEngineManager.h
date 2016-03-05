
//
// File Name        : DrivingEngineManager.h
// Purpose          : Act as plugin to the Engine. Handle Input and output activities of the engine
// Author           : Tata Consultancy Services Limited.
// Copyright        : © Copyright 2015, Tata Consultancy Services Limited. All Rights Reserved.
//                    Document ID CGPD000204
//                    Unauthorized access, copying, replication, distribution, transmission, modification, adaptation or
//                    translation or use without express written permission is prohibited.
// Revision History : Created
//

#import <Foundation/Foundation.h>





@class DEMConfiguration;
@class DEMEventInfo;
@protocol DEMDrivingEngineDelegate;

/*
 *  DEMEventCaptureMask
 *
 *  Discussion:
 *      Use this for getting desired event call back.
 */
typedef NS_OPTIONS (NSUInteger, DEMEventCaptureMask) {
    DEMEventCaptureRecordingStarted = (1 << 0), 		// => 		000000001
    DEMEventCaptureRecordingStopped = (1 << 1), 		// => 		000000010
    DEMEventCaptureTripInfoSaved = (1 << 2), 			// => 		000000100
    DEMEventCaptureInvalidRecordingStopped = (1 << 3),		// => 		000001000
    DEMEventCaptureBrakingDetected = (1 << 4), 		// => 		000010000
    DEMEventCaptureAccelerationDetected = (1 << 5), 		// => 		000100000
    DEMEventCaptureNightDrivingDetected = (1 << 6), 		// => 		001000000
    DEMEventCaptureStartOfSpeedingDetected = (1 << 7), 	// => 		010000000
    DEMEventCaptureEndOfSpeedingDetected = (1 << 8), 		// => 		100000000
    DEMEventCapturePhoneCallIncoming = (1 << 9),
    DEMEventCapturePhoneCallDisconnected = (1 << 10),
    DEMEventCaptureAll =
    DEMEventCaptureRecordingStarted |
    DEMEventCaptureRecordingStopped |
    DEMEventCaptureStartOfSpeedingDetected |
    DEMEventCaptureEndOfSpeedingDetected |
    DEMEventCaptureBrakingDetected |
    DEMEventCaptureAccelerationDetected |
    DEMEventCaptureInvalidRecordingStopped |
    DEMEventCaptureTripInfoSaved |
    DEMEventCapturePhoneCallIncoming |
    DEMEventCapturePhoneCallDisconnected |
    DEMEventCaptureNightDrivingDetected 	// => 		111111111
    
} ;

@interface DEMDrivingEngineManager : NSObject

/*
 *  sharedManager
 *
 *  Discussion:
 *      To obtain the singleton instance
 */
+ (id)sharedManager;

/*
 *  buildInfo
 *
 *  Discussion:
 *      To obtain a string containing build info
 */
-(NSString*)buildInfo;


/*
 *  startEngine
 *
 *  Discussion:
 *      Initialise the engine components and start recording trips.
 */
- (void)startEngine;

/*
 *  shutDownEngine
 *
 *  Discussion:
 *      Shutdown the engine. No trips will be recorded further till calling 'startEngine'.
 *
 */
- (void)shutDownEngine;

/*
 *  setUploadToken
 *
 *  Discussion:
 *      Setting up the upload token is manadatory for performing webservice operations.
 *
 */
-(void)setUploadToken:(NSString *)lstToken;

/*
 *  setReferenceData
 *
 *  Discussion:
 *      Set reference data
 *
 */
-(BOOL)setReferenceData:(NSString *)referenceData;

/*
 *  setGroupId
 *
 *  Discussion:
 *      Set the Group ID for the webservice operations.
 *
 */
-(void)setGroupId:(NSString*)groupId;

/*
 *  setSensorId
 *
 *  Discussion:
 *      Set the sensor ID for the webservice operations.
 *
 */
-(void)setSensorId:(NSString*)sensorId;

/*
 *  setConfiguration:
 *
 *  Discussion:
 *      Sets the engine parameters.
 *
 */
- (BOOL)setConfiguration:(DEMConfiguration *)engineConfiguration;

/*
 *  setApplicationPath:
 *
 *  Discussion:
 *      To set the application base folder path to save the engine files.
 *
 */
- (void)setApplicationPath:(NSString *)path;

/*
 *  startTripRecording
 *
 *  Discussion:
 *      To start the trip recording manually.
 * 		The method to be invoked after the simulation mode is enabled.
 *
 */
- (void)startTripRecording;

/*
 *  stopTripRecording
 *
 *  Discussion:
 *      To stop the trip recording manually.
 *
 */
- (void)stopTripRecording;


/*
 *  registerForEventCapture
 *
 *  Discussion:
 *      Call this function to register for getting event notification callbacks.
 */
- (void)registerForEventCapture:(DEMEventCaptureMask)captureMask;

/*
 *  unregisterForEventCapture
 *
 *  Discussion:
 *      Call this function to unregister for event notification callbacks.
 */
- (void)unregisterForEventCapture;


/*
 *  suspendForPeriod:
 *
 *  Discussion:
 *      Function to suspend the engine from capturing the drive for a given time period.
 *
 */
- (void)suspendForPeriod:(NSTimeInterval)durationInSeconds;

/*
 *  cancelSuspension
 *
 *  Discussion:
 *      Resume the engine from suspended mode.
 *
 */
- (void)cancelSuspension;


/*
 *	engineMode
 *
 *  Discussion:
 *		Specifies the current engine mode as 'Driving' or 'Not Driving'.
 * 		Two modes are possible: driving (return value ‘1’) and not driving (returns ‘0’).
 *
 */
- (int)engineMode;


/*
 *	setMockDataPath:cadence:error
 *
 *  Discussion:
 *		Provides a method to simulate drive.
 *      mock data in the form of a CSV file needs to be passed (format : timestamp, altitude, course, horizontalAccuracy, latitude,longitude, rawSpeed).
 *      ‘cadence’ value in the form of milliseconds is passed to provide a time interval between processing of data points.
 *      Note: Calling this method disables the real time data collection. Realtime data collection will resume when the method ‘cancelMockData’ is called
 *
 */
-(BOOL)setMockDataPath:(NSString*)path cadence:(long)milliseconds;


/*
 *	setMockData:cadence
 *
 *  Discussion:
 *		Provides a method to simulate drive.
        Data should be provided in the form of array of CLLocation objects.
 *
 */
-(void)setMockData:(NSArray*)data cadence:(long)milliseconds;


/*
 *	cancelMockData
 *
 *  Discussion:
 *		To cancel the simulation mode.
 *
 */
-(void)cancelMockData;

-(void)didDetectIncomingPhoneCall:(DEMEventInfo*)eventInfo;
-(void)didDetectDisconnectedPhoneCall:(DEMEventInfo*)eventInfo;

/*
 *	ignoreCurrentTrip
 *
 *  Discussion:
 *		To ignore the current trip. A flag will be set, informing that the current trip is ignored in the trip summary json
 *
 */

- (void)ignoreCurrentTrip;

/*
 *  DrivingEngineDelegate
 *
 *  Discussion:
 *      Classes should set this deleagte to receive driving engine outputs.
 */
@property (assign, nonatomic) id<DEMDrivingEngineDelegate>delegate;


/*
 Inorder to upload the collected rawdata into the server, SDK needs the credentials and the folder path.
 
 */
- (void)setRawDataInfo:(NSString*)ftpURL userName:(NSString*)userId password:(NSString*)password path:(NSString*)folderPath buildNumber:(NSString*)buildNo;

@end
