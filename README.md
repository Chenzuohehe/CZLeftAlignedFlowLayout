# CZLeftAlignedFlowLayout

<br>有时候会有这样的需求，这时候会用一个collectionView加上左对齐的collectionViewFlowLayout来做出来。
<br>有一个我觉得很不错的https://github.com/mokagio/UICollectionViewLeftAlignedLayout
<br><br>
<img src="http://wx2.sinaimg.cn/thumb300/e91c45bdgy1fdxrb3itn6j20hq0k4ta0.jpg" /><br><br>
<br>但是有时又有一些很特别的需求。。。比如这样的<br><br>
<img src="http://wx2.sinaimg.cn/mw1024/e91c45bdgy1fdxrb3j1p9j20pq0dwt98.jpg" />
<br><br>于是。。只能自己重新写了一个。。效果如图
<img src="http://wx4.sinaimg.cn/mw1024/e91c45bdgy1fdxrb3j88lj20yi1pc42k.jpg" />
<br><br><br>
## 使用
```objc
//最简单的使用
CZLeftAlignedFlowLayout * layout = [[CZLeftAlignedFlowLayout alloc]init];
layout.space = 54;
self.mainCollectionView.collectionViewLayout = layout;
```
<br>如果有需要的话，其他的设置只需要使用系统的就可以了


