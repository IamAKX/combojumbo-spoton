// This class contains dummy data.
// To be deleted before pushing the app to prod

import 'package:cjspoton/model/add_slider_model.dart';
import 'package:cjspoton/model/cj_route_option_model.dart';
import 'package:cjspoton/model/review_model.dart';
import 'package:cjspoton/screen/comming_soon/comming_soon_screen.dart';
import 'package:cjspoton/screen/e_dining/e_dining_table_booking_screen/e_dinig_table_booking_screen.dart';
import 'package:cjspoton/screen/menu/menu_screen.dart';
import 'package:cjspoton/screen/table_booking/table_booking_screen/table_booking_screen.dart';
import 'package:cjspoton/screen/take_away/take_away_menu/take_away_menu_screen.dart';
import 'package:cjspoton/utils/api.dart';
import 'package:cjspoton/widgets/webview_internal.dart';
import 'package:flutter/material.dart';

List<AddSliderCardModel> getAdSlider() {
  return [
    AddSliderCardModel(
        text1: 'Get a Free',
        text2: 'Coke!',
        text3: 'On Every CJ SpotOn Order',
        imageLink: 'assets/images/coke.png',
        redirection: MenuScreen.MENU_SCREEN_ROUTE,
        color: Colors.lightBlueAccent,
        arguments: '0'),
    AddSliderCardModel(
        text1: 'The Party',
        text2: 'Snackbox',
        text3: 'For All the merry times!',
        imageLink: 'assets/images/pizzapockets.png',
        redirection: WebviewInternal.WEBVIEW_ROUTE,
        color: Colors.lightGreen,
        arguments: API.MUNCHBOX),
    AddSliderCardModel(
        text1: 'Combo Meals',
        text2: 'Jumbo Deals',
        text3: 'The max quantity in the min budget.',
        imageLink: 'assets/images/jumboqty.png',
        redirection: MenuScreen.MENU_SCREEN_ROUTE,
        color: Colors.orangeAccent,
        arguments: '0'),
    AddSliderCardModel(
        text1: 'Only at',
        text2: 'CJ Spoton',
        text3: 'The Best Jain in Town',
        imageLink: 'assets/images/jain.png',
        redirection: CommingSoonScreen.COMMING_SOON_ROUTE,
        color: Colors.redAccent,
        arguments: '0'),
    AddSliderCardModel(
        text1: 'Your Lunch',
        text2: 'and Dinner',
        text3: 'Is now Sorted Only on CJ Spot On',
        imageLink: 'assets/images/hotcase.png',
        redirection: WebviewInternal.WEBVIEW_ROUTE,
        color: Colors.indigoAccent,
        arguments: API.HOTCASE),
    AddSliderCardModel(
        text1: 'The Ultimate',
        text2: 'Combos',
        text3: 'Across Cuisines only on CJ Spot On',
        imageLink: 'assets/images/exclusivecombos.png',
        redirection: MenuScreen.MENU_SCREEN_ROUTE,
        color: Colors.tealAccent,
        arguments: '38'),
  ];
}

List<ReviewModel> getReview() {
  return [
    ReviewModel(
        title: 'Tasty & Pocket friendly',
        review:
            '''Amazing North Indian food served with Crisp Indian Breads They have a wide variety of Continental Food also. Will suggest my friends and is pocket friendly also''',
        name: 'Dipak Kumar'),
    ReviewModel(
        title: 'Great Service & Ambience.',
        review:
            '''The service is good. The ambience is unmatched . The staff cares about your experience especially mr. sameer The food is amazing - everything we tasted melted in our mouth. Great experience especially in navi mumbai.....''',
        name: 'Mohinderpal Singh'),
    ReviewModel(
        title: 'A worthy Joint to visit repeatedly!!',
        review:
            '''Very Nice Food, Unique Ambience, excellent staff. The price points are less as compared to other establishments in the area. The staff was very accommodative and attentive to ensure good experience. A lot of different cuisines are available with good quality food. Oriental sizzlers, Manchow soup and Lazeez Dum Birayni were sumptuous. The place is also available as a Banquet too.''',
        name: 'Yashraj Thakkar'),
    ReviewModel(
        title: 'A worthy Joint to visit repeatedly!!',
        review: '''Amazing place and it has a wide option in their menu
Loved the service and food
Will definetely visit again''',
        name: 'Paresh Doshi'),
  ];
}

