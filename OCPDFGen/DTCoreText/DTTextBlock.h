//
//  DTTextBlock.h
//  DTCoreText
//
//  Created by Oliver Drobnik on 04.03.12.
//  Copyright (c) 2012 Drobnik.com. All rights reserved.
//

#import "DTCoreText.h"

/**
 Class that represents a block of text with attributes like padding or a background color.
 */
@interface DTTextBlock : NSObject

/**
 The space to be applied between the layouted text and the edges of the receiver
 */
@property (nonatomic, assign) DTEdgeInsets padding;


/**
 The background color to paint behind the text in the receiver
 */
@property (nonatomic, strong) DTColor *backgroundColor;


@end
