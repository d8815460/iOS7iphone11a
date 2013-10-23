//
//  SettingsViewController.m
//  iPhoneNutritionScaleForIOS7WithStoryBoard
//
//  Created by 駿逸 陳 on 13/9/26.
//  Copyright (c) 2013年 駿逸 陳. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingItem.h"
#import "BLEUIProtocol.h"
#import "MyLogInViewController.h"
#import "MBProgressHUD.h"
#import "settingGreenCell.h"


@interface SettingsViewController (){
    NSMutableData *_data;   //FB之照片資料
    BOOL firstLaunch;
}
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) NSTimer *autoFollowTimer;         //定時器追蹤朋友Follow
@end

@implementation SettingsViewController
@synthesize settingTableView;
@synthesize settingItemArray;
@synthesize aboutItem;
@synthesize selectedCell;
@synthesize versionLabel;
@synthesize FBiconview;
@synthesize hud;
@synthesize autoFollowTimer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - UIViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([PFUser currentUser]) {
        //已經登入過，facebook button就直接顯示藍色
        //        self.welcomeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Welcome %@!", nil), [[PFUser currentUser] username]];
        self.FBiconview.image = [UIImage imageNamed:@"fb_logout.png"];
    } else {
        //沒有登入過，facebook button顯示灰色
        //        self.welcomeLabel.text = NSLocalizedString(@"Not logged in", nil);
        self.FBiconview.image = [UIImage imageNamed:@"fb_login.png"];
    }
    [self.settingTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    self.settingTableView.delegate = self;
//    self.settingTableView.dataSource = self;
    //設定table背景色
    self.settingTableView.backgroundColor = [UIColor clearColor];
    self.settingTableView.separatorColor = [UIColor clearColor];
    
    aboutItem = [[NSArray alloc] initWithObjects:@"Facebook Page", nil];
    settingItemArray = [[NSMutableArray alloc] init];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	// add into Bluetooth Listener list
    [appDelegate addBLEListener:self];
    
	[appDelegate scanPeripheral:5];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) reloadPeripheralData
{
    NSMutableArray * peripheralArray = [appDelegate getCurrentPeripherals];
    [settingItemArray removeAllObjects];
    
	for(int i=0;i<[peripheralArray count];i++){
        SettingItem *s=[SettingItem alloc];
		CBPeripheral *p = [peripheralArray objectAtIndex:i];
        // NSLog(@"load peripheral name=%@ UUID=%@",p.name,[OmniTool UUIDtoString:[p UUID]]);
		s.isChecked=(p.state==CBPeripheralStateConnected) ? YES : NO;
		s.showSpinner=NO;
        s.itemDescription=p.name;
        [settingItemArray addObject:s];
	}
    if (peripheralArray.count == 0) {
        SettingItem *s=[SettingItem alloc];
        s.itemDescription=@"No scale in range.";
        [settingItemArray addObject:s];
    }
    [settingTableView reloadData];
}

/******************************** BLEUIProtocol ***********************************************/
-(void) BLEinitializing{	// called when the bluetooth manager is just initializing
    
	SettingItem *s=[SettingItem alloc];
	s.isChecked=NO;
	s.showSpinner=YES;
	s.itemDescription=@"Starting bluetooth manager";
	[settingItemArray addObject:s];
    
    [settingTableView reloadData];
}
-(void) BLEinitializeDone{	// called when the bluetooth manager has been initialized
	
	[self reloadPeripheralData];
	[appDelegate scanPeripheral:5];
}
-(void) BLEinitializeFailed	// called when the bluetooth manager initialization failed.
{
}
-(void) BLEScaning	// called when the bluetooth manager is scanning for peripherals
{
	[settingItemArray removeAllObjects];
    NSMutableArray * peripheralArray = [appDelegate getCurrentPeripherals];
    
    for(int i=0;i<[peripheralArray count];i++){
    	CBPeripheral *p = [peripheralArray objectAtIndex:i];
    	SettingItem *s=[SettingItem alloc];
		s.isChecked=(p.state==CBPeripheralStateConnected) ? YES : NO;
		s.showSpinner=NO;
		s.itemDescription=p.name;
    	[settingItemArray addObject:s];
    }
    
	SettingItem *s=[SettingItem alloc];
	s.isChecked=NO;
	s.showSpinner=YES;
	s.itemDescription=@"Scanning for Nutrition Food Scale";
	[settingItemArray addObject:s];
    [settingTableView reloadData];
}
-(void) BLEScanDone	// called when the bluetooth manager has done scanning peripherals
{
	[self reloadPeripheralData];
}

