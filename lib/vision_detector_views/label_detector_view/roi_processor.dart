import 'dart:io' as io;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

// ROI 圖像處理類別，用於裁剪和處理感興趣區域的圖像
class ROIProcessor {
  // 從 InputImage 中創建 ROI 區域的 InputImage
  static Future<InputImage?> processROI(
      InputImage inputImage,
      Rect roi,
      CameraLensDirection cameraLensDirection) async {
    try {
      // 如果是文件路徑，我們可以讀取圖像並裁剪
      if (inputImage.type == InputImageType.file) {
        final file = io.File(inputImage.filePath!);
        final bytes = await file.readAsBytes();
        final image = img.decodeImage(bytes);
        if (image == null) return null;

        // 計算實際要裁剪的區域（考慮縮放和旋轉）
        final int x = (roi.left * image.width / inputImage.metadata!.size.width).round();
        final int y = (roi.top * image.height / inputImage.metadata!.size.height).round();
        final int width = (roi.width * image.width / inputImage.metadata!.size.width).round();
        final int height = (roi.height * image.height / inputImage.metadata!.size.height).round();

        // 裁剪圖像
        final croppedImage = img.copyCrop(
          image,
          x: x,
          y: y,
          width: width,
          height: height,
        );

        // 將裁剪後的圖像保存為臨時文件
        final tempDir = await getTemporaryDirectory();
        final tempFile = io.File('${tempDir.path}/roi_image.jpg');
        await tempFile.writeAsBytes(img.encodeJpg(croppedImage));

        // 創建新的 InputImage
        return InputImage.fromFilePath(tempFile.path);
      }

      return null;
    } catch (e) {
      print('ROI 處理失敗: $e');
      return null;
    }
  }

