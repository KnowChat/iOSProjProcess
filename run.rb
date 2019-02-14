require File.dirname(__FILE__) + '/xcodeProjectProcess'

projectPath = "/Users/knowchat02/App/App.xcodeproj"
pf = XCProjectFind.new(projectPath,nil,nil,1);
# pf.addSourcePath("go","jh").addSourcePath("gg ","gg").addFile("KJlone.h").addFile("KJlone.m",true,0,"-fno-objc-arc"); #创建文件夹 添加文件 
pf.addSourcePaths("a/b/v/c/d");
pf.addSourcePaths("a/f/v/c/d");
# pf.findFile("ViewController.h").removeBuildFile(1); 