List<CJRouteOptionModel> getCJRouteOptions() {
  return [
    CJRouteOptionModel(
        name: 'Book Table',
        image: 'https://www.combojumbo.in/img/mini-banquet.png',
        redirectionUrl: TableBookingScreen.TABLE_BOOKING_SCREEN_ROUTE),
    CJRouteOptionModel(
        name: 'E-Dining',
        image: 'https://www.combojumbo.in/img/tbl-booking.png',
        redirectionUrl: EdiningTableBookingScreen.TABLE_BOOKING_SCREEN_ROUTE),
    CJRouteOptionModel(
        name: 'Delivery',
        image: 'https://www.combojumbo.in/img/delivery.png',
        redirectionUrl: MenuScreen.MENU_SCREEN_ROUTE),
    CJRouteOptionModel(
        name: 'Take Away',
        image: 'https://www.combojumbo.in/img/Take%20away.png',
        redirectionUrl: TakeAwayMenuScreen.TAKE_AWAY_MENU_SCREEN_ROUTE),
    CJRouteOptionModel(
        name: 'Mini Banquet',
        image: 'https://www.combojumbo.in/img/e-dining.png',
        redirectionUrl: WebviewInternal.WEBVIEW_ROUTE),
    CJRouteOptionModel(
        name: 'Party Packs',
        image: 'https://www.combojumbo.in/img/party-packs.png',
        redirectionUrl: WebviewInternal.WEBVIEW_ROUTE),
  ];
}

String TERMS_OF_USE = '''
                            <div class="box_about">
                                <p class="lead" style="margin-bottom:15px;     font-weight: 500;">
                                    Applicability    
                                </p>
                                
                                <ol>
                                    <li style="margin: 4px 0px;">
                                        The General Terms and Conditions below apply to all offers and transactions of Combo Jumbo. Prices are subject to change.
                                    </li>
                                    <li style="margin: 4px 0px;">
                                        By accepting an offer or making an order, the consumer expressly accepts the applicability of these General Terms and Conditions.
                                    </li>
                                    <li style="margin: 4px 0px;">
                                        Deviations from that stipulated in these Terms and Conditions are only valid when they are confirmed in writing by the management.
                                    </li>
                                    <li style="margin: 4px 0px;">
                                        All rights and entitlements stipulated for Combo Jumbo in these General Terms and Conditions and any further agreements will also apply for intermediaries and other third parties deployed by Combo Jumbo.
                                    </li>
                                </ol>
                                
                                <p class="lead" style="margin-bottom:15px;     font-weight: 500;">
                                    Quality    
                                </p>
                                
                                <p style="margin-bottom:5px; text-align:justify;">
                                    The restaurant assures that all the products offered, meet the standards of the concept.
                                    If there are any complaints, the server needs to be informed immediately. Appropriate actions will be taken as soon as possible.
                                </p>
                                
                                <p class="lead" style="margin-bottom:15px;     font-weight: 500;">
                                    Prices/offers
                                </p>
                                
                                <ol>
                                    <li style="margin: 4px 0px;">
                                        All offers made by Combo Jumbo are without obligation and Combo Jumbo expressly reserves the right to change the prices, in particular, if this is necessary as a result of statutory or other regulations.
                                    </li>
                                    <li style="margin: 4px 0px;">
                                        All prices are indicated in rupees.
                                    </li>
                                    <li style="margin: 4px 0px;">
                                        In certain cases, promotional prices apply. These prices are valid only during a specific period as long as stocks last. No entitlement to these prices may be invoked before or after the specific period.
                                    </li>
                                    <li style="margin: 4px 0px;">
                                        Combo Jumbo cannot be held to any incorrect price indications, for example as a result of obvious typesetting or printing errors. No rights may be derived from incorrect price information.
                                    </li>
                                </ol>
                                
                                <p class="lead" style="margin-bottom:15px;     font-weight: 500;">
                                    Cancellations
                                </p>
                                
                                <ol>
                                    <li style="margin: 4px 0px;">
                                        Combo Jumbo is entitled to cancel or change the date of an event. Should this happen, Combo Jumbo will attempt to provide a suitable solution. If an event is canceled or postponed, Combo Jumbo will do its utmost to inform you as soon as possible. However, Combo Jumbo cannot guarantee it is possible to inform you timely of any change or cancellation of an event or be held responsible for refunds, compensations, or for any resulting costs you may incur, for example for travel, accommodation, and/or any other related goods or service.
                                    </li>
                                    <li style="margin: 4px 0px;">
                                        Before confirming your reservation, always check carefully that you have reserved the correct (number of) persons. Wrongfully reserved orders are not refundable.
                                    </li>
                                    <li style="margin: 4px 0px;">
                                        All purchases are final. Any food bought here cannot be returned for any refunds whatsoever; group bookings paid for on the website likewise cannot be canceled by the purchaser and refunds claimed for any reason whatsoever.
                                    </li>
                                </ol>
                                
                                <p class="lead" style="margin-bottom:15px;     font-weight: 500;">
                                    Payments
                                </p>
                                
                                <ol>
                                    <li style="margin: 4px 0px;">
                                        Methods of payment we accept: Cash, Credit card, Debit Card and UPI
                                    </li>
                                    <li style="margin: 4px 0px;">
                                        You will not receive confirmation of your definitive booking until your payment has been approved.
                                    </li>
                                </ol>
                                
                                <p class="lead" style="margin-bottom:15px;     font-weight: 500;">
                                    Other provisions
                                </p>
                                
                                <ol>
                                    <li style="margin: 4px 0px;">
                                        If one or more of the provisions in these Terms and Conditions or any other agreement with Combo Jumbo are in conflict with any applicable legal regulation, 
                                        the provision in question will lapse and be replaced by a new comparable stipulation admissible by law to be determined by Combo Jumbo.
                                    </li>
                                </ol>
                                
                                <p style="margin-bottom: 10px; text-align:justify;">
                                    If you have any questions, feedback or complaints, you can write to us at 
                                    <a href="mailto:info@combojumbo.in">info@combojumbo.in</a>
                                </p>
                                
                                <p style="margin-bottom: 10px; text-align:justify;">
                                    Address:
                                    Plot No: 17, near HDFC Bank, Juhu Nagar, Sector 28, Vashi, Navi Mumbai, Maharashtra 400703
                                </p>
                                
                            </div>''';

