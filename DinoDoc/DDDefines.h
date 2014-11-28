//
//  DDDefines.h
//  DinoDoc
//
//  Created by Swapnil Takalkar on 2/9/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//

#ifndef DinoDoc_DDDefines_h
#define DinoDoc_DDDefines_h

#define WRONGANS    0               // alert tag for wrong answer UIAlert
#define RIGHTANS    100             // alert tag for right answer UIAlert
#define TIMESUP     200             // alert tag for Time's up UIAlert
#define DONEQUIZ    300             // alert tag for Quiz completed UIAlert
#define QUITQUIZ    400             // alert tag for Quiz quit UIAlert
#define IAPSETTING  50              // alert tag for In-App purchases settings
#define IAPTRANS    150             // alert tag for In-App purchases transaction error
#define REMOVEAD    500             // alert tag for Remove Ads
#define REMOVEADTAG 6               // seq on which removead IAP flows
#define NOADS       600             // alert tag when ads removed already
#define OPTCT       4               // Number of Answer options
#define BENCHMARKFACTOR 0.7         // The multiplier for score benchmarking
#define BADGEFACTOR 0.80            // The multiplier for score benchmarking
#define SPEEDMASTERFACTOR 2.0       // Quickest time to answer a question
#define QUIZMASTERFACTOR 15         // Number of quiz played more than 15
#define QUIZDOCFACTOR 9             // Number of max badges - 1
#define MAINPARAM   @"MainParam"    // Name of main parameter file
#define BADGES      @"badges"       // Name of badges plist file
#define HOMEICON    @"home.png"     // Name of Home icon
#define SETGICON    @"settings.png" // Name of settings icon
#define INFOICON    @"info.png"     // Name of Info icon
#define SETOPTCT    6               // Count of setting options for TableVC
#define BADGEHEIGHT 110             // Height of Badge icon
#define BADGEWIDTH  110             // Width of Badge icon

#define CONTACTEMAIL    @"contact@09apps.com"                               //Contact email id
#define EMAILSUB        @"DinoDOC iOS"                                      //Email subject
#define FBURL           @"fb://profile/285876748286203"                     //Facebook URL
#define TWITTERURL      @"https://twitter.com/09apps"                       //Twitter URL
#define APPID           @"881531237"                                        //App id for appstore
#define ADUNITID        @"ca-app-pub-1165626743430331/1272847601"           //Admob ad unit id
#define REMOVEADPRODID  @"com.09apps.dinodoc.withoutads"                     //Product id for in app purchase of remove ad
#define POLICYURL       @"http://dinodocapp.wordpress.com/privacy-policy/"  //webpage for the privacy policy
#define CONTRIURL       @"http://dinodocapp.wordpress.com/credits/"         //webpage with list of contributors
#define FAQURL          @"http://dinodocapp.wordpress.com/faq/"             //FAQ webpage

#define HIGHTITLE       @"Cretaceous"                               //Highest level title
#define MEDTITLE        @"Jurassic"                                 //Medium level title
#define LOWTITLE        @"Triassic"                                 //Low level title
#define NOTITLE         @"Permian"                                  //Beginner level title

#endif