  // 從相機圖像創建用於顯示的ROI圖像
  static Future<Image?> createDisplayableROIImage(
      CameraImage cameraImage,
      Rect roi,
      CameraDescription camera,
      {Size? screenSize}) async {
    try {
      // 使用一個簡單方法：只取Y平面（亮度）創建灰度圖像
      final imgLib = await _convertYUVToImage(cameraImage);
      if (imgLib == null) return null;

      // 使用傳入的螢幕尺寸或預設值
      final actualScreenWidth = screenSize?.width ?? 400.0;
      final actualScreenHeight = screenSize?.height ?? 800.0;

      // 保留原始圖像以便調試
      img.Image originalImage = img.copyResize(imgLib, width: actualScreenWidth.toInt(), height: actualScreenHeight.toInt());

      // 根據相機旋轉調整圖像
      final rotation = InputImageRotationValue.fromRawValue(camera.sensorOrientation);
      img.Image rotatedImage = originalImage;

      if (rotation == InputImageRotation.rotation90deg) {
        rotatedImage = img.copyRotate(originalImage, angle: 90);
      } else if (rotation == InputImageRotation.rotation180deg) {
        rotatedImage = img.copyRotate(originalImage, angle: 180);
      } else if (rotation == InputImageRotation.rotation270deg) {
        rotatedImage = img.copyRotate(originalImage, angle: 270);
      }

      // 根據鏡頭方向進行水平翻轉
      if (camera.lensDirection == CameraLensDirection.front) {
        rotatedImage = img.flipHorizontal(rotatedImage);
      }

      print('ROI矩形: left=${roi.left}, top=${roi.top}, width=${roi.width}, height=${roi.height}');
      print('旋轉後圖像尺寸: width=${rotatedImage.width}, height=${rotatedImage.height}');

      // 計算ROI在旋轉後圖像中的位置（考慮縮放比例）
      double scaleX = rotatedImage.width / actualScreenWidth;
      double scaleY = rotatedImage.height / actualScreenHeight;

      // 使用與UI相對應的坐標系來定位ROI
      final int roiX = (roi.left * scaleX).toInt().clamp(0, rotatedImage.width - 1);
      final int roiY = (roi.top * scaleY).toInt().clamp(0, rotatedImage.height - 1);
      final int roiWidth = (roi.width * scaleX).toInt().clamp(1, rotatedImage.width - roiX);
      final int roiHeight = (roi.height * scaleY).toInt().clamp(1, rotatedImage.height - roiY);

      print('計算後的ROI裁剪區域: x=$roiX, y=$roiY, width=$roiWidth, height=$roiHeight');

      // 在旋轉後的圖像上標記ROI位置（用於調試）
      img.Image markedImage = img.copyResize(rotatedImage, width: rotatedImage.width, height: rotatedImage.height);

      // 在圖像上畫一個紅色邊框顯示ROI位置
      for (int x = roiX; x < roiX + roiWidth; x++) {
        if (x >= 0 && x < markedImage.width) {
          if (roiY >= 0 && roiY < markedImage.height)
            markedImage.setPixelRgb(x, roiY, 255, 0, 0);
          int bottomY = roiY + roiHeight - 1;
          if (bottomY >= 0 && bottomY < markedImage.height)
            markedImage.setPixelRgb(x, bottomY, 255, 0, 0);
        }
      }

      for (int y = roiY; y < roiY + roiHeight; y++) {
        if (y >= 0 && y < markedImage.height) {
          if (roiX >= 0 && roiX < markedImage.width)
            markedImage.setPixelRgb(roiX, y, 255, 0, 0);
          int rightX = roiX + roiWidth - 1;
          if (rightX >= 0 && rightX < markedImage.width)
            markedImage.setPixelRgb(rightX, y, 255, 0, 0);
        }
      }

      // 裁剪ROI
      final croppedImage = img.copyCrop(
        rotatedImage,
        x: roiX,
        y: roiY,
        width: roiWidth,
        height: roiHeight,
      );

      // 保存為臨時文件
      final tempDir = await getTemporaryDirectory();

      // 保存調試圖像（帶有ROI標記的完整圖像）
      final debugImageFile = io.File('${tempDir.path}/debug_image_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await debugImageFile.writeAsBytes(img.encodeJpg(markedImage));

      // 保存裁剪後的ROI
      final tempFile = io.File('${tempDir.path}/display_roi_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await tempFile.writeAsBytes(img.encodeJpg(croppedImage));

      // 返回Flutter圖像Widget
      return Image.file(tempFile);
    } catch (e) {
      print('創建可顯示的ROI圖像失敗: $e');
      return null;
    }
  }

  // 從相機圖像中裁剪ROI並創建InputImage
  static Future<InputImage?> createROIInputImage(
      CameraImage cameraImage,
      Rect roi,
      CameraDescription camera,
      {Size? screenSize}) async {
    try {
      // 轉換為標準圖像格式
      final imgLib = await _convertYUVToImage(cameraImage);
      if (imgLib == null) return null;

      // 使用傳入的螢幕尺寸或預設值
      final actualScreenWidth = screenSize?.width ?? 400.0;
      final actualScreenHeight = screenSize?.height ?? 800.0;

      // 保留原始圖像以便調試
      img.Image originalImage = img.copyResize(imgLib, width: actualScreenWidth.toInt(), height: actualScreenHeight.toInt());

      // 根據相機旋轉調整圖像
      final rotation = InputImageRotationValue.fromRawValue(camera.sensorOrientation);
      img.Image rotatedImage = originalImage;

      if (rotation == InputImageRotation.rotation90deg) {
        rotatedImage = img.copyRotate(originalImage, angle: 90);
      } else if (rotation == InputImageRotation.rotation180deg) {
        rotatedImage = img.copyRotate(originalImage, angle: 180);
      } else if (rotation == InputImageRotation.rotation270deg) {
        rotatedImage = img.copyRotate(originalImage, angle: 270);
      }

      // 根據鏡頭方向進行水平翻轉
      if (camera.lensDirection == CameraLensDirection.front) {
        rotatedImage = img.flipHorizontal(rotatedImage);
      }

      // 計算ROI在旋轉後圖像中的位置（考慮縮放比例）
      double scaleX = rotatedImage.width / actualScreenWidth;
      double scaleY = rotatedImage.height / actualScreenHeight;

      // 使用與UI相對應的坐標系來定位ROI
      final int roiX = (roi.left * scaleX).toInt().clamp(0, rotatedImage.width - 1);
      final int roiY = (roi.top * scaleY).toInt().clamp(0, rotatedImage.height - 1);
      final int roiWidth = (roi.width * scaleX).toInt().clamp(1, rotatedImage.width - roiX);
      final int roiHeight = (roi.height * scaleY).toInt().clamp(1, rotatedImage.height - roiY);

      // 裁剪ROI
      final croppedImage = img.copyCrop(
        rotatedImage,
        x: roiX,
        y: roiY,
        width: roiWidth,
        height: roiHeight,
      );

      // 保存為臨時文件
      final tempDir = await getTemporaryDirectory();
      final tempFile = io.File('${tempDir.path}/roi_image_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await tempFile.writeAsBytes(img.encodeJpg(croppedImage));

      // 創建InputImage
      return InputImage.fromFilePath(tempFile.path);
    } catch (e) {
      print('創建ROI輸入圖像失敗: $e');
      return null;
    }
  }

  // 將YUV相機圖像轉換為標準圖像
  static Future<img.Image?> _convertYUVToImage(CameraImage cameraImage) async {
    try {
      // 這是一個簡化版本：僅使用Y平面來創建灰度圖像
      if (cameraImage.planes.isEmpty) return null;

      final width = cameraImage.width;
      final height = cameraImage.height;
      final yPlane = cameraImage.planes[0];
      final yBuffer = yPlane.bytes;

      // 創建灰度圖像
      final image = img.Image(width: width, height: height);

      for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
          final int yIndex = y * yPlane.bytesPerRow + x;

          // 確保索引在有效範圍內
          if (yIndex < yBuffer.length) {
            final int gray = yBuffer[yIndex] & 0xFF;
            image.setPixelRgb(x, y, gray, gray, gray);
          }
        }
      }

      return image;
    } catch (e) {
      print('相機圖像轉換失敗: $e');
      return null;
    }
  }
}