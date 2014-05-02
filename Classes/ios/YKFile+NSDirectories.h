/*
 * Created by Yumenosuke Koukata on 3/19/14.
 * Copyright (c) 2014 ZYXW. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "YKFile.h"

@interface YKFile (NSDirectories)

+ (instancetype)homeDirectory;

+ (instancetype)mainBundleDirectory;

+ (instancetype)cachesDirectory;

+ (instancetype)documentsDirectory;

+ (instancetype)temporaryDirectory;

@end
