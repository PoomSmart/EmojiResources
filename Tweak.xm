#define CHECK_TARGET
#import "../EmojiLibrary/Header.h"
#import "../PS.h"
#import <UIKit/UIImage+Private.h>

static NSArray *modifiedIcons;

// For EmojiDarkStyle
#define DARK_ICONS_COUNT 7
static void addDarkIcons(NSMutableArray *array) {
    [array addObject:@"emoji_people_dark.png"];
    [array addObject:@"emoji_nature_dark.png"];
    [array addObject:@"emoji_food-and-drink_dark.png"];
    [array addObject:@"emoji_activity_dark.png"];
    [array addObject:@"emoji_travel-and-places_dark.png"];
    [array addObject:@"emoji_objects_dark.png"];
    [array addObject:@"emoji_flags_dark.png"];
}

// 6.0-8.2
static NSArray *modifiedIcons82() {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:18 + DARK_ICONS_COUNT];
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
    addDarkIcons(array);
    return array;
}

// 8.3-8.4
static NSArray *modifiedIcons83() {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:8 + DARK_ICONS_COUNT];
    [array addObject:@"bold_emoji_activity.png"];
    [array addObject:@"bold_emoji_nature.png"];
    [array addObject:@"bold_emoji_flags.png"];
    [array addObject:@"bold_emoji_objects.png"];
    [array addObject:@"emoji_activity.png"];
    [array addObject:@"emoji_nature.png"];
    [array addObject:@"emoji_flags.png"];
    [array addObject:@"emoji_objects.png"];
    addDarkIcons(array);
    return array;
}

// 9.0
static NSArray *modifiedIcons90() {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:6 + DARK_ICONS_COUNT];
    [array addObject:@"bold_emoji_activity.png"];
    [array addObject:@"bold_emoji_nature.png"];
    [array addObject:@"bold_emoji_objects.png"];
    [array addObject:@"emoji_activity.png"];
    [array addObject:@"emoji_nature.png"];
    [array addObject:@"emoji_objects.png"];
    addDarkIcons(array);
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

+ (NSString *)emojiCategoryImagePath: (UIKeyboardEmojiCategory *)category {
    NSInteger type = category.categoryType;
    NSString *name = nil;
    switch (type) {
        case 0:
            name = @"emoji_recents.png";
            break;
        case 1:
            name = @"emoji_people.png";
            break;
        case 2:
            name = @"emoji_nature.png";
            break;
        case 3:
            name = @"emoji_food-and-drink.png";
            break;
        case 4:
            name = @"emoji_activity.png";
            break;
        case 5:
            name = @"emoji_travel-and-places.png";
            break;
        case 6:
            name = @"emoji_objects.png";
            break;
        case 7:
            name = @"emoji_objects-and-symbols.png";
            break;
        case 8:
            name = @"emoji_flags.png";
            break;
    }
    return name;
}

%end

%end

%ctor {
    if (isTarget(TargetTypeGUINoExtension)) {
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
}