String PRIVACY_POLICY = ''' <div class="box_about">
                                <!--<p class="lead" style="margin-bottom:7px; font-weight: 500;">-->
                                <!--    Privacy Policy    -->
                                <!--</p>-->
                                
                                <p class="lead" style="margin-bottom:10px; font-weight: 500;">
                                    Welcome to Combo Jumbo!  
                                </p>
                                
                                <ol>
                                    <li style="margin: 4px 0px;">
                                        This privacy policy outlines the rules and regulations for the use of Combo Jumbo's Website, located at www.combojumbo.in.
                                    </li>
                                    <li style="margin: 4px 0px;">
                                        By accessing this website you accept these terms and conditions. Do not continue to use this web-site if you do not agree to take all of the terms and conditions stated on this page.
                                    </li>
                                    <li style="margin: 4px 0px;">
                                        The following terminology applies to these Terms and Conditions, Privacy Statement and Disclaim-er Notice and all Agreements: "Client", "You" and "Your" refers to you, the person log on this web-site and compliant to the Company’s terms and conditions. "The Company", "Ourselves", "We", "Our" and "Us", refers to our Company. "Party", "Parties", or "Us", refers to both the Client and ourselves. All terms refer to the offer, acceptance and consideration of payment necessary to under-take the process of our assistance to the Client in the most appropriate manner for the express pur-pose of meeting the Client’s needs in respect of provision of the Company’s stated services, in ac-cordance with and subject to, prevailing law of India. Any use of the above terminology or other words in the singular, plural, capitalization and/or he/she or they, are taken as interchangeable and therefore as referring to same.
                                    </li>
                                    <!--<li style="margin: 4px 0px;">-->
                                    <!--    All rights and entitlements stipulated for Combo Jumbo in these General Terms and Conditions and any further agreements will also apply for intermediaries and other third parties deployed by Combo Jumbo.-->
                                    <!--</li>-->
                                </ol>
                                
                                <p class="lead" style="margin-bottom:15px;     font-weight: 500;">
                                    Cookies    
                                </p>
                                
                                <p style="margin-bottom:5px; text-align:justify;">
                                    We employ the use of cookies. By accessing this website, you agreed to use cookies in agreement with the Combo Jumbo's Privacy Policy.
                                </p>
                                
                                <p style="margin-bottom:5px; text-align:justify;">
                                    Cookies are used by our website to enable the functionality of certain areas to make it easier for people visiting our website. Some of our affiliate/advertising partners may also use cookies.
                                </p>
                                
                                <p class="lead" style="margin-bottom:15px;     font-weight: 500;">
                                    License
                                </p>
                                
                                <p style="margin-bottom: 6px; text-align:justify;">
                                    Unless otherwise stated, Combo Jumbo and/or its licensors own the intellectual property rights for all material on this website. All intellectual property rights are reserved. You may access this from this website for your own personal use subjected to restrictions set in these terms and conditions.
                                </p>
                                
                                <p style="margin-bottom: 10px; text-align:justify;">
                                    You must not:
                                </p>
                                
                                <ul>
                                    <li style="margin: 4px 0px;">
                                        Republish material from this website
                                    </li>
                                    <li style="margin: 4px 0px;">
                                        Sell, rent or sub-license material from this website
                                    </li>
                                    <li style="margin: 4px 0px;">
                                        Reproduce, duplicate or copy material from this website
                                    </li>
                                    <li style="margin: 4px 0px;">
                                        Redistribute content from this website
                                    </li>
                                </ul>
                                
                                <p style="margin-bottom:5px; text-align:justify;">
                                    Parts of this website offer an opportunity for users to post and exchange opinions and information in certain areas of the website.. Comments do not reflect the views and opinions of Combo Jumbo, its agents and/or affiliates. Comments reflect the views and opinions of the person who post their views and opinions. To the extent permitted by applicable laws, Combo Jumbo shall not be liable for the Comments or for any liability, damages or expenses caused and/or suffered as a result of any use of and/or posting of and/or appearance of the Comments on this website.
                                </p>
                                
                                <p style="margin-bottom:5px; text-align:justify;">
                                    Combo Jumbo reserves the right to monitor all Comments and to remove any Comments which can be considered inappropriate, offensive or causes breach of these Terms and Conditions.
                                </p>
                                
                                <p style="margin-bottom: 10px; text-align:justify;">
                                    You warrant and represent that:
                                </p>
                                
                                <ul>
                                    <li style="margin: 4px 0px;">
                                        You are entitled to post the Comments on our website and have all necessary licenses and consents to do so.
                                    </li>
                                    <li style="margin: 4px 0px;">
                                        The Comments do not invade any intellectual property right, including without limitation copyright, patent or trademark of any third party.
                                    </li>
                                    <li style="margin: 4px 0px;">
                                        The Comments do not contain any defamatory, libellous, offensive, indecent or otherwise unlawful material which is an invasion of privacy.
                                    </li>
                                    <li style="margin: 4px 0px;">
                                        The Comments will not be used to solicit or promote business or custom or present commer-cial activities or unlawful activity.
                                    </li>
                                </ul>
                                
                                <p style="margin-bottom: 10px; text-align:justify;">
                                    You hereby grant Combo Jumbo a non-exclusive license to use, reproduce, edit and authorise others to use, reproduce and edit any of your Comments in any and all forms, formats or media.
                                </p>
                                
                                <p style="margin-bottom: 10px; text-align:justify;">
                                    Hyperlinking to our Content
                                </p>
                                
                                <p style="margin-bottom: 10px; text-align:justify;">
                                    The following organizations may link to our Website without prior written approval:
                                </p>
                                
                                <ul>
                                    <li style="margin: 4px 0px;">
                                        Government agencies.
                                    </li>
                                    <li style="margin: 4px 0px;">
                                        Search engines.
                                    </li>
                                    <li style="margin: 4px 0px;">
                                        News organizations.
                                    </li>
                                    <li style="margin: 4px 0px;">
                                        Online directory distributors may link to our Website in the same manner as they hyperlink to the Websites of other listed businesses; and
                                    </li>
                                    <li style="margin: 4px 0px;">
                                        System wide Accredited Businesses except soliciting non-profit organizations, charity shop-ping malls, and charity fundraising groups which may not hyperlink to our Web site.
                                    </li>
                                </ul>
                                
                                <p style="margin-bottom: 10px; text-align:justify;">
                                    These organizations may link to our home page, to publications or to other Website information so long as the link: (a) is not in any way deceptive; (b) does not falsely imply sponsorship, endorsement or approval of the linking party and its products and/or services; and (c) fits within the context of the linking party’s site.
                                </p>
                                
                                <p style="margin-bottom: 10px; text-align:justify;">
                                    No use of Combo Jumbo's logo or other artwork will be allowed for linking absent a trademark li-cense agreement.
                                </p>
                                
                                <p class="lead" style="margin-bottom:15px;     font-weight: 500;">
                                    IFrames
                                </p>
                                
                                <p style="margin-bottom: 10px; text-align:justify;">
                                    Without prior approval and written permission, you may not create frames around our Webpages that alter in any way the visual presentation or appearance of our Website.
                                </p>
                                
                                <p class="lead" style="margin-bottom:15px;     font-weight: 500;">
                                    Reservation of Rights
                                </p>
                                
                                <p style="margin-bottom: 10px; text-align:justify;">
                                    We reserve the right to request that you remove all links or any particular link to our Website. You approve to immediately remove all links to our Website upon request. We also reserve the right to amen these terms and conditions and it’s linking policy at any time. By continuously linking to our Website, you agree to be bound to and follow these linking terms and conditions.
                                </p>
                                
                                <p class="lead" style="margin-bottom:15px;     font-weight: 500;">
                                    Removal of links from our website
                                </p>
                                
                                <p style="margin-bottom: 10px; text-align:justify;">
                                    If you find any link on our Website that is offensive for any reason, you are free to contact and in-form us any moment. We will consider requests to remove links but we are not obligated to or so or to respond to you directly.
                                </p>
                                
                                <p style="margin-bottom: 10px; text-align:justify;">
                                    We do not ensure that the information on this website is correct, we do not warrant its completeness or accuracy; nor do we promise to ensure that the website remains available or that the material on the website is kept up to date.
                                </p>
                                
                                <p class="lead" style="margin-bottom:15px;     font-weight: 500;">
                                    Disclaimer
                                </p>
                                
                                <p style="margin-bottom: 10px; text-align:justify;">
                                    To the maximum extent permitted by applicable law, we exclude all representations, warranties and conditions relating to our website and the use of this website. Nothing in this disclaimer will:
                                </p>
                                
                                <ul>
                                    <li style="margin: 4px 0px;">
                                        limit or exclude our or your liability for death or personal injury;
                                    </li>
                                    <li style="margin: 4px 0px;">
                                        limit or exclude our or your liability for fraud or fraudulent misrepresentation;
                                    </li>
                                    <li style="margin: 4px 0px;">
                                        limit any of our or your liabilities in any way that is not permitted under applicable law; or
                                    </li>
                                    <li style="margin: 4px 0px;">
                                        exclude any of our or your liabilities that may not be excluded under applicable law.
                                    </li>
                                </ul>
                                
                                <p style="margin-bottom: 10px; text-align:justify;">
                                    The limitations and prohibitions of liability set in this Section and elsewhere in this disclaimer: (a) are subject to the preceding paragraph; and (b) govern all liabilities arising under the disclaimer, in-cluding liabilities arising in contract, in tort and for breach of statutory duty.
                                </p>
                                
                                <p style="margin-bottom: 10px; text-align:justify;">
                                    Combo Jumbo is not liable for any loss or damage of any nature.
                                </p>
                                
                                <p style="margin-bottom: 10px; text-align:justify;">
                                    If you have any questions, feedback or complaints, you can write to us at 
                                    <a href="mailto:info@combojumbo.in">info@combojumbo.in</a>
                                </p>
                                
                                <p style="margin-bottom: 10px; text-align:justify;">
                                    Address:
                                    Plot No: 17, near HDFC Bank, Juhu Nagar, Sector 28, Vashi, Navi Mumbai, Maharashtra 400703
                                </p>
                                
                            </div>''';
