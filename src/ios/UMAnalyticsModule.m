//
//  UMAnalyticsModule
//
//  Created by wangkai on 16-04-14.
//
//

#import "UMAnalyticsModule.h"
#import <UMAnalytics/MobClick.h>
#import <UMAnalytics/MobClickGameAnalytics.h>
#import <UMAnalytics/DplusMobClick.h>
#import <UMCommonModule.h>


@interface UMAnalyticsModule ()

#if __has_feature(objc_arc)
@property (nonatomic, strong) NSString *currPageName;
#else
@property (nonatomic, retain) NSString *currPageName;
#endif

@end

@implementation UMAnalyticsModule

#if __has_feature(objc_arc)
#else
- (void)dealloc {
    [super dealloc];
}
#endif

- (void)init:(CDVInvokedUrlCommand*)command {
    NSString *eventId = [command.arguments objectAtIndex:0];
    if (eventId == nil || [eventId isKindOfClass:[NSNull class]]) {
        return;
    }
    NSString *appKey = [command.arguments objectAtIndex:1];
    if ([appKey isKindOfClass:[NSNull class]]) {
        appKey = nil;
    }
    NSString *channel = [command.arguments objectAtIndex:2];
    if ([channel isKindOfClass:[NSNull class]]) {
        channel = nil;
    }
    [UMCommonModule initWithAppkey:appKey channel:channel];
}


- (void)onEvent:(CDVInvokedUrlCommand*)command {
    NSString *eventId = [command.arguments objectAtIndex:0];
    if (eventId == nil || [eventId isKindOfClass:[NSNull class]]) {
        return;
    }
    [MobClick event:eventId];
}

- (void)onEventWithLabel:(CDVInvokedUrlCommand*)command{
    NSString *eventId = [command.arguments objectAtIndex:0];
    if (eventId == nil || [eventId isKindOfClass:[NSNull class]]) {
        return;
    }
    NSString *eventLabel = [command.arguments objectAtIndex:1];
    if ([eventLabel isKindOfClass:[NSNull class]]) {
        eventLabel = nil;
    }
    [MobClick event:eventId label:eventLabel];
}

- (void)onEventWithParameters:(CDVInvokedUrlCommand*)command {
    NSString *eventId = [command.arguments objectAtIndex:0];
    if (eventId == nil || [eventId isKindOfClass:[NSNull class]]) {
        return;
    }
    NSDictionary *parameters = [command.arguments objectAtIndex:1];
    if (parameters == nil && [parameters isKindOfClass:[NSNull class]]) {
        parameters = nil;
    }
    [MobClick event:eventId attributes:parameters];
}

- (void)onEventWithCounter:(CDVInvokedUrlCommand*)command {
    NSString *eventId = [command.arguments objectAtIndex:0];
    if (eventId == nil || [eventId isKindOfClass:[NSNull class]]) {
        return;
    }
    NSDictionary *parameters = [command.arguments objectAtIndex:1];
    if (parameters == nil && [parameters isKindOfClass:[NSNull class]]) {
        parameters = nil;
    }
    NSString *eventNum = [command.arguments objectAtIndex:2];
    if (eventNum == nil && [eventNum isKindOfClass:[NSNull class]]) {
        eventNum = nil;
    }
    int num = [eventNum intValue];
    [MobClick event:eventId attributes:parameters counter:num];
}

- (void)onPageBegin:(CDVInvokedUrlCommand*)command {
    NSString *pageName = [command.arguments objectAtIndex:0];
    if (pageName == nil || [pageName isKindOfClass:[NSNull class]]) {
        return;
    }
    [MobClick beginLogPageView:pageName];
}

- (void)onPageEnd:(CDVInvokedUrlCommand*)command {
    NSString *pageName = [command.arguments objectAtIndex:0];
    if (pageName == nil || [pageName isKindOfClass:[NSNull class]]) {
        return;
    }
    [MobClick endLogPageView:pageName];
}

- (void)profileSignInWithPUID:(CDVInvokedUrlCommand*)command  {
    NSString *puid = [command.arguments objectAtIndex:0];
    if (puid == nil || [puid isKindOfClass:[NSNull class]]) {
        return;
    }
    [MobClickGameAnalytics profileSignInWithPUID:puid];
}

- (void)profileSignInWithPUIDWithProvider:(CDVInvokedUrlCommand*)command {
    NSString *provider = [command.arguments objectAtIndex:0];
    if (provider == nil && [provider isKindOfClass:[NSNull class]]) {
        provider = nil;
    }
    NSString *puid = [command.arguments objectAtIndex:1];
    if (puid == nil || [puid isKindOfClass:[NSNull class]]) {
        return;
    }

    [MobClickGameAnalytics profileSignInWithPUID:puid provider:provider];
}

- (void)profileSignOff:(NSArray *)arguments {
    [MobClickGameAnalytics profileSignOff];

}
//游戏统计

