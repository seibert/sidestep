//
//  VPNInterfacer.m
//  Sidestep
//
//  Created by Chetan Surpur on 12/6/10.
//  Copyright 2010 Chetan Surpur. All rights reserved.
//

#import "VPNInterfacer.h"
#import "AppUtilities.h"


@implementation VPNInterfacer

/*
 *	Turns on or off the VPN connection for the service name given.
 *
 *	return: true on success
 *	return: false if task path not found
 */

- (BOOL)turnVPNOnOrOff:(NSString *)serviceName withState:(BOOL)state {
	
	XLog(self, @"Turning VPN on with service name: %@", serviceName);
	
	NSTask *task = [[[NSTask alloc] init] autorelease];
	
	// Setup the pipes on the task
	NSPipe *outputPipe = [NSPipe pipe];
	NSPipe *errorPipe = [NSPipe pipe];
	
	[task setStandardOutput:outputPipe];
	[task setStandardInput:[NSFileHandle fileHandleWithNullDevice]];
	[task setStandardError:errorPipe];
	
	// Set up arguments to the task
	NSArray *args = [NSArray arrayWithObjects:	[NSString stringWithString:serviceName],
					 [NSString stringWithFormat:@"%d", state],
					 nil];
	
	// Get the path of the task, which is included as part of the main application bundle
	NSString *taskPath = [NSBundle pathForResource:@"TurnVPNOnOrOff"
											ofType:@"sh"
									   inDirectory:[[NSBundle mainBundle] bundlePath]];
	
	if (!taskPath) {
		return FALSE;
	}
	
	// Set task's arguments and launch path
	[task setArguments:args];
	[task setLaunchPath:taskPath];
	
	// Before launching the task, get a filehandle for reading its output
	NSFileHandle *readHandle = [[task standardOutput] fileHandleForReading];
	
	// Launch task
	[task launch];
	
	// Read task's output data
	NSData *readData;
	while ((readData = [readHandle availableData]) && [readData length]) {
		NSString *readString = [[NSString alloc] initWithData:readData encoding:NSASCIIStringEncoding];
		
		XLog(self, @"Turn VPN On said: %@", readString);
		
		//	Return values of Turn VPN On:
		//		1 - Success
		//		2 - No such service
		//		3 - Service found was not of type VPN
	}
	
	return TRUE;
	
}

@end