-(void) BLEStartConnect  // called when the bluetooth is connecting
{
}
-(void) weightUpdate  // called when the bluetooth is asking a new weight, to simulate the weigh change
{
}

-(void) BLEReady  // called when the bluetooth is connected and ready for service
{
	// reload the data
	[self reloadPeripheralData];
}
-(void) BLECancelConnection  // called when the bluetooth is canceled(disconnect)
{
}
-(void) BLELostConnect  // called when the bluetooth failed to connect after 5 times try
{
	[self reloadPeripheralData];
}
-(void) updateBattery:(int)batteryValue 	// update battery status
{
}
-(void) updateNetSign:(bool)showNetSign 	// update net sign
{
}
-(void) updateStable:(bool)weightStable  // update stable
{
}
-(void) updateConnectionStatus:(bool)bIsConnected 	// update connection status
{
}
-(NSString *) BLEListenerUniqueID 	// returns a uniqueID. different listener with same ID will be replaced. Used to avoid un-necessary listeners
{
	return @"2";
}
/******************************** BLEUIProtocol END ***********************************************/

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    // 總共四個綠色標題，但第三個第四個看不到。
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    // Usually the number of settingItemArray in your array (the one that holds your list)
    if(section==0){
	    return [settingItemArray count];
    }else if (section == 1) {
	    return 1;
	}else if (section == 2){
        return 1;
    }else if (section == 3){
        return 1;
    }
    return 0;
}

// description label
#define MAINLABEL_TAG 1
// activity indicator for connecting
#define INDICATOR_TAG 2
// checked sign for connected device
#define PHOTO_TAG 3

#define SubPHOTO_TAG 4

//設定table header、cell高度
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //第1、2個headerView 高度 = 44
    //第3、4個headerView 高度 = 0;
    if (section < 2) {
        return 44.0f;
    }
    return 0.0f;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
//設定 header、cell樣式
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.settingTableView.frame.size.width, 44)];
    headerView.backgroundColor = [UIColor colorWithRed:119.0f/255.0f green:196.0f/255.0f blue:148.0f/255.0f alpha:255.0f/255.0f];
    
    UILabel *TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 0, self.settingTableView.frame.size.width-20, 44)];
    [TitleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:19]];
	TitleLabel.textAlignment = NSTextAlignmentLeft;
	TitleLabel.backgroundColor = [UIColor clearColor];
	TitleLabel.textColor = [UIColor whiteColor];
    
    UIImageView *icon;
    icon = [[UIImageView alloc] initWithFrame:CGRectMake(13.0, 6.0, 30.0, 30.0)];
    if (section == 0) {
        TitleLabel.text = @"Select Scale";
        icon.image =  [UIImage imageNamed:@"scale.png"];
    }else if (section == 1){
        TitleLabel.text = @"Facebook Account Settings ";
        icon.image =  [UIImage imageNamed:@"fb_account-setting.png"];
    }else{
        TitleLabel.text = nil;
        icon.image = nil;
    }
    
	[headerView addSubview:TitleLabel];
    [headerView addSubview:icon];
    [headerView addSubview:self.versionLabel];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SettingsCellSettingsCell";
    
    UILabel *mainLabel;
    UIActivityIndicatorView *spinner;
    UIImageView *photo;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(25.0, 0.0,300.0, 44.0)];
        mainLabel.tag = MAINLABEL_TAG;
        [mainLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17.0]];
        mainLabel.textAlignment = NSTextAlignmentLeft;
        mainLabel.textColor = [UIColor blackColor];
        mainLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:mainLabel];
        
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.frame = CGRectMake(3, 11,22,22);
        spinner.tag = INDICATOR_TAG;
        spinner.hidesWhenStopped = YES;
        [cell.contentView addSubview:spinner];
        
        photo = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 10.0, 25.0, 25.0)];
        photo.tag = PHOTO_TAG;
        [cell.contentView addSubview:photo];
        
        self.FBiconview = [[UIImageView alloc] initWithFrame:CGRectMake(25.0, 9.0, 25.0, 25.0)];
        self.FBiconview.tag = SubPHOTO_TAG;
        //        self.FBiconview.image = [UIImage imageNamed:@"fb_login.png"];
        [cell.contentView addSubview:self.FBiconview];
        
    } else {
        mainLabel = (UILabel *)[cell.contentView viewWithTag:MAINLABEL_TAG];
        spinner = (UIActivityIndicatorView *)[cell.contentView viewWithTag:INDICATOR_TAG];
        photo = (UIImageView *)[cell.contentView viewWithTag:PHOTO_TAG];
        self.FBiconview = (UIImageView *)[cell.contentView viewWithTag:SubPHOTO_TAG];
    }
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"settingGreen" owner:self options:nil];
    //set cell properties
	NSInteger section=[indexPath section];
