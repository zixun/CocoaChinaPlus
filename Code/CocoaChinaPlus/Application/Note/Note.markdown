# 开发Note
##  https://itunes.apple.com/cn/app/cocoachina+/id1046424174


## iOS9中HTTPS请求切换为HTTP请求

右键点击`info.plist`，选择`Open As`->`Source Code`，然后插入

```
<key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
    </dict>
```


## dyld: Library not loaded: @rpath/libswiftCore.dylib

    http://stackoverflow.com/a/26949219/2710572


## iOS8下WKWebView不能加载本地资源

    http://stackoverflow.com/a/28676439/2710572






## RxSwift

UIBarButtonItem 如果是CutomView初始化的则rx_tap不会响应