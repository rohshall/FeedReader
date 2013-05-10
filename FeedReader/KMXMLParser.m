//
//  KMXMLParser.m
//  KMXMLClass
//
//  Created by Kieran McGrady http://www.kieranmcgrady.com
//  Twitter: http://twitter.com/kmcgrady
//
//
//  The MIT License
//
//  Copyright Kieran McGrady(c)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of 
//  this software and associated documentation files (the "Software"), to deal in 
//  the Software without restriction, including without limitation the rights to use, 
//  copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the 
//  Software, and to permit persons to whom the Software is furnished to do so, subject 
//  to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all 
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS 
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS 
//  OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF 
//  OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#import "KMXMLParser.h"


@implementation KMXMLParser {
	NSXMLParser *parser;
    // temporary storage for a post and an element value
	NSMutableDictionary *post;
    NSMutableString *elementValue;
}
@synthesize delegate;


- (id)initWithURL:(NSString *)url delegate:(id)theDelegate;
{
    self.delegate = theDelegate;
	NSURL *xmlURL = [NSURL URLWithString:url];
	[self beginParsing:xmlURL];
    
    return self;
}

-(void)beginParsing:(NSURL *)xmlURL
{
	_posts = [[NSMutableArray alloc] init];
	parser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
	[parser setDelegate:self];
	
	[parser setShouldProcessNamespaces:NO];
	[parser setShouldReportNamespacePrefixes:NO];
	[parser setShouldResolveExternalEntities:NO];
	
    post = [[NSMutableDictionary alloc] init];
	[parser parse];
}


#pragma mark NSXMLParser Delegate Methods
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    [self.delegate parserDidBegin];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self.delegate parserCompletedSuccessfully];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    [self.delegate parserDidFailWithError:parseError];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    // And could be, a start of a new post
	if ([elementName isEqualToString:@"item"])
	{
		post = [[NSMutableDictionary alloc] init];
	}
    else
    {
        elementValue = [[NSMutableString alloc] init];
        // cheat a little here and add value of - thumbnail
        if ([elementName isEqualToString:@"media:thumbnail"])
        {
            NSString *thumbnailUrl = (NSString *)[attributeDict objectForKey:@"url"];
            [post setObject:thumbnailUrl forKey:@"thumbnail"];
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
	if ([elementName isEqualToString:@"item"]) 
	{
		[_posts addObject:post];
	}
    else
    {
        [post setObject:[elementValue copy] forKey:[elementName copy]];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [elementValue appendString:string];
}


@end