- (void)setUserLevelId:(CDVInvokedUrlCommand*)command {
    NSString *level = [command.arguments objectAtIndex:0];
    if (level == nil || [level isKindOfClass:[NSNull class]]) {
        return;
    }
    int levelValue = [level intValue];
    [MobClickGameAnalytics setUserLevelId:levelValue];
}

- (void)startLevel:(CDVInvokedUrlCommand*)command  {
    NSString *level = [command.arguments objectAtIndex:0];
    if (level == nil || [level isKindOfClass:[NSNull class]]) {
        return;
    }
    [MobClickGameAnalytics startLevel:level];
}

- (void)finishLevel:(CDVInvokedUrlCommand*)command   {
    NSString *level = [command.arguments objectAtIndex:0];
    if (level == nil || [level isKindOfClass:[NSNull class]]) {
        return;
    }
    [MobClickGameAnalytics finishLevel:level];
}

- (void)failLevel:(CDVInvokedUrlCommand*)command {
    NSString *level = [command.arguments objectAtIndex:0];
    if (level == nil || [level isKindOfClass:[NSNull class]]) {
        return;
    }
    [MobClickGameAnalytics failLevel:level];
}

- (void)exchange:(CDVInvokedUrlCommand*)command {

    NSString *currencyAmount = [command.arguments objectAtIndex:0];
    if (currencyAmount == nil && [currencyAmount isKindOfClass:[NSNull class]]) {
        currencyAmount = nil;
    }
    NSString *currencyType = [command.arguments objectAtIndex:1];
    if (currencyType == nil && [currencyType isKindOfClass:[NSNull class]]) {
        currencyType = nil;
    }
    NSString *virtualAmount = [command.arguments objectAtIndex:2];
    if (virtualAmount == nil && [virtualAmount isKindOfClass:[NSNull class]]) {
        virtualAmount = nil;
    }
    NSString *channel = [command.arguments objectAtIndex:3];
    if (channel == nil && [channel isKindOfClass:[NSNull class]]) {
        channel = nil;
    }
    NSString *orderId = [command.arguments objectAtIndex:4];
    if (orderId == nil || [orderId isKindOfClass:[NSNull class]]) {
        return;
    }
    double currencyAmountDouble = [currencyAmount doubleValue];
    double virtualAmountDouble = [virtualAmount doubleValue];
    int channelInt = [channel intValue];
    [MobClickGameAnalytics exchange:orderId currencyAmount:currencyAmountDouble currencyType:currencyType virtualCurrencyAmount:virtualAmountDouble paychannel:channelInt];
}

- (void)pay:(CDVInvokedUrlCommand*)command {
    NSString *cash = [command.arguments objectAtIndex:0];
    if (cash == nil || [cash isKindOfClass:[NSNull class]]) {
        return;
    }
    NSString *coin = [command.arguments objectAtIndex:1];
    if (coin == nil && [coin isKindOfClass:[NSNull class]]) {
        coin = nil;
    }
    NSString *source = [command.arguments objectAtIndex:2];
    if (source == nil && [source isKindOfClass:[NSNull class]]) {
        source = nil;
    }


    double cashDouble = [cash doubleValue];
    int sourceInt = [source doubleValue];
    double coinDouble = [coin doubleValue];
    [MobClickGameAnalytics pay:cashDouble source:sourceInt coin:coinDouble];
}

- (void)payWithItem:(CDVInvokedUrlCommand*)command {
    NSString *cash = [command.arguments objectAtIndex:0];
    if (cash == nil || [cash isKindOfClass:[NSNull class]]) {
        return;
    }
    NSString *item = [command.arguments objectAtIndex:1];
    if (item == nil && [item isKindOfClass:[NSNull class]]) {
        item = nil;
    }
    NSString *amount = [command.arguments objectAtIndex:2];
    if (amount == nil && [amount isKindOfClass:[NSNull class]]) {
        amount = nil;
    }
    NSString *price = [command.arguments objectAtIndex:3];
    if (price == nil && [price isKindOfClass:[NSNull class]]) {
        price = nil;
    }
    NSString *source = [command.arguments objectAtIndex:4];
    if (source == nil && [source isKindOfClass:[NSNull class]]) {
        source = nil;
    }
    double cashDoule = [cash doubleValue];
    int sourceInt = [source intValue];
    int amountInt = [amount intValue];
    double priceDouble = [price doubleValue];
    [MobClickGameAnalytics pay:cashDoule source:sourceInt item:item amount:amountInt price:priceDouble];
}

