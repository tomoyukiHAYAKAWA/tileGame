//
//  opencvWrapper.m
//  opencvTest
//
//  Created by Tomoyuki Hayakawa on 2017/12/08.
//  Copyright © 2017年 Tomoyuki Hayakawa. All rights reserved.
//

//-----------------------これね
#import <opencv2/opencv.hpp>
//-----------------------
//-------------------------------これも忘れずに書く
#import <opencv2/imgcodecs/ios.h>
//-------------------------------
#import "opencvWrapper.h"

@implementation opencvWrapper

-(UIImage *)toGray:(UIImage *)src {
    // 変換用Mat
    cv::Mat gray_img;
    // imageをcv::Mat型へ変換
    UIImageToMat(src, gray_img);
    
    cv::cvtColor(gray_img, gray_img, CV_BGR2GRAY);
    
    src = MatToUIImage(gray_img);
    
    return src;
}

- (UIImage *)createModel:(UIImage *)src_img {
    cv::Mat dst_img;
    // src_imgをMat型へ変換
    UIImageToMat(src_img, dst_img);
    cv::cvtColor(dst_img, dst_img, CV_BGRA2BGR);
    // 分割した幅と高さ
    int h = dst_img.rows/4, w = dst_img.cols/4;
    for(int y = 0; y < dst_img.rows; y++) {
        for(int x = 0; x < dst_img.cols; x++) {
            if (h * 3 <= y && w * 3 <= x) {
                dst_img.at<cv::Vec3b>(y, x) = cv::Vec3b(255, 255, 255);
            }
        }
    }
    src_img = MatToUIImage(dst_img);
    return src_img;
}

- (NSArray *)splitImage:(UIImage *)src_img {
    
    cv::Mat dst_img;
    std::vector<cv::Mat> split_img;
    NSMutableArray *tmpArray = [NSMutableArray array];
    // src_imgをMat型へ変換
    UIImageToMat(src_img, dst_img);
    cv::cvtColor(dst_img, dst_img, CV_BGRA2BGR);
    int h = dst_img.rows/4, w = dst_img.cols/4;
    
    for (int y = 0; y < 4; y++) {
        for (int x = 0; x < 4; x++) {
            cv::Rect rect(x * w, y * h, w, h);
            cv::Mat d (dst_img, rect);
            split_img.push_back(d);
        }
    }
    
    for (int i = 0; i < split_img.size(); i++) {
        UIImage *image;
        image = MatToUIImage(split_img[i]);
        [tmpArray addObject:image];
    }
    return [NSArray arrayWithArray:tmpArray];
}

@end
