//
//  constant.h
//  ListenTheWorld
//
//  Created by 魔曦 on 2017/9/12.
//  Copyright © 2017年 魔曦. All rights reserved.
//

#ifndef constant_h
#define constant_h

#define   kHomeUrl    @"http://iapi.ipadown.com/api/gushi/page.list.api.php?cid=53&p=%ld"

//#define   kHomeUrl    @"http://iapi.ipadown.com/api/gushi/page.list.api.php?cid=53&p=%ld&uri=http%3A%2F%2Fiapi.ipadown.com%2Fapi%2Fgushi%2Fpage.list.api.php%3Fcid%3D53"

#define kHomeDetailUrl @"http://iapi.ipadown.com/api/gushi/detail.show.api.php?1=1&id=%ld"

#define kRankUrl     @"http://iapi.ipadown.com/api/gushi/page.list.api.php?cid=53&orderby=views&pagesize=50&subday=%ld"

#define kHotTypeUrl  @"http://iapi.ipadown.com/api/gushi/tags.api.php?c=%E7%88%B1%E6%83%85"

#define kSearchKeyWord @"http://iapi.ipadown.com/api/gushi/page.list.api.php?cid=53&keywords=%@&p=1"

//#define kSearchKeyWord @"http://iapi.ipadown.com/api/gushi/page.list.api.php?cid=53&keywords=%s&p=1&uri=http%3A%2F%2Fiapi.ipadown.com%2Fapi%2Fgushi%2Fpage.list.api.php%3Fcid%3D53%26keywords%3Dqing"
#define kAboutUrl   @"http://iapi.ipadown.com/api/i/aboutus.php?channel=gushi&version=1.0&appname=%E7%88%B1%E6%83%85%E6%95%A3%E6%96%87"

#endif /* constant_h */
