/*
 * Created by Yumenosuke Koukata on 3/10/14.
 * Copyright (c) 2014 ZYXW. All rights reserved.
 */

#import "NSMutableArray+YKFileArray.h"

@implementation NSMutableArray (YKFileArray)

- (void)eachFile:(void (^)(YKFile *file, NSUInteger idx))pFunction {
	if (!pFunction) return;
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		pFunction(obj, idx);
	}];
}

- (void)sortFiles:(NSComparisonResult (^)(YKFile *file1, YKFile *file2))pFunction {
	if (!pFunction) return;
	return [self sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		return pFunction(obj1, obj2);
	}];
}

- (void)removeFilesFromList:(BOOL (^)(YKFile *file))pFunction {
	if (!pFunction) return;
	for (int i = [self count] - 1; i >= 0; --i) {
		YKFile *file = self[i];
		if (pFunction(file)) [self removeObject:file];
	}
}

- (YKFileArray *)cutFilesFromList:(BOOL (^)(YKFile *file))pFunction {
	YKFileArray *files = [YKFileArray new];
	if (!pFunction) return files;
	[files eachFile:^(YKFile *file, NSUInteger idx) {
		if (pFunction(files)) [files addObject:file];
	}];
	[self removeObjectsInArray:files];
	return files;
}

@end
