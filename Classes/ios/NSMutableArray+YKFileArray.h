/*
 * Created by Yumenosuke Koukata on 3/10/14.
 * Copyright (c) 2014 ZYXW. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "YKFile.h"

@interface NSMutableArray (YKFileArray)

- (void)eachFile:(void (^)(YKFile *file, NSUInteger idx))pFunction;

- (void)sortFiles:(NSComparisonResult (^)(YKFile *file1, YKFile *file2))pFunction;

- (void)removeFilesFromList:(BOOL (^)(YKFile *file))pFunction;

- (YKFileArray *)cutFilesFromList:(BOOL (^)(YKFile *file))pFunction;

@end
