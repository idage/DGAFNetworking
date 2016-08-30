//
//  DGCacheConfig.h
//  DGAFNetWorkingExtend
//
//  Created by 冯亮 on 16/8/29.
//  Copyright © 2016年 idage. All rights reserved.
//

#import <Foundation/Foundation.h>
/*--------------缓存配置参数项-----------------------------*/
/** 缓存配置的参数项 时间 */
extern NSString* const CACHE_ITEM_DURATION;
/** 缓存配置的参数项 ：版本 */
extern NSString* const CACHE_ITEM_VERSION;

@interface DGCacheConfig : NSObject
/**
 *  根据请求地址获取缓存配置
 *
 *  @param apiStr 网络请求地址
 *
 *  @return 配置内容
 */
+(NSDictionary*)getConfig:(NSString*)apiStr;
/**
 *  添加一个API的缓存配置
 *
 *  @param apiStr   网络请求地址
 *  @param duration 根据时间差缓存 （几秒钟之内请求网络返回的是缓存内容）
 *  @param version  根据版本缓存    （版本变化则请求 否则返回的是缓存内容）
 */
+(void)setConfigApi:(NSString*)apiStr duration:(NSInteger)duration versionStr:(NSString*)version;
@end


