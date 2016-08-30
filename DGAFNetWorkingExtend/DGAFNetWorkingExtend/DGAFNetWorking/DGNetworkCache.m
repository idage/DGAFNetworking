//
//  DGNetworkCache.m
//  DGAFNetWorkingExtend
//
//  Created by 冯亮 on 16/8/29.
//  Copyright © 2016年 idage. All rights reserved.
//

#import "DGNetworkCache.h"
#import "YYCache.h"
@implementation DGNetworkCache

static NSString *const DGNetResponseCache = @"DGNetworkCache";

static YYCache *_yyCache;

+ (void)initialize
{
    _yyCache = [YYCache cacheWithName:DGNetResponseCache];
}

+ (void)saveCacheData:(id)CacheData forKey:(NSString *)key
{
    [_yyCache setObject:CacheData forKey:key withBlock:nil];
}

+ (id)getCacheDataForKey:(NSString *)key
{
    return [_yyCache objectForKey:key];
}

+ (NSInteger)diskTotalCost
{
    return [_yyCache.diskCache totalCost];
}

+ (void)removeDiskAllObjects{
   
    [_yyCache.diskCache removeAllObjects];
}

+ (void)removeMemoryAllObjects{
    
    [_yyCache.memoryCache removeAllObjects];

}

@end