//    NSInteger row = [indexPath row];
    if(section==0){
        mainLabel.frame = CGRectMake(25.0, 0.0,300.0, 44.0);
        photo.frame = CGRectMake(5.0, 14.0, 13.0, 13.0);
	    // Configure the cell... setting the text of our cell's label
        // NSLog(@"setting item array %d= %@, size=%d", indexPath.row, [[settingItemArray objectAtIndex:indexPath.row] itemDescription],[settingItemArray count]);
	    SettingItem *s=(SettingItem *) [settingItemArray objectAtIndex:indexPath.row];
	    mainLabel.text = [s itemDescription];
        
        self.FBiconview.image = nil;
        
	    // spinner ON or OFF
	    if([s showSpinner]){
		    [spinner startAnimating];
	    }else{
		    [spinner stopAnimating];
	    }
	    if([s isChecked]){
		    photo.image =  [UIImage imageNamed:@"choose_blooth.png"];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selected = YES;
	    }else{
		    photo.image =  nil;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selected = NO;
	    }
        return cell;
    }else if (section == 1){
        mainLabel.frame = CGRectMake(50.0, 0.0, 257.0, 44.0);
        
        if ([PFUser currentUser]) {
            //已經登入過，facebook button就直接顯示藍色
            //        self.welcomeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Welcome %@!", nil), [[PFUser currentUser] username]];
            mainLabel.text = @"Log out from Facebook";
            self.FBiconview.image = [UIImage imageNamed:@"fb_logout.png"];
        } else {
            //沒有登入過，facebook button顯示灰色
            mainLabel.text = @"Log in to Facebook";
            self.FBiconview.image = [UIImage imageNamed:@"fb_login.png"];
        }
        return cell;
    }
    else if (section == 2){
        
        settingGreenCell *greenCell = [topLevelObjects objectAtIndex:0];
        greenCell.cellTitleLabel.text = @"Like us on Facebook";
        greenCell.cellIconImage.image = [UIImage imageNamed:@"likeus.png"];
        return greenCell;
    }else if (section == 3){
        settingGreenCell *greenCell = [topLevelObjects objectAtIndex:0];
        greenCell.cellTitleLabel.text = @"Proch Technology";
        greenCell.cellIconImage.image = [UIImage imageNamed:@"proch-technology.png"];
        return greenCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    // If you want to push another view upon tapping one of the cells on your table.
    
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    if(indexPath.section ==0){
    	SettingItem *si=(SettingItem *)[settingItemArray objectAtIndex:indexPath.row];
    	if(si){
			if(si.isChecked)
				return; // already connected
			if(si.showSpinner)
				return;	// not an legal UUID
			NSString *deviceName= si.itemDescription;
			if(!deviceName)	return;
			
			if(appDelegate.connectionState !=CONNECTION_STATE_CONNECTED &&
               appDelegate.connectionState !=CONNECTION_STATE_NOT_CONNECTED &&
               appDelegate.connectionState !=CONNECTION_STATE_BT_READY )
				return;	// only allow to connect during 3 stable states
			
			if(appDelegate){
				[appDelegate connectPeripheralWithName:deviceName ResetReconnectCounter:YES];
				// set current status as spinner
				si.showSpinner=YES;
			}
			[settingTableView reloadData];
    	}
    }
    if (indexPath.section == 1 && indexPath.row  == 0) { // Facebook
        [self facebookButtonLoginPressed:nil];
    }else if (indexPath.section == 2 && indexPath.row  == 0){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.facebook.com/pages/Omni-Kitchen-Scale/538187552870504"]];
    }else if (indexPath.section == 3 && indexPath.row == 0){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://proch.com.tw"]];
    }
}

