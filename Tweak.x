#import <EmojiLibrary/Header.h>
#import <UIKit/UIImage+Private.h>
#import <PSHeader/PS.h>
#import <version.h>

static NSArray <NSString *> *modifiedIcons;

static NSArray <NSString *> *modifiedIconNames() {
    NSMutableArray <NSString *> *array = [NSMutableArray array];
    [array addObject:@"bold_emoji_recents.png"];
    [array addObject:@"bold_emoji_recents_split.png"];
    [array addObject:@"bold_emoji_people.png"];
    [array addObject:@"bold_emoji_people_split.png"];
    [array addObject:@"bold_emoji_nature.png"];
    [array addObject:@"bold_emoji_nature_split.png"];
    [array addObject:@"bold_emoji_food-and-drink.png"];
    [array addObject:@"bold_emoji_food-and-drink_split.png"];
    [array addObject:@"bold_emoji_activity.png"];
    [array addObject:@"bold_emoji_activity_split.png"];
    [array addObject:@"bold_emoji_travel-and-places.png"];
    [array addObject:@"bold_emoji_travel-and-places_split.png"];
    [array addObject:@"bold_emoji_objects.png"];
    [array addObject:@"bold_emoji_objects_split.png"];
    [array addObject:@"bold_emoji_objects-and-symbols.png"];
    [array addObject:@"bold_emoji_objects-and-symbols_split.png"];
    [array addObject:@"bold_emoji_flags.png"];
    [array addObject:@"bold_emoji_flags_split.png"];
    [array addObject:@"emoji_recents.png"];
    [array addObject:@"emoji_recents_split.png"];
    [array addObject:@"emoji_people.png"];
    [array addObject:@"emoji_people_split.png"];
    [array addObject:@"emoji_nature.png"];
    [array addObject:@"emoji_nature_split.png"];
    [array addObject:@"emoji_food-and-drink.png"];
    [array addObject:@"emoji_food-and-drink_split.png"];
    [array addObject:@"emoji_activity.png"];
    [array addObject:@"emoji_activity_split.png"];
    [array addObject:@"emoji_travel-and-places.png"];
    [array addObject:@"emoji_travel-and-places_split.png"];
    [array addObject:@"emoji_objects.png"];
    [array addObject:@"emoji_objects_split.png"];
    [array addObject:@"emoji_objects-and-symbols.png"];
    [array addObject:@"emoji_objects-and-symbols_split.png"];
    [array addObject:@"emoji_flags.png"];
    [array addObject:@"emoji_flags_split.png"];
    [array addObject:@"emoji_people_dark.png"];
    [array addObject:@"emoji_nature_dark.png"];
    [array addObject:@"emoji_activity_dark.png"];
    return array;
}

static NSString *PSCanonicalEmojiIconName(NSString *name) {
    if (!name.length)
        return nil;
    if (![name hasPrefix:@"emoji_"] && ![name hasPrefix:@"bold_emoji_"])
        return nil;
    BOOL dark = [name containsString:@"_dark"];
    NSString *canonical = [name stringByReplacingOccurrencesOfString:@"_dark" withString:@""];
    if ([canonical hasSuffix:@"emoji_symbols.png"])
        canonical = [canonical stringByReplacingOccurrencesOfString:@"emoji_symbols.png" withString:@"emoji_objects-and-symbols.png"];
    else if ([canonical hasSuffix:@"emoji_celebration.png"])
        canonical = [canonical stringByReplacingOccurrencesOfString:@"emoji_celebration.png" withString:@"emoji_activity.png"];
    if (dark) {
        NSString *darkName = [[canonical stringByDeletingPathExtension] stringByAppendingString:@"_dark.png"];
        if ([modifiedIcons containsObject:darkName])
            return darkName;
    }
    if ([modifiedIcons containsObject:canonical])
        return canonical;
    return nil;
}

