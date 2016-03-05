
//
// File Name        : DEMSignificantLocation.h
// Purpose          : Class for holding an GPS location object
// Author           : Tata Consultancy Services Limited.
// Copyright        : © Copyright 2015, Tata Consultancy Services Limited. All Rights Reserved.
//                    Document ID CGPD000204
//                    Unauthorized access, copying, replication, distribution, transmission, modification, adaptation or
//                    translation or use without express written permission is prohibited.
// Revision History : Created
//

#import <Foundation/Foundation.h>

@interface DEMSignificantLocation : NSObject

@property (nonatomic, strong) NSString * location;
@property (nonatomic, strong) NSNumber * accuracy;
@property (nonatomic, strong) NSNumber * speed;
@property (nonatomic, strong) NSDate *timeStamp;
@property (nonatomic, assign) long long serialIndex;

@end
