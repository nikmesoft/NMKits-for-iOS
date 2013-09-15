//
//  Webservice.h
//  DemoNMKits
//
//  Created by Nikmesoft on 9/11/13.
//  Copyright (c) 2013 Nikmesoft. All rights reserved.
//

#import <NMKits/NMWSKJSONLoader.h>

@interface Webservice : NMWSKJSONLoader

- (void)getFoodDetailwithFoodID:(NSString *)food_id withUserID:(NSString *)user_id
                        withKey:(NSString *)key completionHandler:(NMWSKLoaderCompletionHandler)completionHandler;

@end