- (void)buy:(CDVInvokedUrlCommand*)command {
    NSString *item = [command.arguments objectAtIndex:0];
    if (item == nil || [item isKindOfClass:[NSNull class]]) {
        return;
    }
    NSString *amount = [command.arguments objectAtIndex:1];
    if (amount == nil && [amount isKindOfClass:[NSNull class]]) {
        amount = nil;
    }
    NSString *price = [command.arguments objectAtIndex:2];
    if (price == nil && [price isKindOfClass:[NSNull class]]) {
        price = nil;
    }

    int amountInt = [amount doubleValue];
    double priceDouble = [price doubleValue];
    [MobClickGameAnalytics buy:item amount:amountInt price:priceDouble];
}

- (void)use:(CDVInvokedUrlCommand*)command {
    NSString *item = [command.arguments objectAtIndex:0];
    if (item == nil || [item isKindOfClass:[NSNull class]]) {
        return;
    }
    NSString *amount = [command.arguments objectAtIndex:1];
    if (amount == nil && [amount isKindOfClass:[NSNull class]]) {
        amount = nil;
    }
    NSString *price = [command.arguments objectAtIndex:2];
    if (price == nil && [price isKindOfClass:[NSNull class]]) {
        price = nil;
    }

    int amountInt = [amount doubleValue];
    double priceDouble = [price doubleValue];
    [MobClickGameAnalytics use:item amount:amountInt price:priceDouble];
}

- (void)bonus:(CDVInvokedUrlCommand*)command {
    NSString *coin = [command.arguments objectAtIndex:0];
    if (coin == nil || [coin isKindOfClass:[NSNull class]]) {
        return;
    }
    NSString *source = [command.arguments objectAtIndex:1];
    if (source == nil && [source isKindOfClass:[NSNull class]]) {
        source = nil;
    }

    double coinDouble = [coin doubleValue];
    int sourceInt = [source doubleValue];
    [MobClickGameAnalytics bonus:coinDouble source:sourceInt];
}

- (void)bonusWithItem:(CDVInvokedUrlCommand*)command {
    NSString *item = [command.arguments objectAtIndex:0];
    if (item == nil || [item isKindOfClass:[NSNull class]]) {
        return;
    }
    NSString *amount = [command.arguments objectAtIndex:1];
    if (amount == nil && [amount isKindOfClass:[NSNull class]]) {
        amount = nil;
    }
    NSString *price = [command.arguments objectAtIndex:2];
    if (price == nil && [price isKindOfClass:[NSNull class]]) {
        price = nil;
    }
    NSString *source = [command.arguments objectAtIndex:3];
    if (source == nil && [source isKindOfClass:[NSNull class]]) {
        source = nil;
    }

    int amountInt = [amount doubleValue];
    double priceDouble = [price doubleValue];
    int sourceInt = [source doubleValue];
    [MobClickGameAnalytics bonus:item amount:amountInt price:priceDouble source:sourceInt];
}

//Dplus
- (void)track:(CDVInvokedUrlCommand*)command {
    NSString *eventName = [command.arguments objectAtIndex:0];
    if (eventName == nil || [eventName isKindOfClass:[NSNull class]]) {
        return;
    }
    [DplusMobClick track:eventName];
}

- (void)trackWithProperty:(CDVInvokedUrlCommand*)command {
    NSString *eventName = [command.arguments objectAtIndex:0];
    if (eventName == nil || [eventName isKindOfClass:[NSNull class]]) {
        return;
    }
    NSDictionary *property = [command.arguments objectAtIndex:1];
    [DplusMobClick track:eventName property:property];
}

- (void)registerSuperProperty:(CDVInvokedUrlCommand*)command {
    NSDictionary *property = [command.arguments objectAtIndex:0];
    [DplusMobClick registerSuperProperty:property];
}

- (void)unregisterSuperProperty:(CDVInvokedUrlCommand*)command {
    NSString *propertyName = [command.arguments objectAtIndex:0];
    if (propertyName == nil || [propertyName isKindOfClass:[NSNull class]]) {
        return;
    }
    [DplusMobClick unregisterSuperProperty:propertyName];
}

- (void)getSuperProperty:(CDVInvokedUrlCommand*)command {
    NSString *propertyName = [command.arguments objectAtIndex:0];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[DplusMobClick getSuperProperty:propertyName]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];


}

- (void)getSuperProperties:(CDVInvokedUrlCommand*)command {

    NSString *jsonString = nil;
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[DplusMobClick getSuperProperties]
                                                       options:kNilOptions //TODO: NSJSONWritingPrettyPrinted  // kNilOptions
                                                         error:&error];
    if ([jsonData length] && (error == nil))
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] ;
    }else{
        jsonString=@"";
    }
    NSString *callBack = [NSString stringWithFormat:@"getSuperProperties('%@')",jsonString];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:callBack];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)clearSuperProperties:(CDVInvokedUrlCommand*)commands {
    [DplusMobClick clearSuperProperties];
}

- (void)setFirstLaunchEvent:(CDVInvokedUrlCommand*)command {
    NSArray *eventList = [command.arguments objectAtIndex:0];
    [DplusMobClick setFirstLaunchEvent:eventList];
}

@end
