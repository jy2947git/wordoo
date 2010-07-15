/*
 *  GlobalHeader.h
 *  WizardView
 *
 *  Created by Junqiang You on 6/9/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#ifndef serverHost
#ifdef DEBUG
#define serverHost @"wordee-app.appspot.com" /*localhost:8084*/
#else
#define serverHost @"wordee-app.appspot.com"
#endif
#endif

#ifndef requestToken
#define requestToken @"2983032043nksfd0-1fda-1hf"
#endif

#ifndef FREE_APP
#define FREE_APP 0
#endif

#ifndef STANDARD_APP
#define STANDARD_APP 5
#endif

#ifndef appRelease
#define appRelease STANDARD_APP
#endif

#ifndef wordooProtocal
#define wordooProtocal @"wordoo"
#endif

#ifndef kMyFeatureIdentifier
#define kMyFeatureIdentifier @"wordoo-unlock"
#endif