#import <Foundation/Foundation.h>
#import "HTCRootListController.h"

@implementation HTCRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

@end
