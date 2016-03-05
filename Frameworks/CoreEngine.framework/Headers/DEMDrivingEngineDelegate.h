
//
// File Name        : DrivingEngineDelegate
// Purpose          : Delegate methods of Driving engine
// Author           : Tata Consultancy Services Limited.
// Copyright        : © Copyright 2015, Tata Consultancy Services Limited. All Rights Reserved.
//                    Document ID CGPD000204
//                    Unauthorized access, copying, replication, distribution, transmission, modification, adaptation or
//                    translation or use without express written permission is prohibited.
// Revision History : Created
//

#import <Foundation/Foundation.h>
#import "DEMDrivingEngineManager.h"

#import "DEMEventInfo.h"

@class DEMTripInfo;
@class DEMError;

@protocol DEMDrivingEngineDelegate <NSObject>

@required


/*
 *	didStartTripRecording
 *
 *  Discussion:
 *		Tells that Driving Engine started trip recording. Application can do the neccessory changes.
 *      Application layer should return the identifier for the trip started. If not provided, engine will generate unique trip id.
 */
- (NSString *)didStartTripRecording:(DEMDrivingEngineManager *)drivingEngine;


/*
 *	didStopTripRecording:
 *
 *  Discussion:
 *		Tells that Driving Engine stopped trip recording. Application can do the neccessory changes.
 */
- (void)didStopTripRecording:(DEMDrivingEngineManager *)drivingEngine;


/*
 *	drivingEngine:didSaveTripInformation:driveStatus
 *
 *  Discussion:
 *		Engine will update this method with the latest mile's trip data.App layer can check the 'driveCompletionFlag' for checking drive ended or not.
 */


- (void)drivingEngine:(DEMDrivingEngineManager *)drivingEngine
didSaveTripInformation:(DEMTripInfo *)trip
          driveStatus:(BOOL)driveCompletionFlag;

/*
 *	didStopInvalidTripRecording:
 *
 *  Discussion:
 *		Callback method for invalid trip recorded.
 */
- (void)didStopInvalidTripRecording:(DEMDrivingEngineManager *)drivingEngine;


@optional


/*
 *	drivingEngine:didDetectBraking:
 *
 *  Discussion:
 *		Callback when engine detects braking.
 */
- (void)drivingEngine:(DEMDrivingEngineManager *)drivingEngine
     didDetectBraking:(DEMEventInfo*)brakingEvent;

/*
 *	drivingEngine:didDetectIncomingPhoneCall:
 *
 *  Discussion:
 *		Callback when engine detects incoming phone call
 */
- (void)drivingEngine:(DEMDrivingEngineManager *)drivingEngine
    didDetectIncomingPhoneCall:(DEMEventInfo*)event;

/*
 *	drivingEngine:didDetectDisconnectedPhoneCall:
 *
 *  Discussion:
 *		Callback when engine detects disconnected phone call
 */
- (void)drivingEngine:(DEMDrivingEngineManager *)drivingEngine
didDetectDisconnectedPhoneCall:(DEMEventInfo*)event;

/*
 *	drivingEngine:didDetectAcceleration:
 *
 *  Discussion:
 *		Callback when engine detects acceleration.
 */
- (void)drivingEngine:(DEMDrivingEngineManager *)drivingEngine
     didDetectAcceleration:(DEMEventInfo*)accelerationEvent;
/*
 *	drivingEngine:didDetectNightDriving:
 *
 *  Discussion:
 *		Callback when engine detects night driving.
 */
- (void)drivingEngine:(DEMDrivingEngineManager *)drivingEngine
didDetectNightDriving:(DEMEventInfo*)lateNightEvent;
/*
 *	drivingEngine:didDetectStartOfSpeeding:
 *
 *  Discussion:
 *		Callback when engine detects start of a speeding.
 */
- (void)drivingEngine:(DEMDrivingEngineManager *)drivingEngine
didDetectStartOfSpeeding:(DEMEventInfo *)overSpeedingEvent;

/*
 *	drivingEngine:didDetectEndOfSpeeding:
 *
 *  Discussion:
 *		Callback when engine detects end of a speeding.
 */
- (void)drivingEngine:(DEMDrivingEngineManager *)drivingEngine
didDetectEndOfSpeeding:(DEMEventInfo *)overSpeedingEvent;

/*
 *	drivingEngine:didReceiveError:
 *
 *  Discussion:
 *		Callback when engine detects any error.
 */
- (void)drivingEngine:(DEMDrivingEngineManager *)drivingEngine
      didErrorOccur:(DEMError *)errorInfo;

/*
 *	drivingEngineUploadSuccess
 *
 *  Discussion:
 *		Callback when engine successfully upload data to server.
 */
- (void)drivingEngineUploadSuccess:(DEMDrivingEngineManager *)drivingEngine;

@end
