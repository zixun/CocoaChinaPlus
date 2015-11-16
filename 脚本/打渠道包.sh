#!/bin/sh 

    #定义  
    QudaoArr=("a" "b" "c") 

    targetName="TestQudao"
    sourceipaname="TestQudao.ipa"    
    appname="TestQudao.app"  #加压后Pauload目录项.app文件名需要根据自己的项目修改     
    distDir="/Users/chenyl/Documents/test/ipa"   #打包后文件存储目录     
    version="1.0.0"    
    rm -rdf "$distDir "    
    mkdir "$distDir" 

    configname="info.plist" 

    PlistBuddy="/usr/libexec/PlistBuddy"  
    plutil="plutil" 

    #解压
    unzip $sourceipaname     #解压母包文件

    #打包
    for i in ${QudaoArr[@]} 
    do

        #进入app文件夹
        cd Payload
        cd $appname

        #替换plist中的key
        ${PlistBuddy} -c "set :ZXApplicationChannel $i" ${configname}  
        ${plutil} -convert binary1 ${configname}  
        # cat "${configname}"  


        if [ $i == "App Stroe" ]     
        then    
          cd ..     
           zip -r "${targetName}_${version}_from_$i.zip" $appname #//appstore二进制文件     
             mv "${targetName}_${version}_from_$i.zip" $distDir     
             cd ..     
             else    
             cd ../..     
             zip -r "${targetName}_${version}_from_$i.ipa" Payload SwiftSupport   #//打成其他渠道的包     
             mv "${targetName}_${version}_from_$i.ipa" $distDir     
             fi    
          done 
          rm -rdf Payload 
          rm -rdf SwiftSupport 