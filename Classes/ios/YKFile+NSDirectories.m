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
	NSString *cachePath = [paths firstObject];
	return [YKFile fileWithPath:cachePath];
}

+ (instancetype)documentsDirectory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectoryPath = [paths firstObject];
	return [YKFile fileWithPath:documentsDirectoryPath];
}

+ (instancetype)temporaryDirectory {
	return [YKFile fileWithPath:NSTemporaryDirectory()];
}

@end