- (IBAction)closeButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) facebookButtonLoginPressed:(id)sender{
    NSLog([PFUser currentUser] ? @"YES" : @"NO");
    // Check if user is logged in
    if ([PFUser currentUser]) {
        NSLog(@"已經登入過");
        [self logOutButtonTapAction:sender];
    }else{
        NSLog(@"尚未登入");
        // Customize the Log In View Controller
        MyLogInViewController *logInViewController = [[MyLogInViewController alloc] init];
        logInViewController.delegate = self;
        logInViewController.facebookPermissions = @[@"friends_about_me"];
        logInViewController.fields = PFLogInFieldsFacebook | PFLogInFieldsDismissButton;
        
        // Present Log In View Controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
    
    //    if (![PFUser currentUser]) {
    //        NSLog(@"尚未登入");
    //        [(AppDelegate *)[[UIApplication sharedApplication] delegate] presentLoginViewController];
    //        //facebook 按鈕變成藍色
    //        self.FBiconview.image = [UIImage imageNamed:@"fb_login.png"];
    //    }else{
    //
    //        [(AppDelegate *)[[UIApplication sharedApplication] delegate] logOut];
    //        //facebook 按鈕變成灰色
    //        self.FBiconview.image = [UIImage imageNamed:@"fb_logout.png"];
    //    }
}

- (IBAction):(id)sender {
}

#pragma mark - PFLogInViewControllerDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    if (username && password && username.length && password.length) {
        return YES;
    }
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    return NO;
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    if (user.isNew) {
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                [self facebookRequestDidLoad:result];
            } else {
                [self facebookRequestDidFailWithError:error];
            }
        }];
        
        // Subscribe to private push channel
        if (user) {
            NSString *privateChannelName = [NSString stringWithFormat:@"user_%@", [user objectId]];
            [user setObject:privateChannelName forKey:kPAPUserPrivateChannelKey];
        }
    }else if(user){
        
    }
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)logOutButtonTapAction:(id)sender{
    
    [PFUser logOut];
    
    NSLog(@"登出了, user = %@", [PFUser currentUser] ? @"YES" : @"NO");
    self.FBiconview.image = [UIImage imageNamed:@"fb_login.png"];
    
    [self.settingTableView reloadData];
}

