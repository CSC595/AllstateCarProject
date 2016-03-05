//
//  DEMError.h
//  CoreEngine
//
//  Created by PALLAVI ASHIM on 17/09/15.
//  Copyright © 2015 Sreeni P. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, DEMErrorType)
{
    DEMErrorTypeBatteryLow = 101,
    DEMErrorTypeLocationService = 102,
    DEMErrorTypeMemoryLow = 103,
    DEMErrorTypeEngineInShutdownMode = 104,
    DEMErrorTypeEngineInSuspensionMode = 105,
    DEMErrorTypeBackgroundApplicationRefreshOff = 106,
    DEMErrorTypeFileNotFound = 201,
    DEMErrorTypeFileNotAccessible = 202,
    DEMErrorTypeFileDataError = 203,
    DEMErrorTypeFileDataFormatError = 204,
    DEMErrorTypeEmptyGPSArray = 205,
    DEMErrorTypeConfigurationInvalid = 301,
    DEMErrorTypeConfigurationCouldNotbeModifiedNow = 302,
    DEMErrorTypeNoInternetConnection = 401,
    DEMErrorTypeServerError = 402,
    DEMErrorTypeWrongApplicationfilepath = 501,
    DEMErrorTypeRawDataGenerationFailed = 502,
    DEMErrorTypeLogFileGenerationFailed = 503
};

// Error category
#define DEMErrorCategoryTripStart @"DEMErrorTripStart"
#define DEMErrorCategoryTripMock @"DEMErrorTripMock"
#define DEMErrorCategoryEngineConfiguration @"DEMErrorEngineConfiguration"
#define DEMErrorCategoryNetworkOperation @"DEMErrorNetworkOperation"
#define DEMErrorCategoryFileOperation @"DEMErrorFileOperation"

#define DEMMockDataFileFormat @"Timestamp,altitude,course,horizontalAccuracy,latitude,longitude,rawSpeed"

// Error Additional Info Keys
#define DEM_KEY_TRIP_MOCK_REQUIRED_FILE_FORMAT @"RequiredFileFormat"
#define DEM_TRIP_MOCK_FILE_PATH @"FilePath"
#define DEM_ENGINE_SERVER_ERROR_CODE @"ServerErrorCode"
#define DEM_ENGINE_SERVER_DESCRIPTION @"ServerErrorDescription"
#define DEM_CONFIGURATION_INVALID_ITEM @"ConfigurationInvalidItem"
#define DEM_KEY_LOCALIZED_DESCRIPTION @"LocalizedDescription"
#define DEM_KEY_BATTERY_LEVEL_REQUIRED @"BatteryLevelRequired"
#define DEM_KEY_BATTERY_CURRENT_LEVEL @"CurrentBatteryLevel"
#define DEM_KEY_ENGINE_SUSPENSION_DURATION @"EngineAutoResumeTime"

// Error description
#define DEMErrorDescriptionBatteryLow @"If battery level of the phone is low, trip recording will not happen even if the call to “StartTripRecording” is made"
#define DEMErrorDescriptionLocationService @"Location service of the phone is disabled"
#define DEMErrorDescriptionMemoryLow @"Phone is running out of memory"
#define DEMErrorDescriptionEngineInShutdownMode @"Engine is in shutdown mode."
#define DEMErrorDescriptionEngineInSuspensionMode @"Engine is in suspension mode"
#define DEMErrorDescriptionBackgroundApplicationRefreshOff @"iOS Background Application Refresh setting disabled by the user"
#define DEMErrorDescriptionFileNotFound @"Mock file does not exists"
#define DEMErrorDescriptionFileNotAccessible @"Mock file is not accessible"
#define DEMErrorDescriptionFileDataError @"Data type of the mock data is wrong"
#define DEMErrorDescriptionFileDataFormatError @"Data format of the mock data file is wrong"
#define DEMErrorDescriptionEmptyGPSArray @"GPS data does not have sufficient locations for trip mocking."

#define DEMErrorDescriptionConfigurationInvalid @"Configuration values are un realistic or contradictory."
#define DEMErrorDescriptionConfigurationCouldNotbeModifiedNow @"Configuration can not be changed while trip recording is in progress"
#define DEMErrorDescriptionNoInternetConnection @"No working internet connection"
#define DEMErrorDescriptionServerError @"Service fails and server is throwing some error"
#define DEMErrorDescriptionWrongApplicationfilepath @"invalid file path set as application file path"
#define DEMErrorDescriptionRawDataGenerationFailed @"Raw data file writing fails"
#define DEMErrorDescriptionLogFileGenerationFailed @"Log file writing fails"
#define DEMConfigurationErrorDescriptionForMaximumPermittedSpeed @"Maximum permitted speed should be above speed limit"
#define DEMConfigurationErrorDescriptionForSpeedLimit @"Speed limit should be above minimum speed to begin trip"
#define DEMConfigurationErrorDescriptionForAutoStopSpeed @"Auto stop speed should be above zero and less than or equal to minimum speed to begin trip"
#define DEMConfigurationErrorDescriptionForAutoStopDuration @"Auto stop duration should be greater than or equal to 5 minutes"
#define DEMConfigurationErrorDescriptionForMaxTripRecordingTime @"Maximum trip recording time should be greater than zero"
#define DEMConfigurationErrorDescriptionForMinSpeedToBeginTrip @"Minimum Speed to begin trip should be greater than or equal to 5 miles per hour"
#define DEMConfigurationErrorDescriptionForMinBatteryLevelWhileCharging @"Minimum battery level while charging should be between 0 and 100"
#define DEMConfigurationErrorDescriptionForMinBatteryLevelWhileUnPlugged @"Minimum battery level while unplugged should be between 0 and 100"
#define DEMConfigurationErrorDescriptionForDistanceForSavingTrip @"Distance for saving trip data should be between 2 to 10 miles"
#define DEMConfigurationErrorDescriptionForMaxTripRecordingDistance @"Maximum trip recording distance should be above 0"
#define DEMConfigurationErrorDescriptionForBrakingThreshold @"Braking threshold should be between 1 and 5"
#define DEMConfigurationErrorDescriptionForAccelerationThreshold @"Acceleration threshold should be between 1 and 5"


@interface DEMError : NSObject

@property (nonatomic, strong) NSString *category;
@property (nonatomic, assign) NSInteger errorCode;
@property (nonatomic, strong) NSMutableDictionary *additionalInfo;

@end
