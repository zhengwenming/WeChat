# WeChat
实现类似微信朋友圈或者QQ空间，评论回复，贴吧盖楼，九宫格布局。处理键盘弹出后定位到当前点击的被评论人处。
---
更新日志

#2017年9月24日更新朋友圈2模式，易懂，易继承。

#2018年4月11日更新UISearchController的使用优化，在通讯录搜索🔍页面。

#2020年4月12日更新,重构项目，适配iOS13，更新更多功能
   1、优化朋友圈页面删除cell嵌套tableview的结构，但是仍可以在tag=1.0的版本中下载，
   2、优化通讯录
   3、优化首页消息列表。

---
本人开发的小程序--账户密码管理（专门管理个人账户信息），采用腾讯云开发模式，信息加密后存储腾讯云，安全，免费，永不丢失密码！欢迎试用

![34011649649201_ pic](https://user-images.githubusercontent.com/8285047/162709316-0e069ed7-8a01-4eb5-941d-3aa897507f8e.jpg)

---

1、页面全部采用Masonry自动布局。（自定义九宫格布局）

2、完美处理键盘，适配系统键盘＋搜狗键盘。

（1）点击评论则定位在当前点击的按钮下发
（2）点击评论cell，则直接定位在点击cell的下方
（3）完美兼容系统键盘和搜狗键盘

4、集成

主要看json数据。在项目中的supportFile里面。理清楚json的结构，重写UI即可。

5、持续更新中......



朋友圈界面效果图：

![image](https://github.com/zhengwenming/WeChat/blob/master/WeChat/WeChat.gif)   



通讯录界面效果图：

![image](https://github.com/zhengwenming/WeChat/blob/master/WeChat/addressBook.gif)   



