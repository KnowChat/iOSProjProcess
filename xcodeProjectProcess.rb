#!/usr/bin/ruby -w
require 'xcodeproj'
class XCProjectFind
  def initialize(path = nil,project = nil,root = nil,rootIndex = 0)
    if path != nil
      @projectPath = path; 
      @project = Xcodeproj::Project.open(@projectPath);
      @rootgroup = @project.groups[rootIndex]
    else
      @project = project;
      @rootgroup = root;
    end
  end
  # 田间文件
  def addFile(filepath,toCompile = false,targetIndx = 0,flg = nil)
    path = @rootgroup;
    sourceref = path.new_reference(filepath);
    if toCompile == true
      pha = @project.native_targets[targetIndx].source_build_phase;
      buildFile = pha.add_file_reference(sourceref);
      if(flg != nil)
        buildFile.settings = Hash["COMPILER_FLAGS" =>flg];
      end
    end
    self.save();
    return XCProjectFind.new(nil,@project,path);
  end
  def findPath(group,name)
    return group.find_subpath(name,true);
  end

  def splitPath(dirPath)
    return dirPath.split("/");
  end
  #添加目录
  def addSourcePath(xcPath,realpath)
    xcpathobj = @rootgroup.find_subpath(xcPath,true)
    xcpathobj.path = realpath
    self.save();
    return XCProjectFind.new(nil,@project,xcpathobj);
  end
  #保存文件
  def save
    @project.save();
  end
  #进入文件夹
  def comeDic(xcPath,autocreate = false)
      for i in self.splitPath(xcPath) do
        if(i.length == 0)
          xcpathobj = @rootgroup;
        else
          xcpathobj = xcpathobj.find_subpath(i,true);
        end
      end
      if(autocreate == true)
        
      end
      find = XCProjectFind.new(nil,@project,xcpathobj);
      find.save();
      return find;
  end
  #查找文件
  def findFile(fileName)
    for i in @rootgroup.files do
      if i.display_name.eql?(fileName)
        return ProjectFile.new(@project,i);
      end
    end
    return nil;
  end
end

class ProjectFile
  def initialize(project,fileref)
    @project = project;
    @ref = fileref
  end
  #是不是 编译文件
  def isBuildFile(targetIndx = 0)
    builds = @project.native_targets[targetIndx].source_build_phase.files;
    for i in builds do
      if(i.file_ref == @ref)
        return true;
      end
    end
    return false;
  end
  #获取自己的编译信息
  def getBuildFile(targetIndx = 0)
    builds = @project.native_targets[targetIndx].source_build_phase.files;
    for i in builds do
      if(i.file_ref == @ref)
        return i
      end
    end
    return nil;
  end
  # 添加到编译文件中
  def addBuildFile(targetIndx = 0)
    pha = @project.native_targets[targetIndx].source_build_phase;
    pha.add_file_reference(@ref);
    @project.save()
    return self;
  end
  #移除编译文件
  def removeBuildFile(targetIndx = 0)
    pha = @project.native_targets[targetIndx].source_build_phase;
    bf = self.getBuildFile(targetIndx)
    if(bf != nil)
      pha.remove_build_file(bf);
      @project.save()
    else
      puts("#{@ref} is not build file");
    end
    return self;
  end
  #设置编译符号
  def setBuildFlag(flag=nil,targetIndex = 0)
    buildFile = self.getBuildFile(targetIndex);
    if(buildFile != nil)
      if(flag == nil)
        buildFile.settings = Hash["COMPILER_FLAGS" =>""];
      else
        buildFile.settings = Hash["COMPILER_FLAGS" =>flag];
      end
    else
      puts("#{@ref.path} is not is build file");
    end
    @project.save();
  end
end