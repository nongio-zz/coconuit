//
//  CNMath.h
//
//  CocoNuit is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Lesser General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version. 
//
//  CocoNuit is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Lesser General Public License for more details.
//
//  You should have received a copy of the GNU Lesser General Public License
//  along with CocoNuit.  If not, see <http://www.gnu.org/licenses/>.
//
//  Copyright 2009 Nicola Martorana <martorana.nicola@gmail.com>.
//

#import <Cocoa/Cocoa.h>
#import "CN2dVect.h"

static inline double maxDouble(double a, double b) {
	return a > b ? a : b;
}

static inline double maxAbs(double a, double b){
	if (fabs(a)>fabs(b)){
		return a;
	}
	else{
		return b;
	}
}

static inline int sign(double x){
	if(x!=0)
		return (x/fabs(x));
	else
		return 1;
}

static inline NSPoint mulPoint(NSPoint p,double k){
	NSPoint point = NSMakePoint(p.x*k, p.y*k);
	return point;
}

static inline CN2dVect* vectProductBetweenVector(CN2dVect* v1,CN2dVect*v2){
	
	double vectProduct = (v1.x*v2.y)-(v1.y*v2.x);
	
	CN2dVect* newVect = [[CN2dVect alloc] init];
	newVect.module = fabs(vectProduct);
	newVect.x=0;
	newVect.y=0;
	newVect.z=vectProduct;
	
	return newVect;
}

static inline double scalarProductBetweenVector(CN2dVect* v1,CN2dVect* v2){
	double product = v1.x*v2.x+v1.y*v2.y;
	return product;
}

static inline double getRotationSenseBetweenVector(CN2dVect* v1, CN2dVect* v2){
	CN2dVect* tempVect = vectProductBetweenVector(v1,v2);
	if(tempVect.module!=0)
		return tempVect.z/tempVect.module;
	else
		return 0;
}

static inline double getAngleBetweenVector(CN2dVect* v1,CN2dVect* v2){
	
	double cosAlfa = scalarProductBetweenVector(v1,v2)/(v1.module*v2.module);
	
	double alfa = acos(cosAlfa);
	
	return alfa;
}

static inline CN2dVect* getProjectionOfVector(CN2dVect* v2,CN2dVect* v1){
	//Proiezione di v2 su v1
	CN2dVect* projVect = [[CN2dVect alloc] init];
	
	if(!NSEqualPoints(v1.unitVector,v2.unitVector)){
		double scalarProd = scalarProductBetweenVector(v1,v2);
		
		double k = scalarProd/pow(v1.module,2);
		
		projVect.x = v1.x*k;
		projVect.y = v1.y*k;
		projVect.z = 0;
		
		projVect.module = scalarProd/v1.module;
		
		projVect.unitVector = v1.unitVector;
	}
	else{
		projVect = v2;
		
	}
	return projVect;
}


static inline NSPoint getMediumPoint(NSPoint p1, NSPoint p2){
	NSPoint mediumPoint;
	mediumPoint.x = (p1.x+p2.x)/2;
	mediumPoint.y = (p1.y+p2.y)/2;
	
	return mediumPoint;
}

static inline NSPoint getSum(NSMutableArray* points){
	double x = 0;
	double y = 0;
	
	for (NSValue* value in points){
		NSPoint p = [value pointValue];
		
		x+=p.x;
		y+=p.y;
	}
	
	NSPoint sum = NSMakePoint(x, y);
	
	return sum;
}

static inline NSPoint getSquareSum(NSMutableArray* points){
	double x=0;
	double y=0;
	
	for (NSValue* value in points){
		NSPoint p = [value pointValue];
		
		x+=pow(p.x,2);
		y+=pow(p.y,2);
	}
	
	NSPoint sum = NSMakePoint(x, y);
	
	return sum;
}

static inline double getProductSum(NSMutableArray* points){
	double sum;
	for (NSValue* value in points){
		NSPoint p = [value pointValue];
		
		sum+=p.x*p.y;
	}
	
	return sum;
}

//creare fuori l'array dei punti velocità
//raggruppare i tocchi in base alla retta trovata

static inline NSPoint getLinearApproximation(NSMutableArray* points){
	int N = [points count];
	NSPoint sum = getSum(points);
	NSPoint squareSum = getSquareSum(points);
	double productSum = getProductSum(points);
	
	double m = (sum.x*sum.y - N* productSum)/(pow(sum.x,2) - N*squareSum.x);
	double q = (sum.x * productSum - squareSum.x * sum.y)/(pow(sum.x,2) - N*squareSum.x);
	
	NSPoint rectParams = NSMakePoint(m,q);
	
	return rectParams;
}

static bool pointIsOver(NSPoint rectParams,NSPoint point){
	if(point.y>=(rectParams.x*point.x+rectParams.y)){
		return true;
	}
	else{
		return false;
	}
}

static inline NSMutableArray* getOverPoints(NSArray* points,NSPoint rectParams){
	NSMutableArray* overPoints = [[NSMutableArray alloc] init];
	
	for(NSValue* value in points){
		NSPoint p = [value pointValue];
		
		if(pointIsOver(rectParams,p)){
			[overPoints addObject:value];
		}
	}
	
	return overPoints;
	
}

static inline NSMutableArray* getBehindPoints(NSArray* points,NSPoint rectParams){
	NSMutableArray* behindPoints = [[NSMutableArray alloc] init];
	
	for(NSValue* value in points){
		NSPoint p = [value pointValue];
		
		if(!pointIsOver(rectParams,p)){
			[behindPoints addObject:value];
		}
	}
	
	return behindPoints;
	
}

static inline NSPoint getIncenter(NSArray* points){
	NSPoint center;
	
	NSPoint A = [[points objectAtIndex:0] pointValue];
	NSPoint B = [[points objectAtIndex:1] pointValue];	
	NSPoint C = [[points objectAtIndex:2] pointValue];
	
	double a=sqrt(pow((B.x-A.x),2)+pow((B.y-A.y),2));
	double b=sqrt(pow((C.x-A.x),2)+pow((C.y-A.y),2));
	double c=sqrt(pow((B.x-C.x),2)+pow((B.y-C.y),2));
	double pp = a+b+c;
	
	double ox = (a*A.x+b*B.x+c*C.x)/pp;
	double oy = (a*A.y+b*B.y+c*C.y)/pp;
	
	center = NSMakePoint(ox, oy);
	
	return center;
	
}

static inline NSPoint getCenterPoint(NSArray* points){
	NSPoint center;
	int n = points.count;
	if(n == 1){
		center = [[points objectAtIndex:0] pointValue];
		return center;
	}
	if(n == 2){
		NSPoint p1 = [[points objectAtIndex:0] pointValue];
		NSPoint p2 = [[points objectAtIndex:1] pointValue];
		
		center = getMediumPoint(p1,p2);
		return center;
	}
	if(n == 3){
		center = getIncenter(points);
		return center;
	}
	if(n > 3){
		NSMutableArray* inCenterPointsArray = [[NSMutableArray alloc] init];
		for (int i=0;i<n-2;i++){
			NSMutableArray* pointsArray = [[NSMutableArray alloc] init];
			[pointsArray addObject:[points objectAtIndex:0]];
			[pointsArray addObject:[points objectAtIndex:i+1]];
			[pointsArray addObject:[points objectAtIndex:i+2]];
			
			[inCenterPointsArray addObject:[NSValue valueWithPoint:getCenterPoint(pointsArray)]];
		}
		return getCenterPoint(inCenterPointsArray);
	}
	return center;
}