#import "UIImage+ELHASO.h"

#import "ELHASO.h"
//#import "settings.h"

@implementation UIImage (ELHASO)

/** Like calling UIImage::scale_to:proportional: with YES
 */
- (UIImage*)scale_to:(CGSize)size
{
	return [self scale_to:size proportional:YES];
}

/** Scales an image to the requested size if necessary.
 * If you want the scaling to be proportional, pass YES as the parameter,
 * otherwise the image will fill the target size. With proportional scaling the
 * background of the image will be transparent.
 *
 * \return Returns an autoreleased version of the image scaled to the specified
 * size. Might return self if no scaling is needed.
 */
- (UIImage*)scale_to:(CGSize)size proportional:(BOOL)proportional
{
	if (size.width < 1 || size.height < 1) {
		DLOG(@"Can't scale image to %0.1fx%0.1f", size.width, size.height);
		return self;
	}

	if (size.width == self.size.width && size.height == self.size.height)
		return self;

	CGRect rect = { 0, 0, 0, 0 };
	rect.size = size;
#ifdef PERFORMANCE_WARNINGS
	DLOG(@"Performance warning, scaling image %dx%d to %dx%d",
		(int)self.size.width, (int)self.size.height,
		(int)size.width, (int)size.height);
#endif

	LASSERT(rect.size.width > 0, @"Scaling image to width less than 1");
	LASSERT(rect.size.height > 0, @"Scaling image to height less than 1");
	if (rect.size.width > 1024 || rect.size.height > 1024) {
		DLOG(@"WARNING: Image scaled to %0.0fx%0.0f, iphone 3g is fried!",
			rect.size.width, rect.size.height);
	}

	UIGraphicsBeginImageContextWithOptions(size, NO, 0);

	CGContextRef c = UIGraphicsGetCurrentContext();
	CGContextClearRect(c, rect);
	if (proportional) {
		const CGFloat max_w = rect.size.width;
		const CGFloat max_h = rect.size.height;
		CGFloat w = self.size.width;
		CGFloat h = self.size.height;
		CGFloat factor = max_w / w;
		w *= factor;
		h *= factor;

		if (h > max_h) {
			factor = max_h / h;
			w *= factor;
			h *= factor;
		}

		rect.origin.x = (max_w - w) / 2.0f;
		rect.origin.y = (max_h - h) / 2.0f;
		rect.size.width = w;
		rect.size.height = h;
		[self drawInRect:rect];
	} else {
		[self drawInRect:rect];
	}

	// Do we have to slash scaled images?
/*
	if (gSlash_scaled_images) {
		CGContextSetLineWidth(c, 3);
		[[UIColor whiteColor] set];
		CGContextMoveToPoint(c, 0, 0);
		CGContextAddLineToPoint(c, rect.size.width - 1, rect.size.height - 1);
		CGContextStrokePath(c);
		CGContextSetLineWidth(c, 2);
		[[UIColor redColor] set];
		CGContextMoveToPoint(c, 0, 0);
		CGContextAddLineToPoint(c, rect.size.width - 1, rect.size.height - 1);
		CGContextStrokePath(c);
	}
*/

	UIImage *scaled = UIGraphicsGetImageFromCurrentImageContext();
	LASSERT(scaled, @"Couldn't scale image?");
	UIGraphicsEndImageContext();
	if (scaled) {
		LASSERT(scaled.size.width == size.width, @"Bad code");
		LASSERT(scaled.size.height == size.height, @"Bad code");
	}

	return scaled;
}

/** Your typical drawInRect respecting scaling modes from UIView.contentMode.
 *
 * At the moment only the following are implemented:
 *
 * - UIViewContentModeScaleToFill
 * - UIViewContentModeScaleAspectFit
 * - UIViewContentModeScaleAspectFill
 *
 * Unimplemented modes will be drawn as UIViewContentModeScaleToFill.
 */
- (void)draw_in_rect:(CGRect)rect mode:(UIViewContentMode)mode
{
	switch (mode) {
		case UIViewContentModeScaleAspectFill: {
			CGContextRef context = UIGraphicsGetCurrentContext();
			CGContextSaveGState(context);
			CGContextClipToRect(context, rect);

			const CGFloat max_w = rect.size.width;
			const CGFloat max_h = rect.size.height;
			CGFloat w = self.size.width;
			CGFloat h = self.size.height;
			CGFloat factor = max_w / w;
			w *= factor;
			h *= factor;

			if (h < max_h) {
				factor = max_h / h;
				w *= factor;
				h *= factor;
			}
			NSAssert(w >= max_w - 0.1f, @"Didn't reach expected width?");
			NSAssert(h >= max_h - 0.1f, @"Didn't reach expected height?");

			rect.origin.x += (max_w - w) / 2.0f;
			rect.origin.y += (max_h - h) / 2.0f;
			rect.size.width = w;
			rect.size.height = h;
			[self drawInRect:rect];

			CGContextRestoreGState(context);
			break;
		}
		case UIViewContentModeScaleAspectFit: {
			const CGFloat max_w = rect.size.width;
			const CGFloat max_h = rect.size.height;
			CGFloat w = self.size.width;
			CGFloat h = self.size.height;
			CGFloat factor = max_w / w;
			w *= factor;
			h *= factor;

			if (h > max_h) {
				factor = max_h / h;
				w *= factor;
				h *= factor;
			}

			rect.origin.x += (max_w - w) / 2.0f;
			rect.origin.y += (max_h - h) / 2.0f;
			rect.size.width = w;
			rect.size.height = h;
			[self drawInRect:rect];
			break;
		}
		default:
		case UIViewContentModeScaleToFill:
			[self drawInRect:rect];
			break;
	}
}

@end

// vim:tabstop=4 shiftwidth=4 syntax=objc
