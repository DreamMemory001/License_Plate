# LicensePlateRecognition
License plate recognition

##  车牌识别系统
### 拿到定位车牌
+ 1.>通过对车牌原始图片的灰度，边缘检测（使用roberts算子，以增强区域可辨识度），
 腐蚀膨胀（设定'rectangle',[25,25]的结构元素与局部图片区域记性卷积），填充，
 去除聚团灰度值小于（2000）的部分，二值化，进而去除左干扰，右干扰，实现车牌定位。
 
 
 ### 切割定位车牌（其中切割有小技巧）
+ 2.>拿到定位车牌的图片后再次进行灰度，再进行白色像素点的统计，然后进行切割.
（因为每个图片进过二值化之后都是有0，1组成的像素矩阵，在matlab中可以用找波谷的方法来实现切割的目的）。

 [切割：你在切割时一定会遇到 “川” 这样非连通区域的字，这时候按照原来的方法切，
    由于阈值安排的不合适，会造成切割成三部分。这时候有三种解决方案，按照癖好自行选择：
    + a：由于照片是一个像素点矩阵，所以我们可以从右向左切，最后剩下的一部分不做处理，直接当做第一个汉字。
    + b:我们还可以通过腐蚀后的照片找到第一个汉字的size，然后再到二值化后的图片里找这个size（也就是坐标），
        找到之后通过size来切割。
    + c: 第三种也就是本项目里边用到的方法 ，通过对一个字的个别处理，通过合理化的设置阈值。后边的字母和数字再分别
         按照另一种算法来切，项目中都有写注释。]
         
         
 ### 识别车牌
+ 3.> 如果上一步切割比较完美的话识别也是比较容易的。通过和标准模板库里边的照片进行对比，得到汉字
       （或者也可以直接使用ocr算法：
       
         [语法：txt = ocr(I);
            txt = ocr(I,roi); 
            [_] = ocr(_,Name,Value); 
            其中，I为图像；roi为感兴趣的区域；Name为用一对单引号包含的字符串，Value为对应Name的值。
            虽然ocr简便一些，不过你如果切割的不太好，就要慎用了。]
            
 ### 识别一些结果图：
 
 ![第一张图：](/images/01.png)
 ![第二张图：](/images/02.png)
 ![第三张图：](/images/03.png)
 ![第四张图：](/images/04.png) 
