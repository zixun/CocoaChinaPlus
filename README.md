![logo](http://zixun.github.io/images/custom/vender/icon.png)
# CocoaChina+
CocoaChina+是一款开源的第三方CocoaChina移动端。整个App都用Swift2.0编写(除部分第三方OC代码外，比如JPush和友盟)。

##GodEye调试工具
[GodEye](https://github.com/zixun/GodEye)是本人研发的一款纯Swift实现的APM(应用性能管理工具)，它可以自动展示日志，崩溃，网络，卡顿，内存泄露，CPU、RAM使用率，帧率FPS,网络流量，文件目录结构等信息。并且只需要一行代码接入，零代码入侵，线上版本不编译进一行代码，做到绝对的线上安全，就像上帝睁开了他的眼睛。

目前该工具已经接入CococaChinaPlus！

## QQ群：516326791
516326791
516326791
516326791

重要的事情说三遍

大家快到碗里来~~~~😄

## 开源库愿景
**希望有一天CocoaChina+会成为一个iOS开发者共同维护的App！**

##App截图

![home_cocoachina.jpg](http://zixun.github.io/images/custom/vender/home_cocoachina.jpg)
![article_cocoachina.jpg](http://zixun.github.io/images/custom/vender/article_cocoachina.jpg)
![code_cocoachina.jpg](http://zixun.github.io/images/custom/vender/code_cocoachina.jpg)

##产品特色
####1.代码高亮

目前市面上的第三方的CocoaChina的客户端app都没有做代码高亮，包括官方的Wap页面。这导致我们在手机端看博文的时候一到代码部分就非常蛋疼。CocoaChina+很好的解决了这个问题，极大的提高了阅读的体验。

####2.流量更省

文章渲染需要的CSS和JS代码CocoaChina+直接打包进了app内，每次文章加载的时候就不再需要去服务端获取一次了，极大的提高了加载速度，节省了用户的流量。

####3.纯黑设计

整个app采用纯黑色的设计，程序员都喜欢把自己的编辑器或者IDE界面调整成黑色，这样才可以把精力都集中在内容上，CocoaChina+的用户也基本都是程序员，因此也采用了纯黑色的设计，让用户在阅读文章的时候精力更加集中。

####4.内置聊天室

app内部整合了聊天室的功能，开发者可以直接进入和其他开发者直接匿名交流。是不是很好玩。


## 第三方库
CocoaChina+用CocoaPods来管理，主要用到的第三方库为：

	1.Neon   					强大的Swift布局库
	2.Ji    					加拿大华人写的一个HTML解析库
	3.Alamofire					这个就不说了
	4.RxSwift					Swift版的RAC框架
	5.SQLite.swift				Swift上操作SQLite数据库框架

当然CocoaChina+也用到了一些OC的三方库，这里就不说了。大家可以移步到Podfile看一下

## ZXKit
[ZXKit](https://github.com/zixun/ZXKit)是从CocoaChina+中抽离出来的一个组件库。当然这个组件库会一直更新，而且今后会添加我另外App的基础组件代码，ZXKit会是我以后所有App的base库。

ZXKit也是基于Neon和RxSwift编写的，目前ZXKit中有三个文件夹：
	
	1.core						基础核心类
	2.controller				各种包装后的controller
	3.view						各种包装后的view
	
##使用
	1.将工程git clone下来
	2.因为有子工程，所以要运行一下git submodule update --init --recursive将子工程clone下来
	3.运行pod install，初始化pod三方库
	4.build你的工程


##第三方平台
整个app整合了很多第三方平台，如友盟，极光推送，百度SSP，Google-Admob（已删除），环信IM（已删除）等，对于今后有想做Swift项目的同学有很大的参考价值。


##关于广告
开源代码中已经删除了所有的广告，之前嵌入Google和Baidu的广告是为了试试移动广告的水，由于这是我第一个app，以前没有接入过广告，想试试这两个广告平台盈利如何。我后续的app大多都是针对方便程序员学习和工作的，当然后续的app不会和cocoachina+一样开源。
PS:想知道这两个广告平台如何，可以群里私聊我。

##TODO
其实还有好多工作要做，但是由于最近工作越来越忙，本来打算过年前几天开源给大家的，但是接下去一段时间可能没有什么业余时间来做TODO这些工作，所以现在就开源给大家，希望对喜欢Swift的朋友，对技术有热情的朋友能有所帮助
#####1.论坛
CocoaChina论坛由于有很多Apple的logo。所以目前App内的论坛都把图片去掉了，目前上线的是一个简单的论坛功能，后续会着力更新论坛模块，CocoaChina的论坛做的还是很牛B的，所以后续一定会有一个很nice的论坛模块展示在CocoaChina+中

#####2.登陆
CocoaChina+目前没有登录功能，导致目前论坛上大家还不能直接评论，这个后续也会更新维护

#####3.聊天界面
CocoaChina+的聊天功能是整合了第三方的UI，不是很nice，后续楼主会自己用Swift重写一套简洁的聊天UI更新上去

##安装二维码
![qrcode.png](http://zixun.github.io/images/custom/vender/qrcode.png)


#打赏作者

<p align="center">要是觉得这个开源App帮到了你，不妨打赏一下</p>
<div align="center">
<form action="https://shenghuo.alipay.com/send/payment/fill.htm" method="POST" target="_blank" accept-charset="GBK" >
		<input name="optEmail" type="hidden" value="chenyl.exe@gmail.com" />
		<input name="payAmount" type="hidden" value="10" />
		<input id="title" name="title" type="hidden" value="博客打赏，买个包子" />
		<input name="memo" type="hidden" value="CocoaChina+打赏" />
		<input name="pay" type="image" value="转账" src="https://img.alipay.com/sys/personalprod/style/mc/btn-index.png" />
	</form>
	
	<p align="center">也可以使用「微信」「支付宝」客户端 赞赏：</p>

	<img align="center" height="200px" width="200px" src="http://zixun.github.io/images/custom/photo/dashang_wechat.jpg"/>&nbsp&nbsp&nbsp&nbsp
	<img align="center" height="200px" width="200px" src="http://zixun.github.io/images/custom/photo/dashang_zhifubao.jpg"/>
</div>




