/*
 * Created by Yumenosuke Koukata on 3/19/14.
 * Copyright (c) 2014 ZYXW. All rights reserved.
 */

#import "YKFile.h"
#import "YKFile+NSDirectories.h"

@implementation YKFile (NSDirectories)

+ (instancetype)homeDirectory {
	return [YKFile fileWithPath:NSHomeDirectory()];
}

+ (instancetype)mainBundleDirectory {
	return [YKFile fileWithPath:[NSBundle mainBundle].resourcePath];
}

+ (instancetype)cachesDirectory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	if (paths && [paths count] > 0) {
	} else return nil;
	NSString *cachePath = paths[0];
	return [YKFile fileWithPath:cachePath];
}

+ (instancetype)documentsDirectory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	if (paths && [paths count] > 0) {
	} else return nil;
	NSString *documentsDirectoryPath = paths[0];
	return [YKFile fileWithPath:documentsDirectoryPath];
}

+ (instancetype)temporaryDirectory {
	return [YKFile fileWithPath:NSTemporaryDirectory()];
}

@end
