//
//  IPWTHttpUtils.m
//  ipWorldTv
//
//  Created by my full name on 5/14/14.
//  Copyright (c) 2014 IPWorldTv. All rights reserved.
//

#import "AFNetworkingHelper.h"


@implementation AFNetworkingHelper

+ (void)executePostWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters andHeaders:(NSDictionary *)headers andAuthorizationHeaderUser:(NSString *)user andAuthrozationHeaderPassword:(NSString *)password withSuccessHandler:(void (^)(AFHTTPRequestOperation *, id, bool))success withFailureHandler:(void (^)(AFHTTPRequestOperation *, NSError *))failure withLoadingViewOn:(UIView *)parentView
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [[manager securityPolicy]setAllowInvalidCertificates:YES];
    [[manager requestSerializer]setAuthorizationHeaderFieldWithUsername:user password:password];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    [[manager requestSerializer] setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // check if custom headers are present and add them
    if (headers != nil) {
        [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [[manager requestSerializer] setValue:obj forHTTPHeaderField:key];
        }];
    }
    if (parentView == nil) {
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"success %@ - %@", operation, responseObject);
            bool apiSuccess = YES;
            success(operation, responseObject, apiSuccess);
        }     failure:failure];
    }
    else {
        [MBProgressHUD showHUDAddedTo:parentView animated:YES];
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"success %@ - %@", operation, responseObject);
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            bool apiSuccess = YES;
            success(operation, responseObject, apiSuccess);
        }     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failure %d",[error code]);
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            failure(operation, error);
        }];
    }
}


+ (void) executeDeleteWithUrl:(NSString *)url AndParameters:(NSDictionary *)parameters AndHeaders:(NSDictionary *)headers withSuccessHandler:(void (^)(AFHTTPRequestOperation *, id, bool))success withFailureHandler:(void (^)(AFHTTPRequestOperation *, NSError *))failure withLoadingViewOn:(UIView *)parentView {
    
    if(![self isDataConnectionAvailable]){
        NSLog(@"No data connection is available");
        [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
        failure(nil,[[NSError alloc]initWithDomain:@"Data connection not available" code:0 userInfo:@{}]);
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [[manager requestSerializer] setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // check if custom headers are present and add them
    if (headers != nil) {
        [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [[manager requestSerializer] setValue:obj forHTTPHeaderField:key];
        }];
    }
    if (parentView == nil) {
        [manager DELETE:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"success %@ - %@", operation, responseObject);
            bool apiSuccess = YES;
            success(operation, responseObject, apiSuccess);
        }     failure:failure];
    }
    else {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:parentView animated:YES];
        [hud setLabelText:@"Loading"];
        [manager DELETE:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"success %@ - %@", operation, responseObject);
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            bool apiSuccess = YES;
            success(operation, responseObject, apiSuccess);
        }     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            NSLog(@"failure %@ - %@", operation, error);
            if(![operation isEqual:nil] & ![error isEqual:nil]){
                failure(operation, error);
            }
        }];
    }
}

+ (void)executePostWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters andHeaders:(NSDictionary *)headers constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block withSuccessHandler:(void (^)(AFHTTPRequestOperation *, id, bool))success withFailureHandler:(void (^)(AFHTTPRequestOperation *, NSError *))failure withLoadingViewOn:(UIView *)parentView {
    if(![self isDataConnectionAvailable]){
        NSLog(@"No data connection is available");
        [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
        failure(nil,[[NSError alloc]initWithDomain:@"Data connection not available" code:0 userInfo:@{}]);
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [[manager requestSerializer] setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // hack to allow 'text/plain' content-type to work
    NSMutableSet *contentTypes = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
    [contentTypes addObject:@"text/plain"];
    manager.responseSerializer.acceptableContentTypes = contentTypes;
    // check if custom headers are present and add them
    if (headers != nil) {
        [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [[manager requestSerializer] setValue:obj forHTTPHeaderField:key];
        }];
    }
    if (parentView == nil) {
        [manager POST:url parameters:parameters constructingBodyWithBlock:block success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"success %@ - %@", operation, responseObject);
            bool apiSuccess = YES;
            success(operation, responseObject, apiSuccess);
        }     failure:failure];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:parentView animated:YES];
        [hud setLabelText:@"Loading"];
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"success %@ - %@", operation, responseObject);
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            bool apiSuccess = YES;
            success(operation, responseObject, apiSuccess);
        }     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            NSLog(@"failure %@ - %@", operation, error);
            if(![operation isEqual:nil] & ![error isEqual:nil]){
                failure(operation, error);
            }
        }];
    }
}

