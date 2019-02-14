require File.dirname(__FILE__) + '/xcodeProjectProcess'

projectPath = "/Users/knowchat02/App/App.xcodeproj"
pf = XCProjectFind.new(projectPath,nil,nil,1);
pf.addSourcePath("go","jh").addSourcePath("gg ","gg").addFile("KJlone.h").addFile("KJlone.m",true,0,"-fno-objc-arc"); #创建文件夹 添加文件
pf.comeDic("/go/gg").addFile("KJlone.h").addFile("KJlone.m",true,0,"-fno-objc-arc"); #进入文件夹 添加文件
pf.findFile("ViewController.h").removeBuildFile(1); 