static UIImage *PSUIKitOverlayImage(NSString *fileName) {
    NSString *dir = PS_ROOT_PATH_NS(@"/System/Library/Frameworks/UIKit.framework");
    NSString *stem = [fileName stringByDeletingPathExtension];
    CGFloat scale = [UIScreen mainScreen].scale;
    BOOL ipad = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
    NSMutableArray <NSString *> *names = [NSMutableArray array];
    if (ipad) {
        [names addObject:[NSString stringWithFormat:@"%@@%.0fx~ipad.png", stem, scale]];
        [names addObject:[NSString stringWithFormat:@"%@~ipad.png", stem]];
    }
    [names addObject:[NSString stringWithFormat:@"%@@%.0fx.png", stem, scale]];
    [names addObject:fileName];
    NSFileManager *fm = [NSFileManager defaultManager];
    for (NSString *name in names) {
        NSString *path = [dir stringByAppendingPathComponent:name];
        if (![fm fileExistsAtPath:path])
            continue;
        CGFloat imageScale = [name containsString:@"@3x"] ? 3 : [name containsString:@"@2x"] ? 2 : 1;
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:path] scale:imageScale];
        if (image)
            return image;
    }
    return nil;
}

static UIImage *PSEmojiImageNamed(NSString *name) {
    NSString *canonical = PSCanonicalEmojiIconName(name);
    if (!canonical)
        return nil;
    return PSUIKitOverlayImage(canonical);
}

static NSString *PSEmojiCategoryImagePath(PSEmojiCategory categoryType) {
    if (IS_IOS_OR_NEWER(iOS_9_1)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wswitch"
        switch (categoryType) {
#pragma clang diagnostic pop
            case PSEmojiCategoryRecent:
                return @"emoji_recents.png";
            case PSEmojiCategoryPeople:
                return @"emoji_people.png";
            case PSEmojiCategoryNature:
                return @"emoji_nature.png";
            case PSEmojiCategoryFoodAndDrink:
                return @"emoji_food-and-drink.png";
            case PSEmojiCategoryCelebration:
            case PSEmojiCategoryActivity:
                return @"emoji_activity.png";
            case PSEmojiCategoryTravelAndPlaces:
                return @"emoji_travel-and-places.png";
            case PSEmojiCategoryObjects:
                return @"emoji_objects.png";
            case PSEmojiCategorySymbols:
                return @"emoji_objects-and-symbols.png";
            case PSEmojiCategoryFlags:
                return @"emoji_flags.png";
            default:
                return nil;
        }
    }
    NSString *name = nil;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wswitch"
    switch (categoryType) {
#pragma clang diagnostic pop
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

%group UIImageNameHooks

%hookf(UIImage *, _UIImageWithName, NSString *name) {
    UIImage *image = PSEmojiImageNamed(name);
    if (image)
        return image;
    return %orig;
}

%end

%group TraitUIImageHooks

%hookf(UIImage *, _UIImageWithNameAndTraitCollection, NSString *name, UITraitCollection *traitCollection) {
    (void)traitCollection;
    UIImage *image = PSEmojiImageNamed(name);
    if (image)
        return image;
    return %orig;
}

%end

%group OverrideNames

%hook UIKeyboardEmojiGraphics

+ (NSString *)emojiCategoryImagePath:(UIKeyboardEmojiCategory *)category {
    return PSEmojiCategoryImagePath(category.categoryType);
}

%end

%end

%ctor {
    modifiedIcons = modifiedIconNames();
    if (IS_IOS_OR_NEWER(iOS_8_3))
        %init(OverrideNames);
    %init(UIImageNameHooks);
    const char *UIKitImagePath = IS_IOS_OR_NEWER(iOS_13_0)
        ? "/System/Library/PrivateFrameworks/UIKitCore.framework/UIKitCore"
        : "/System/Library/Frameworks/UIKit.framework/UIKit";
    MSImageRef UIKitImage = MSGetImageByName(UIKitImagePath);
    void *UIImageWithNameAndTraitCollection = UIKitImage ? MSFindSymbol(UIKitImage, "__UIImageWithNameAndTraitCollection") : NULL;
    if (!UIImageWithNameAndTraitCollection && UIKitImage)
        UIImageWithNameAndTraitCollection = MSFindSymbol(UIKitImage, "_UIImageWithNameAndTraitCollection");
    if (UIImageWithNameAndTraitCollection)
        %init(TraitUIImageHooks, _UIImageWithNameAndTraitCollection = UIImageWithNameAndTraitCollection);
}
