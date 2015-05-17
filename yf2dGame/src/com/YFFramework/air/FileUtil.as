package com.YFFramework.air
{
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.utils.image.advanced.SaveImages;
	import com.YFFramework.core.utils.image.advanced.SpliteImage;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;

	public class FileUtil
	{
		/**
		 * 作用是提供 stage属性      例如给Alert对象
		 */
		private static var _parent:DisplayObjectContainer;
		
		public static var eventDispather:EventDispatcher=new EventDispatcher();
		public function FileUtil()
		{
		}
		/*
		*创建文件夹 url 既可以是nativePath 也可以是  url   
		*/
		public static function createDirectory (url:String):File
		{
			var file:File=File.desktopDirectory;
			if(url.charAt(0)=="f")
			{
				file.url=url;
			}
			else
			{
				file.nativePath=url
			}
			if(!file.exists)
			{
				///创建文件夹
				file.createDirectory();
			}
			return file;
		}
		
		public static function  createResoveDirector(rootFile:File,resovePath:String):File
		{
			var file:File=File.desktopDirectory;
			var url:String=rootFile.url;
			url=url+"/"+resovePath;
			file= FileUtil.createDirectory(url);
			return file;
		}
		/*	
		设置 File 的路径，如果有指定的File路径则直接返回 该路径，  如果设置的File.url 路径不存在  则创建该路径并返回路径  返回的是url路径
		*/	
		public static  function setDirectoryURL(url:String):String
		{
			var file:File=FileUtil.createDirectory(url);
			return file.url;
		}
		/**
		 * @param file
		 * @param resovePath   也就是文件名称  
		 * @param content
		 * @return 
		 * 
		 */		
		public static function createFile(file:File,resovePath:String,content:String=""):File
		{
			//	libsFile.directory=file;
			////创建文件
			var myF:File=file.resolvePath(resovePath);
			var fileStream:FileStream=new FileStream();
			fileStream.open(myF,FileMode.WRITE);
			fileStream.writeMultiByte(content,"utf-8");
			fileStream.close();
			return myF;
		}
		
		/**
		 * 通过byteArray数据生成文件  resovePath 一般只需要写名字即可 就是文件的名字
		 * @return
		 */
		public static function createFileByByteArray(file:File,resovePath:String,data:ByteArray):File
		{
			////创建文件
			var myF:File=file.resolvePath(resovePath);
			var fileStream:FileStream=new FileStream();
			fileStream.open(myF,FileMode.WRITE);
			fileStream.writeBytes(data);
			fileStream.close();
			return myF;
		}
		public static function createXMLFile(file:File,resovePath:String,content:String=""):File
		{
			////创建文件
			var myContent:String='<?xml version="1.0" encoding="utf-8"?>\n';
			myContent+=content;
			return FileUtil.createFile(file, resovePath, myContent);
		} 
		/*
		* 复制 文件  或者目录   复制的过程中  假如有相同的文件存在，则会将原来的文件覆盖掉     返回复制后的文件对象
		@param   originalFile 是要复制的文件源对象  
		@param   url   指的是文件File的 的url路径 形式类似于  file:///C:/   并且是绝对路径    url网络形式路径, 是复制后 的副本对象
		*/
		
		public static function copyFileToAsync(originalFile:File,url:String):void
		{
			var newFile:File=File.desktopDirectory;
			newFile.url=url;
			originalFile.copyToAsync(newFile,true);
			originalFile.addEventListener(Event.COMPLETE,onComplete);
			originalFile.addEventListener(IOErrorEvent.IO_ERROR,onError);
		}
		private  static function  onComplete(e:Event):void
		{
			var originalFile:File = e.currentTarget as File;
			originalFile.removeEventListener(Event.COMPLETE,onComplete);
			originalFile.removeEventListener(IOErrorEvent.IO_ERROR,onError); 
			eventDispather.dispatchEvent(new Event(Event.COMPLETE,true));
				
			Alert.show("文件复制成功","提示:");
		}
		private static function onError(e:IOErrorEvent):void
		{
			Alert.show("复制文件发生错误","错误");
			var originalFile:File = e.currentTarget as File;
			originalFile.removeEventListener(Event.COMPLETE,onComplete);
			originalFile.removeEventListener(IOErrorEvent.IO_ERROR,onError);
		}
		
		
		///判断是否存在 这一地址 存在则返回true  否则为false
		public static function isExist(url:String):Boolean
		{
			var isExist:Boolean=false;
			var file:File=File.documentsDirectory;
			file.url=url;
			if(file.exists)	isExist=true;
			return isExist;
		}
		/**
		 * 
		 * @return  本地路径转化为网络路径
		 */
		public static function   nativePathToUrl(nativePath:String):String 
		{
			var file:File = File.documentsDirectory;
			file.nativePath = nativePath;
			return file.url;
		}
		/**
		 *  网络路径转化为本地路径
		 * @param	url
		 * @return
		 */
		public static function  urlToNativePath(url:String):String
		{
			var file:File = File.documentsDirectory;
			file.url = url;
			return file.nativePath;
		}
		/**
		 * 得到后缀名
		 */
		private static function getLastStr(str:String):String
		{
			var index:int=str.indexOf(".");
			var myStr:String = str.substr(index);
			return myStr;
		}
		/**		切割图片,将图片变为 多个小图片 
		 * @param	parent 提供 stage属性 用于Alert
		 * @param	dir	存储地址
		 * @param	image	要切割的对象
		 * @param	sliceW	切片宽
		 * @param	sliceH	切片高
		 * @param	_type	生成的图片类型 值为 jpg  png bmp 三种
		 * @param	quality  当为jpg 时  图片的质量
		 */
		public static function createSliceImage(parent:DisplayObjectContainer,dir:File,image:DisplayObject,sliceW:int,sliceH:int,_type:String="jpg",quality:int=80,force:Boolean=true):void 
		{
			_parent = parent;
			var spliteImage:SpliteImage = new SpliteImage();
			var saveImage:SaveImages = new SaveImages();
			var imageArr:Array=[]
			var positions:Array=[];
			spliteImage.splite(image,sliceW,sliceH,force);
			imageArr=spliteImage.smallImages
			positions=spliteImage.storePosition;
			spliteImage.release();
			var fileNames:Vector.<String>=new Vector.<String>();
			var i:int=0;
			var len:int=positions.length
			var myName:String;
			var obj:Object
			while(i!=len){
				obj=positions[i];
				myName=obj.row+"_"+obj.column;
				fileNames.push(myName);
				++i;
			}
			saveImage.addEventListener(Event.COMPLETE,OnSaveComplete);
			saveImage.save(dir,imageArr,fileNames,_type,quality);
		}
		private static function OnSaveComplete(e:Event):void 
		{
			Alert.show( "提示:", "图片切片生成完成");
			///消除对她的引用
			_parent = null;
		}
		/**
		 * 创建低质量的图片
		 * @param	_parent  提供stage属性
		 * @param		dir     保存目录
		 * @param	image  源对象  
		 * @param	_quality  生成 jpg图片 的质量
		 */
		
		public static function createLowQualityImage(parent:DisplayObjectContainer,dir:File, image:DisplayObject,_name:String="低像素图片", _quality:int = 20):void 
		{
			_parent = parent;
			var saveImages:SaveImages = new SaveImages();
			var arr:Array = [image];
			var fileNames:Vector.<String> = new Vector.<String>()
			fileNames.push(_name);
			saveImages.addEventListener(Event.COMPLETE,onLowQualityImage);
			saveImages.save(dir,arr,fileNames,"jpg",_quality);
		}
		private static function onLowQualityImage(e:Event):void 
		{
			Alert.show( "提示:", "低像素图片生成完成");
			///消除对她的引用
			_parent = null;
		}

		
		public static function getPngList(director:File):Vector.<String>
		{
			var arrList:Array=director.getDirectoryListing();
			var urlVect:Vector.<String>=new Vector.<String>();
			for each(var file:File in arrList)
			{
				///当不为  文件夹
				if(file.isDirectory==false&&(file.type==".png"||file.type==".jpg"))
				{
					urlVect.push(file.url);
				}
			}
			return urlVect;

		}
	}
}