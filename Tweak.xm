#import "../EmojiLibrary/Header.h"
#import "../PS.h"
#import <UIKit/UIImage+Private.h>

%config(generator=MobileSubstrate)

static NSArray <NSString *> *modifiedIcons;

// 7.0-8.2
static NSArray <NSString *> *modifiedIcons82() {
    NSMutableArray <NSString *> *array = [NSMutableArray array];
    [array addObject:@"bold_emoji_recents.png"];
    [array addObject:@"bold_emoji_people.png"];
    [array addObject:@"bold_emoji_nature.png"];
    [array addObject:@"bold_emoji_food-and-drink.png"];
    [array addObject:@"bold_emoji_activity.png"];
    [array addObject:@"bold_emoji_travel-and-places.png"];
    [array addObject:@"bold_emoji_objects.png"];
    [array addObject:@"bold_emoji_objects-and-symbols.png"];
    [array addObject:@"bold_emoji_flags.png"];
    [array addObject:@"emoji_recents.png"];
    [array addObject:@"emoji_people.png"];
    [array addObject:@"emoji_nature.png"];
    [array addObject:@"emoji_food-and-drink.png"];
    [array addObject:@"emoji_activity.png"];
    [array addObject:@"emoji_travel-and-places.png"];
    [array addObject:@"emoji_objects.png"];
    [array addObject:@"emoji_objects-and-symbols.png"];
    [array addObject:@"emoji_flags.png"];
    return array;
}

// 8.3-8.4
static NSArray *modifiedIcons83() {
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:@"bold_emoji_activity.png"];
    [array addObject:@"bold_emoji_nature.png"];
    [array addObject:@"bold_emoji_flags.png"];
    [array addObject:@"bold_emoji_objects.png"];
    [array addObject:@"emoji_activity.png"];
    [array addObject:@"emoji_nature.png"];
    [array addObject:@"emoji_flags.png"];
    [array addObject:@"emoji_objects.png"];
    return array;
}

// 9.0
static NSArray <NSString *> *modifiedIcons90() {
    NSMutableArray <NSString *> *array = [NSMutableArray array];
    [array addObject:@"bold_emoji_activity.png"];
    [array addObject:@"bold_emoji_nature.png"];
    [array addObject:@"bold_emoji_objects.png"];
    [array addObject:@"emoji_activity.png"];
    [array addObject:@"emoji_nature.png"];
    [array addObject:@"emoji_objects.png"];
    return array;
}

extern "C" UIImage *_UIImageWithName(NSString *name);
%hookf(UIImage *, _UIImageWithName, NSString *name) {
    if (name && ([name hasPrefix:@"emoji_"] || [name hasPrefix:@"bold_emoji_"]) && [modifiedIcons containsObject:name])
        return [UIImage imageNamed:name inBundle:[NSBundle bundleForClass:[UIApplication class]]];
    return %orig;
}

%group iOS83Up

%hook UIKeyboardEmojiGraphics

+ (NSString *)emojiCategoryImagePath:(UIKeyboardEmojiCategory *)category {
    PSEmojiCategory categoryType = category.categoryType;
    NSString *name = nil;
    switch (categoryType) {
        case IDXPSEmojiCategoryRecent:
            name = @"emoji_recents.png";
            break;
        case IDXPSEmojiCategoryPeople:
            name = @"emoji_people.png";
            break;
        case IDXPSEmojiCategoryNature:
            name = @"emoji_nature.png";
            break;
        case IDXPSEmojiCategoryFoodAndDrink:
            name = @"emoji_food-and-drink.png";
            break;
        case IDXPSEmojiCategoryActivity:
            name = @"emoji_activity.png";
            break;
        case IDXPSEmojiCategoryTravelAndPlaces:
            name = @"emoji_travel-and-places.png";
            break;
        case IDXPSEmojiCategoryObjects:
            name = @"emoji_objects.png";
            break;
        case IDXPSEmojiCategorySymbols:
            name = @"emoji_objects-and-symbols.png";
            break;
        case IDXPSEmojiCategoryFlags:
            name = @"emoji_flags.png";
            break;
    }
    return name;
}

%end

%end

%ctor {
    if (isiOS9Up)
        modifiedIcons = [modifiedIcons90() retain];
    else if (isiOS83Up)
        modifiedIcons = [modifiedIcons83() retain];
    else
        modifiedIcons = [modifiedIcons82() retain];
    if (isiOS83Up) {
        %init(iOS83Up);
    }
    %init;
}

%dtor {
    if (modifiedIcons)
        [modifiedIcons autorelease];
}