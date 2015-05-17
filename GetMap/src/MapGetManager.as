package
{
	import com.YFFramework.air.FileUtil;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.EventCenter;
	import com.YFFramework.core.event.ParamEvent;
	import com.YFFramework.core.net.loader.image_swf.UISLoader;
	import com.YFFramework.core.utils.image.advanced.encoder.JPGEncoder;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;

	/**@author yefeng
	 *2012-8-15下午7:43:57
	 */
	public class MapGetManager
	{
		private static var _sliceW:int;
		private static var _sliceH:int;
		private static var _mapW:int;
		private static var _mapH:int;
		private static var _root:String;
		private static var _fromZero:Boolean;
		private static var _pre:String;
		/**行列分布
		 */		
		private static var _row_coulun:Boolean;//true为行 --列  false 为 列 ---行
		private static var _isFirst:Boolean=false;
		public function MapGetManager()
		{
			
		}
		
		
		
		public static function getMap(mapW:int,mapH:int,sliceW:int,sliceH:int,root:String,pre:String,fromZero:Boolean,row_coulun:Boolean=true):void
		{
			_isFirst=true;
			getMapFunc(mapW,mapH,sliceW,sliceH,root,pre,fromZero,row_coulun);
		}
		
		
		/**
		 * @param mapW  地图宽
		 * @param mapH  地图高
		 * @param sliceW  切片宽
		 * @param sliceH  切片高
		 * @param root  切片图片的根目录 比如为  htpp://www.mygame.com/
		 * @param pre   切片的名称前缀
		 * @param fromZero 切片命名是否从0开始
		 */		
		private static function getMapFunc(mapW:int,mapH:int,sliceW:int,sliceH:int,root:String,pre:String,fromZero:Boolean=true,row_coulun:Boolean=true):void
		{
			_sliceW=sliceW;
			_sliceH=sliceH;
			_mapW=mapW;
			_mapH=mapH;
			_root=root;
			_pre=pre;
			_fromZero=fromZero;
			_row_coulun=row_coulun;
			var columns:int=Math.ceil(mapW/sliceW);
			var rows:int=Math.ceil(mapH/sliceH);
			var j:int;
			var currentColumn:int;
			var currentRow:int;
			var url:String;
			var arr:Vector.<Object>=new Vector.<Object>();
			for(var i:int=0;i!=rows;++i)
			{
				for(j=0;j!=columns;++j )
				{
					if(fromZero) 
					{
						currentColumn=j;
						currentRow=i;
					}
					else 
					{
						currentColumn=j+1;
						currentRow=i+1;
					}
					url=root+pre+currentRow+"_"+currentColumn+".jpg";
					arr.push({url:url,row:currentRow,column:currentColumn});
				}
			}
			var loaders:UISLoader=new UISLoader();
			loaders.ioErrorCallBack=ioError;
			loaders.loadCompleteCallBack=complete;
			loaders.progressCallBack=progress;
			loaders.load(arr);
			trace("map::开始处理.....");
		}
		
		private static function progress(e:ProgressEvent,currentIndex:int):void
		{
			var str:String="正在加载第"+currentIndex+"个，百分比:"+int(e.bytesLoaded*100/e.bytesTotal)+"%";
			EventCenter.Instance.dispatchEvent(new ParamEvent(ProgressEvent.PROGRESS,str));
		}
		private static function complete(arr:Vector.<Object>):void
		{
			var bitmap:Bitmap;
			var currentColumn:int;
			var currentRow:int;
			var sp:Sprite=new Sprite();
			for each (var obj:Object in arr)
			{
				bitmap=obj.display as Bitmap;
				currentColumn=obj.column;
				currentRow=obj.row;
				bitmap.width=bitmap.width+1;
				bitmap.height=bitmap.height+1;
				if(_row_coulun)  ///行列分布
				{
					bitmap.x=_sliceW*currentColumn;
					bitmap.y=_sliceH*currentRow;
				}
				else ///列行分布
				{
					bitmap.x=_sliceH*currentRow;
					bitmap.y= _sliceW*currentColumn;
				}
				sp.addChild(bitmap);
			}
			var bitmapData:BitmapData=new BitmapData(_mapW,_mapH,true);
			bitmapData.draw(sp);
			var encoder:JPGEncoder=new JPGEncoder(100);
			var bytes:ByteArray=encoder.encode(bitmapData);
			var file:File=File.desktopDirectory;
			file=FileUtil.createDirectory(file.url+"/getMap");
			var name:String=_mapW+"_"+_mapH+"_"+int(Math.random()*1000);
			FileUtil.createFileByByteArray(file,name+".jpg",bytes);
			Alert.show("获取"+name+".jpg");
		}
		
		private static function ioError(url:String):void
		{
			if(_isFirst)
			{
				getMap(_mapW,_mapH,_sliceW,_sliceH,_root,_pre,!_fromZero);
				_isFirst=false;				
			}
			else Alert.show("参数有错误，请调整是否从零开始参数");
			
		}
	}
}