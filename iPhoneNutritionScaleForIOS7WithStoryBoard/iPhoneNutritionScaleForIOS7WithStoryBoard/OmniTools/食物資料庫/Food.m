//
//  Food.m
//  KitchenScale
//
//  Created by Orange on 13/5/20.
//  Copyright (c) 2013年 SNOWREX CREATIONS. All rights reserved.
//

#import "Food.h"

@implementation Food

@synthesize foodNumber;
@synthesize shortDescription;
@synthesize longDescription;
//@synthesize factorCarbohydrate;
@synthesize foodGroup;
// @synthesize factorFat;
// @synthesize factorProtein;
// @synthesize factorNitrogen;
@synthesize searchCount;

@synthesize title;
@synthesize subTitle;
@synthesize foodImage;
-(void) setFoodNumberWithInt:(int) number
{
	foodNumber = [[NSNumber alloc] initWithInt:number];
}
-(void) printFoodInfo
{
    NSLog(@"Food(%@)=[%@] group=[%@] title=[%@] sub title=[%@]",[self foodNumber],[self longDescription],[self foodGroup],[self title],[self subTitle]);
}
-(void) setFoodImageWithGroupID:(int)groupID
{
	switch(groupID){
		default:
			[self setFoodImage:
			[UIImage imageNamed:@"p3a recent search cell.png"]];  // American Indian/Alaska Native Foods  
			break;
		case 3500 :
			[self setFoodImage:
			[UIImage imageNamed:@"01indian.png"]];  // American Indian/Alaska Native Foods  
			break;
		case 300  :
			[self setFoodImage:
			[UIImage imageNamed:@"02baby.png"]];  // Baby Foods                                   
			break;
		case 1800 :
			[self setFoodImage:
			[UIImage imageNamed:@"03baked.png"]];  // Baked Products                           
			break;
		case 1300 :
			[self setFoodImage:
			[UIImage imageNamed:@"04beef.png"]];  // Beef Products                            
			break;
		case 1400 :
			[self setFoodImage:
			[UIImage imageNamed:@"05beverages.png"]];  // Beverages                            
			break;
		case 800  :
			[self setFoodImage:
			[UIImage imageNamed:@"06breakfast.png"]];  // Breakfast Cereals                        
			break;
		case 2000 :
			[self setFoodImage:
			[UIImage imageNamed:@"07cereal.png"]];  // Cereal Grains and Pasta              
			break;
		case 100  :
			[self setFoodImage:
			[UIImage imageNamed:@"08dairy.png"]];  // Dairy and Egg Products                       
			break;
		case 2100 :
			[self setFoodImage:
			[UIImage imageNamed:@"09fastfood.png"]];  // Fast Foods                           
			break;
		case 400  :
			[self setFoodImage:
			[UIImage imageNamed:@"10oil.png"]];  // Fats and Oils                                
			break;
		case 1500 :
			[self setFoodImage:
			[UIImage imageNamed:@"11finfish.png"]];  // Finfish and Shellfish Products       
			break;
		case 900  :
			[self setFoodImage:
			[UIImage imageNamed:@"12fruits.png"]];  // Fruits and Fruit Juices                  
			break;
		case 1700 :
			[self setFoodImage:
			[UIImage imageNamed:@"13lamb.png"]];  // Lamb, Veal, and Game Products            
			break;
		case 1600 :
			[self setFoodImage:
			[UIImage imageNamed:@"14legumes.png"]];  // Legumes and Legume Products          
			break;
		case 2200 :
			[self setFoodImage:
			[UIImage imageNamed:@"15meals.png"]];  // Meals, Entrees, and Sidedishes           
			break;
		case 1200 :
			[self setFoodImage:
			[UIImage imageNamed:@"16nut.png"]];  // Nut and Seed Products                    
			break;
		case 1000 :
			[self setFoodImage:
			[UIImage imageNamed:@"17pork.png"]];  // Pork Products                            
			break;
		case 500  :
			[self setFoodImage:
			[UIImage imageNamed:@"18poultry.png"]];  // Poultry Products                         
			break;
		case 3600 :
			[self setFoodImage:
			[UIImage imageNamed:@"19restaurant.png"]];  // Restaurant Foods                 
			break;
		case 700  :
			[self setFoodImage:
			[UIImage imageNamed:@"20sausages.png"]];  // Sausages and Luncheon Meats              
			break;
		case 2500 :
			[self setFoodImage:
			[UIImage imageNamed:@"21snacks.png"]];  // Snacks                               
			break;
		case 600  :
			[self setFoodImage:
			[UIImage imageNamed:@"22soup.png"]];  // Soups, Sauces, and Gravies                   
			break;
		case 200  :
			[self setFoodImage:
			[UIImage imageNamed:@"23spices.png"]];  // Spices and Herbs                         
			break;
		case 1900 :
			[self setFoodImage:
			[UIImage imageNamed:@"24sweets.png"]];  // Sweets                               
			break;
		case 1100 :
			[self setFoodImage:
			[UIImage imageNamed:@"25vegetables.png"]];  // Vegetables and Vegetable Products
			break;

	}
}

@end
