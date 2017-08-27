# WeChat
实现类似微信朋友圈或者QQ空间，评论回复，贴吧盖楼，九宫格布局。处理键盘弹出后定位到当前点击的被评论人处。
---
微信扫码关注文明的iOS开发公众号
或者微信搜索“iOS开发by文明”

![image](https://github.com/zhengwenming/WMPlayer/blob/master/PlayerDemo/gzh.jpg)

---
1、缓存Cell高度（感谢黄仪标的开源库－－>HYBMasonryAutoCellHeight），使页面滑动不卡，丝丝入滑。

开源库地址：https://github.com/CoderJackyHuang/HYBMasonryAutoCellHeight

2、页面全部采用Masonry自动布局。（自定义九宫格布局）

3、完美处理键盘，适配系统键盘＋搜狗键盘。

（1）点击评论则定位在当前点击的按钮下发
（2）点击评论cell，则直接定位在点击cell的下方
（3）完美兼容系统键盘和搜狗键盘

4、集成

主要看json数据。在项目中的supportFile里面。理清楚json的结构，重写UI即可。

5、持续更新中......

第三方键盘的Github地址：https://github.com/bbbcode/KeyboardforChat

感谢作者bbbcode的开源。

朋友圈界面效果图：

![image](https://github.com/zhengwenming/WeChat/blob/master/WeChat/WeChat.gif)   



通讯录界面效果图：

![image](https://github.com/zhengwenming/WeChat/blob/master/WeChat/addressBook.gif)   



#欢迎加入iOS开发技术支持群，479259423，（3元付费群，手机端可以加，电脑加不了。慎入！）进群必须改名，群名片格式：城市-iOS-名字，例如广州-iOS-文明。
#欢迎关注我的斗鱼直播间，用手机下载斗鱼TV，搜索“文明直播间”或者“极端恐惧”就可以找到我的直播间。iOS技术分享直播。点关注不迷路，开播会有推送到大家手机。（个人直播，非机构非机构，适合初级iOS和中级iOS）。


