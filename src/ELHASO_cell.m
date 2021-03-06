#import "ELHASO_cell.h"

#import "ELHASO.h"


/// Small subclass to handle custom drawing of cells.
@interface ELHASO_cell_view : UIView
@property (nonatomic, assign) ELHASO_cell *parent;
@end

@implementation ELHASO_cell_view

- (void)drawRect:(CGRect)rect
{
	LASSERT(_parent, @"No parent?");
	LASSERT([_parent respondsToSelector:@selector(draw_content:)],
		@"The parent has to implement the draw_content: selector");
	[_parent draw_content:rect];
}

@end


@implementation ELHASO_cell

@synthesize fast_view = fast_view_;

- (id)initWithIdentifier:(NSString *)identifier
{
	LASSERT(NO, @"This constructor is deprecated, don't use it!");
	[self doesNotRecognizeSelector:_cmd];
	[self release];
	return nil;
}

/** Default constructor.
 * Creates the fast_view_ and adds it to the view.
 */
- (id)initWithStyle:(UITableViewCellStyle)style
	reuseIdentifier:(NSString *)reuseIdentifier
{
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		fast_view_ = [[ELHASO_cell_view alloc]
			initWithFrame:self.contentView.bounds];
		fast_view_.parent = self;
		fast_view_.opaque = YES;
		fast_view_.autoresizingMask = FLEXIBLE_SIZE;
		fast_view_.autoresizesSubviews = YES;
		fast_view_.contentMode = UIViewContentModeRedraw;
		[self addSubview:fast_view_];
	}
	return self;
}

- (void)dealloc
{
	[fast_view_ release];
	[super dealloc];
}

/** Changes the selection mode.
 * This highlights the cell and forces a refresh.
 */
- (void)setSelected:(BOOL)selected
{
	[super setSelected:selected];
	[self setNeedsDisplay];
}

/** Special handler method because of drawContentView and inheritance.
 * Forces a refresh of our custom view.
 */
- (void)setNeedsDisplay
{
	[super setNeedsDisplay];
	[fast_view_ setNeedsDisplay];
}

/** Method to draw the content of the cell.
 * You have to subclass it and implement it without calling super.
 */
- (void)draw_content:(CGRect)cell_rect
{
	[self doesNotRecognizeSelector:_cmd];
}

@end
