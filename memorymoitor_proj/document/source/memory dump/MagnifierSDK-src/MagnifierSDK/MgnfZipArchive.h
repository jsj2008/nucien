//
//  ZipArchive.h
//  MagnifierSDKTest
//
//  Created by kirk on 15/7/21.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "minizip/unzip.h"

@protocol MgnfZipArchiveDelegate;

@interface MgnfZipArchive : NSObject

// Unzip
+ (BOOL)unzipFileAtPath:(NSString *)path
          toDestination:(NSString *)destination;

+ (BOOL)unzipFileAtPath:(NSString *)path
          toDestination:(NSString *)destination
               delegate:(id<MgnfZipArchiveDelegate>) delegate;

+ (BOOL)unzipFileAtPath:(NSString *)path
          toDestination:(NSString *)destination
              overwrite:(BOOL)overwrite
               password:(NSString *)password
                  error:(NSError *)error;

+ (BOOL)unzipFileAtPath:(NSString *)path
          toDestination:(NSString *)destination
              overwrite:(BOOL)overwrite
               password:(NSString *)password
                  error:(NSError *)error
               delegate:(id<MgnfZipArchiveDelegate>)delegate;

+ (BOOL)unzipFileAtPath:(NSString *)path
          toDestination:(NSString *)destination
        progressHandler:(void (^)(NSString *entry, unz_file_info zipInfo, long entryNumber, long total))progressHandler
      completionHandler:(void (^)(NSString *path, BOOL succeeded, NSError *error))completionHandler;

+ (BOOL)unzipFileAtPath:(NSString *)path
          toDestination:(NSString *)destination
              overwrite:(BOOL)overwrite
               password:(NSString *)password
                  error:(NSError *)error
               delegate:(id<MgnfZipArchiveDelegate>)delegate
        progressHandler:(void (^)(NSString *entry, unz_file_info zipInfo, long entryNumber, long total))progressHandler
      completionHandler:(void (^)(NSString *path, BOOL succeeded, NSError *error))completionHandler;

// Zip
+ (BOOL)createZipFileAtPath:(NSString *)path
           withFilesAtPaths:(NSArray *)paths;

+ (BOOL)createZipFileAtPath:(NSString *)path
    withContentsOfDirectory:(NSString *)directoryPath;

+ (BOOL)createZipFileAtPath:(NSString *)path
    withContentsOfDirectory:(NSString *)directoryPath
        keepParentDirectory:(BOOL)keepParentDirectory;

- (instancetype)initWithPath:(NSString *)path NS_DESIGNATED_INITIALIZER;

@property (NS_NONATOMIC_IOSONLY, readonly) BOOL open;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL close;

@end

@protocol MgnfZipArchiveDelegate <NSObject>
@optional

- (void)zipArchiveWillUnzipArchiveAtPath:(NSString *)path
                          zipInformation:(unz_global_info)zipInformation;

- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path
                         zipInformation:(unz_global_info)zipInformation
                           unzippedPath:(NSString *)unzippedPath;

- (BOOL)zipArchiveShouldUnzipFileAtIndex:(NSInteger)fileIndex
                              totalFiles:(NSInteger)totalFiles
                             archivePath: (NSString *)archivePath
                         fileInformation:(unz_file_info)fileInformation;

- (void)zipArchiveWillUnzipFileAtIndex:(NSInteger)fileIndex
                            totalFiles:(NSInteger)totalFiles
                           archivePath:(NSString *)archivePath
                       fileInformation:(unz_file_info)fileInformation;

- (void)zipArchiveDidUnzipFileAtIndex:(NSInteger)fileIndex
                           totalFiles:(NSInteger)totalFiles
                          archivePath:(NSString *)archivePath
                      fileInformation:(unz_file_info)fileInformation;

- (void)zipArchiveDidUnzipFileAtIndex:(NSInteger)fileIndex
                           totalFiles:(NSInteger)totalFiles
                          archivePath:(NSString *)archivePath
                     unzippedFilePath:(NSString *)unzippedFilePath;

- (void)zipArchiveProgressEvent:(unsigned long long)loaded
                          total:(unsigned long long)total;

- (void)zipArchiveDidUnzipArchiveFile:(NSString *)zipFile
                            entryPath:(NSString *)entryPath
                      destinationPath:(NSString *)destinationPath;

@end