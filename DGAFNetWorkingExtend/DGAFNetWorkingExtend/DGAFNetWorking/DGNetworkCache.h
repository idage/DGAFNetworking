//
//  DGNetworkCache.h
//  DGAFNetWorkingExtend
//
//  Created by 冯亮 on 16/8/29.
//  Copyright © 2016年 idage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DGNetworkCache : NSObject
/**
 *  缓存网络数据
 *
 *  @param responseCache 需要缓存的数据
 *  @param key           url
 */
+ (void)saveCacheData:(id)CacheData forKey:(NSString *)key;
/**
 *  取出缓存的数据
 *
 *  @param key url
 *
 *  @return 缓存的数据
 */
+ (id)getCacheDataForKey:(NSString *)key;

/**
 *  磁盘缓存的总大小 字节
 */
+ (NSInteger)diskTotalCost;

/**
 *  删除所有磁盘缓存
 */
+ (void)removeDiskAllObjects;
/**
 *  删除内存缓存
 */
+ (void)removeMemoryAllObjects;


@end