+ (void)executePostWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters andHeaders:(NSDictionary *)headers withSuccessHandler:(void (^)(AFHTTPRequestOperation *, id, bool))success withFailureHandler:(void (^)(AFHTTPRequestOperation *, NSError *))failure withLoadingViewOn:(UIView *)parentView {
    if(![self isDataConnectionAvailable]){
        NSLog(@"No data connection is available");
        [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
        failure(nil,[[NSError alloc]initWithDomain:@"Data connection not available" code:0 userInfo:@{}]);
        return;
    }
    NSLog(@"Executing post request for %@",url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [[manager requestSerializer] setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // check if custom headers are present and add them
    if (headers != nil) {
        [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [[manager requestSerializer] setValue:obj forHTTPHeaderField:key];
        }];
    }
    if (parentView == nil) {
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //      NSLog(@"success %@ - %@", operation, responseObject);
            bool apiSuccess = YES;
            success(operation, responseObject, apiSuccess);
        }     failure:failure];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:parentView animated:YES];
        [hud setLabelText:@"Loading"];
        [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"success %@ - %@", operation, responseObject);
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            bool apiSuccess = YES;
            success(operation, responseObject, apiSuccess);
        }     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failure %@ - %@", operation, error);
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            if(![operation isEqual:nil] & ![error isEqual:nil]){
                failure(operation, error);
            }
        }];
    }
}

+ (void)executePutWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters andHeaders:(NSDictionary *)headers withSuccessHandler:(void (^)(AFHTTPRequestOperation *, id, bool))success withFailureHandler:(void (^)(AFHTTPRequestOperation *, NSError *))failure withLoadingViewOn:(UIView *)parentView {
    if(![self isDataConnectionAvailable]){
        NSLog(@"No data connection is available");
        [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
        failure(nil,[[NSError alloc]initWithDomain:@"Data connection not available" code:0 userInfo:@{}]);
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [[manager requestSerializer] setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // check if custom headers are present and add them
    if (headers != nil) {
        [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [[manager requestSerializer] setValue:obj forHTTPHeaderField:key];
        }];
    }
    if (parentView == nil) {
        [manager PUT:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"success %@ - %@", operation, responseObject);
            bool apiSuccess = YES;
            success(operation, responseObject, apiSuccess);
        }    failure:failure];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:parentView animated:YES];
        [hud setLabelText:@"Loading"];
        [manager PUT:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"success %@ - %@", operation, responseObject);
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            bool apiSuccess = [[responseObject objectForKey:@"success"] isEqual:@YES];
            success(operation, responseObject, apiSuccess);
        }    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            NSLog(@"failure %@ - %@", operation, error);
            if(![operation isEqual:nil] & ![error isEqual:nil]){
                failure(operation, error);
            }
        }];
    }
}


+ (void)executeGetWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters andHeaders:(NSDictionary *)headers withSuccessHandler:(void (^)(AFHTTPRequestOperation *, id, bool))success withFailureHandler:(void (^)(AFHTTPRequestOperation *, NSError *))failure withLoadingViewOn:(UIView *)parentView {
    if(![self isDataConnectionAvailable]){
        NSLog(@"No data connection is available");
        [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
        failure(nil,[[NSError alloc]initWithDomain:@"Data connection not available" code:0 userInfo:@{}]);
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [[manager requestSerializer] setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // check if custom headers are present and add them
    if (headers != nil) {
        [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [[manager requestSerializer] setValue:obj forHTTPHeaderField:key];
        }];
    }
    // if failure is nil then its an indication to handle it with default flow that is showing message
    // in alert dialog
    
    if (parentView == nil) {
        [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            bool apiSuccess = YES;
            success(operation, responseObject, apiSuccess);
        }    failure:failure];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:parentView animated:YES];
        [hud setLabelText:@"Loading"];
        [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"success %@ - %@", operation, responseObject);
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            bool apiSuccess = YES;
            success(operation, responseObject, apiSuccess);
        }    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failure %@ - %@", operation, error);
            if(![operation isEqual:nil] & ![error isEqual:nil]){
                @try {
                    if(failure)
                        failure(operation, error);
                    [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
                }
                @catch (NSException *exception) {
                    NSLog(@"exception handling timeout %@",exception);
                }
            }
        }];
    }
}

+ (void)executePatchWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters andHeaders:(NSDictionary *)headers withSuccessHandler:(void (^)(AFHTTPRequestOperation *, id, bool))success withFailureHandler:(void (^)(AFHTTPRequestOperation *, NSError *))failure withLoadingViewOn:(UIView *)parentView {
    if(![self isDataConnectionAvailable]){
        NSLog(@"No data connection is available");
        [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
        failure(nil,[[NSError alloc]initWithDomain:@"Data connection not available" code:0 userInfo:@{}]);
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [[manager requestSerializer] setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // check if custom headers are present and add them
    if (headers != nil) {
        [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [[manager requestSerializer] setValue:obj forHTTPHeaderField:key];
        }];
    }
    if (parentView == nil) {
        [manager PATCH:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"success %@ - %@", operation, responseObject);
            bool apiSuccess = YES;
            success(operation, responseObject, apiSuccess);
        }    failure:failure];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:parentView animated:YES];
        [hud setLabelText:@"Loading"];
        [manager PATCH:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"success %@ - %@", operation, responseObject);
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            bool apiSuccess = [[responseObject objectForKey:@"success"] isEqual:@YES];
            success(operation, responseObject, apiSuccess);
        }    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            NSLog(@"failure %@ - %@", operation, error);
            if(![operation isEqual:nil] & ![error isEqual:nil]){
                failure(operation, error);
            }
        }];
    }
}

#warning This function is not working as expected
+ (BOOL)isDataConnectionAvailable {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

@end
