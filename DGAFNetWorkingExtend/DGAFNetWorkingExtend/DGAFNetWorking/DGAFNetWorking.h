//
//  DGNetworkHelper.h
//  DGAFNetWorkingExtend
//
//  Created by 冯亮 on 16/8/29.
//  Copyright © 2016年 idage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DGNetworkStatus) {
    DGNetworkStatusUnknown,          // 未知网络
    DGNetworkStatusNotReachable,     // 无网络
    DGNetworkStatusReachableViaWWAN, // 3G/4G网络
    DGNetworkStatusReachableViaWiFi  // WIFI
};
/**
 *  网络变化的通知
 */
extern NSString* const DG_NOTI_NETWORK_CHANGE;

@interface DGAFNetWorking : NSObject
/**
 *  开始监听网络
 */
+(void)startMonitoring;
/**
 *  停止监听
 */
+(void)stopMonitoring;
/**
 *  当前有没有网络
 *
 *  @return 是否有网
 */
+ (BOOL)isConnectionAvailable;
/**
 *  当前的网络状态
 *
 *  @return 状态的描述
 */
+  (DGNetworkStatus)curentNetworkStatus;

/**
 *  GET请求
 *
 *  @param URL        url
 *  @param parameters 参数
 *  @param success    成功回调
 *  @param failure    失败回调
 *
 *  @return NSURLSessionTask
 */
+ (NSURLSessionTask *)GET:(NSString *)URL
                        parameters:(NSDictionary *)parameters
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(id error))failure;

/**
 *   有缓存的GET请求 
 *
 *  @param URL           url
 *  @param parameters    参数
 *  @param cacheKey      缓存的key 默认为url
 *  @param isResponseCache   是否有缓存的时候只返回缓存数据不再请求网络
 *  @param responseCache 缓存的数据
 *  @param success       成功回调
 *  @param failure       失败回调
 *
 *  @return NSURLSessionTask
 */
+ (NSURLSessionTask *)GET:(NSString *)URL
               parameters:(NSDictionary *)parameters
                 cacheKey:(NSString*)cacheKey
          isResponseCache:(BOOL)isResponseCache
            responseCache:(void (^)(id cacheObject))responseCache
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(id error))failure;

/**
 *  POST请求
 *
 *  @param URL        url
 *  @param parameters 参数
 *  @param success    成功回调
 *  @param failure    失败回调
 *
 *  @return NSURLSessionTask
 */
+ (NSURLSessionTask *)POST:(NSString *)URL
                         parameters:(NSDictionary *)parameters
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(id error))failure;

/**
 *   有缓存的POST请求
 *
 *  @param URL           url
 *  @param parameters    参数
 *  @param cacheKey      缓存的key 默认为url
 *  @param isResponseCache   是否有缓存的时候只返回缓存数据不再请求网络
 *  @param responseCache 缓存的数据
 *  @param success       成功回调
 *  @param failure       失败回调
 *
 *  @return NSURLSessionTask
 */
+ (NSURLSessionTask *)POST:(NSString *)URL
                         parameters:(NSDictionary *)parameters
                           cacheKey:(NSString*)cacheKey
                    isResponseCache:(BOOL)isResponseCache
                      responseCache:(void (^)(id cacheObject))responseCache
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(id error))failure;
/**
 *  根据版本 或者时间差来缓存数据 （版本相同或者没有超过时间差则返回缓存数据）
 *  @param URL            url
 *  @param parameters     请求参数
 *  @param cacheKey       缓存的key 默认为url
 *  @param version        是不是根据版本缓存(版本号)
 *  @param durtion        根据时间差缓存（以秒为单位 不根据时间传0）
 *  @param success        成功回调
 *  @param failure        失败回调
 */
+ (void)GET:(NSString *)URL
                  parameters:(NSDictionary *)parameters
                    cacheKey:(NSString*)cacheKey
                versionCache:(NSString*)version
                durtionCache:(NSInteger)durtion
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(id error))failure;
/**
 *  根据版本 或者时间差来缓存数据 （版本相同或者没有超过时间差则返回缓存数据）
 *  @param URL            url
 *  @param parameters     请求参数
 *  @param cacheKey       缓存的key 默认为url
 *  @param version        是不是根据版本缓存(版本号)
 *  @param durtion        根据时间差缓存（以秒为单位 不根据时间传0）
 *  @param success        成功回调
 *  @param failure        失败回调
 */
+ (void)POST:(NSString *)URL
                      parameters:(NSDictionary *)parameters
                        cacheKey:(NSString*)cacheKey
                    versionCache:(NSString*)version
                    durtionCache:(NSInteger)durtion
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(id error))failure;

/**
 *  上传图片文件
 *
 *  @param URL        url
 *  @param parameters 参数
 *  @param images     图片数组
 *  @param name       文件对应服务器上的字段名
 *  @param fileName   文件名
 *  @param mimeType   图片文件的类型
 *  @param quality    t图片的压缩程度 (0-1)
 *  @param progress   上传进度信息
 *  @param success       成功回调
 *  @param failure       失败回调
 *
 *  @return NSURLSessionTask
 */
+ (NSURLSessionTask *)uploadWithURL:(NSString *)URL
                                  parameters:(NSDictionary *)parameters
                                      images:(NSArray<UIImage *> *)images
                                        name:(NSString *)name
                                    fileName:(NSString *)fileName
                                    mimeType:(NSString *)mimeType
                                         img:(CGFloat)quality
                                    progress:(void (^)(NSProgress *progress))progress
                                     success:(void (^)(id responseObject))success
                                     failure:(void (^)(id error))failure;

/**
 *  下载文件
 *
 *  @param URL      url
 *  @param fileDir  文件存储目录(/Library/Caches/download/)
 *  @param progress 文件下载的进度信息
 *  @param success       成功回调 filePath:文件的路径
 *  @param failure       失败回调
 *
 *  @return NSURLSessionTask
 */
+ (NSURLSessionTask *)downloadWithURL:(NSString *)URL
                                       fileDir:(NSString *)fileDir
                                      progress:(void (^)(NSProgress *progress))progress
                                       success:(void(^)(NSString *filePath))success
                                       failure:(void (^)(id error))failure;


@end