#pragma mark - Facebook Request Delegate
- (void)facebookRequestDidLoad:(id)result {
    PFUser *user = [PFUser currentUser];
    
    NSArray *data = [result objectForKey:@"data"];
    
    if (data) {
        // we have friends data
        NSMutableArray *facebookIds = [[NSMutableArray alloc] initWithCapacity:[data count]];
        for (NSDictionary *friendData in data) {
            if (friendData[@"id"]) {
                [facebookIds addObject:friendData[@"id"]];
            }
        }
        
        // cache friend data
        [[PAPCache sharedCache] setFacebookFriends:facebookIds];
        
        if (user) {
            if (![user objectForKey:kPAPUserAlreadyAutoFollowedFacebookFriendsKey]) {
                self.hud.labelText = NSLocalizedString(@"Following Friends", nil);
                firstLaunch = YES;
                
                [user setObject:@YES forKey:kPAPUserAlreadyAutoFollowedFacebookFriendsKey];
//                NSError *error = nil;
                
                // find common Facebook friends already using Anypic
                PFQuery *facebookFriendsQuery = [PFUser query];
                [facebookFriendsQuery whereKey:kPAPUserFacebookIDKey containedIn:facebookIds];
                
                // auto-follow Parse employees
                //                PFQuery *autoFollowAccountsQuery = [PFUser query];
                //                [autoFollowAccountsQuery whereKey:kPAPUserFacebookIDKey containedIn:kPAPAutoFollowAccountFacebookIds];
                
                // combined query
                PFQuery *query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:facebookFriendsQuery, nil]];
                
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    NSArray *anypicFriends = objects;
                    
                    if (!error) {
                        [anypicFriends enumerateObjectsUsingBlock:^(PFUser *newFriend, NSUInteger idx, BOOL *stop) {
                            PFObject *joinActivity = [PFObject objectWithClassName:kPAPActivityClassKey];
                            [joinActivity setObject:user forKey:kPAPActivityFromUserKey];
                            [joinActivity setObject:newFriend forKey:kPAPActivityToUserKey];
                            [joinActivity setObject:kPAPActivityTypeJoined forKey:kPAPActivityTypeKey];
                            
                            PFACL *joinACL = [PFACL ACL];
                            [joinACL setPublicReadAccess:YES];
                            joinActivity.ACL = joinACL;
                            
                            // make sure our join activity is always earlier than a follow
                            [joinActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                [PAPUtility followUserInBackground:newFriend block:^(BOOL succeeded, NSError *error) {
                                    // This block will be executed once for each friend that is followed.
                                    // We need to refresh the timeline when we are following at least a few friends
                                    // Use a timer to avoid refreshing innecessarily
                                    if (self.autoFollowTimer) {
                                        [self.autoFollowTimer invalidate];
                                    }
                                    
                                    self.autoFollowTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(autoFollowTimerFired:) userInfo:nil repeats:NO];
                                }];
                            }];
                        }];
                    }
                    
                    //                    if (![self shouldProceedToMainInterface:user]) {
                    //                        [self logOut];
                    //                        return;
                    //                    }
                    
                    //                    if (!error) {
                    //                        [MBProgressHUD hideHUDForView:self.navController.presentedViewController.view animated:NO];
                    //                        if (anypicFriends.count > 0) {
                    //                            //                        self.hud = [MBProgressHUD showHUDAddedTo:self.homeViewController.view animated:NO];
                    //                            //                        self.hud.dimBackground = YES;
                    //                            //                        self.hud.labelText = NSLocalizedString(@"Following Friends", nil);
                    //                        } else {
                    //                            //                        [self.homeViewController loadObjects];
                    //                        }
                    //                    }
                }];
            }
            
            [user saveEventually];
        } else {
            NSLog(@"No user session found. Forcing logOut.");
            //            [self logOut];
        }
    } else {
        self.hud.labelText = NSLocalizedString(@"Creating Profile", nil);
        NSString *facebookId = [result objectForKey:@"id"];
        NSString *facebookName = [result objectForKey:@"name"];
        //新增用戶資料 名字、姓氏、性別、地區(用Graph API的代號)
        NSString *facebookFirst_Name = [result objectForKey:@"first_name"];
        NSString *facebookLast_Name = [result objectForKey:@"last_name"];
        NSString *facebookBirthday = [result objectForKey:@"birthday"];
        NSString *facebookEmail = [result objectForKey:@"email"];
        NSString *facebookGender = [result objectForKey:@"gender"];
        NSString *facebookLocation = [result objectForKey:@"locale"];
        
        if (user) {
            if (facebookName && [facebookName length] != 0) {
                [user setObject:facebookName forKey:kPAPUserDisplayNameKey];
            } else {
                [user setObject:@"Someone" forKey:kPAPUserDisplayNameKey];
            }
            if (facebookId && [facebookId length] != 0) {
                [user setObject:facebookId forKey:kPAPUserFacebookIDKey];
            }
            //儲存姓氏
            if (facebookFirst_Name && facebookFirst_Name != 0) {
                [[PFUser currentUser] setObject:facebookFirst_Name forKey:kPAPUserFacebookFirstNameKey];
            }
            //儲存名字
            if (facebookLast_Name && facebookLast_Name != 0) {
                [[PFUser currentUser] setObject:facebookLast_Name forKey:kPAPUserFacebookLastNameKey];
            }
            //儲存生日
            if (facebookBirthday && facebookBirthday != 0) {
                [[PFUser currentUser] setObject:facebookBirthday forKey:kPAPUserFacebookBirthdayKey];
            }
            //儲存email
            if (facebookEmail && facebookEmail != 0) {
                [[PFUser currentUser] setObject:facebookEmail forKey:kPAPUserFacebookEmailKey];
            }
            //儲存性別
            if (facebookGender && facebookGender != 0) {
                [[PFUser currentUser] setObject:facebookGender forKey:kPAPUserFacebookGenderKey];
            }
            //儲存地理位置
            if (facebookLocation && facebookLocation != 0) {
                [[PFUser currentUser] setObject:facebookLocation forKey:kPAPUserFacebookLocalsKey];
            }
            
            NSLog(@"正在下載用戶檔案照片...");
            // Download user's profile picture
            NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [user objectForKey:kPAPUserFacebookIDKey]]];
            // Facebook profile picture cache policy: Expires in 2 weeks
            NSURLRequest *profilePictureURLRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:0.0f];
            [NSURLConnection connectionWithRequest:profilePictureURLRequest delegate:self];
            
            PFQuery *userQuery = [PFUser query];
            [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (objects.count < 2000) {
                    [[PFUser currentUser] setObject:@YES forKey:@"EarlyBird"];
                    [user saveEventually];
                }else{
                    [[PFUser currentUser] setObject:@NO forKey:@"EarlyBird"];
                    [user saveEventually];
                }
            }];
        }
        
        [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                [self facebookRequestDidLoad:result];
            } else {
                [self facebookRequestDidFailWithError:error];
            }
        }];
    }
}

- (void)autoFollowTimerFired:(NSTimer *)aTimer {
    
    //    [MBProgressHUD hideHUDForView:self.navController.presentedViewController.view animated:YES];
    //    [MBProgressHUD hideHUDForView:self.paphomeViewController.view animated:YES];
    //    [self.paphomeViewController loadObjects];
}

- (void)facebookRequestDidFailWithError:(NSError *)error {
    NSLog(@"Facebook error: %@", error);
    
    if ([PFUser currentUser]) {
        if ([[error userInfo][@"error"][@"type"] isEqualToString:@"OAuthException"]) {
            NSLog(@"The Facebook token was invalidated. Logging out.");
            [self logOut];
        }
    }
}

#pragma mark - NSURLConnectionDataDelegate 儲存照片資料
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _data = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [PAPUtility processFacebookProfilePictureData:_data];
}

#pragma mark - 登出
- (void)logOut {
    // clear cache
    [[OmniCache sharedCache] clear];
    
    // clear NSUserDefaults
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPAPUserDefaultsCacheFacebookFriendsKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPAPUserDefaultsActivityFeedViewControllerLastRefreshKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"install 4");
    // Unsubscribe from push notifications by clearing the channels key (leaving only broadcast enabled).
    [[PFInstallation currentInstallation] setObject:@[@""] forKey:kPAPInstallationChannelsKey];
    [[PFInstallation currentInstallation] removeObjectForKey:kPAPInstallationUserKey];
    [[PFInstallation currentInstallation] saveInBackground];
    
    // Log out
    [PFUser logOut];
    
    // clear out cached data, view controllers, etc.
    // then go to LoginViewController
    
}

@end
