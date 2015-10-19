package
{
	import com.YFFramework.air.FileUtil;
	import com.YFFramework.core.utils.image.advanced.encoder.PNGEncoder;
	import com.YFFramework.core.yf2d.core.YF2d;
	
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	import atfMovie.ATFSkillEffect;
	

	public class ActionDataCreate
	{
		private static var _instance:ActionDataCreate;
		
		private var _movie:ATFSkillEffect;
		
		
		
		private var _preDraw:String = "";
		
		private   var _start :Boolean = false;
		public static function get Instance():ActionDataCreate
		{
			if(!_instance)_instance= new ActionDataCreate();
			return _instance;
		}

		
		private  var bitmapData:BitmapData;
		private var _dir:File;
		public function ActionDataCreate()
		{
			
		}
		
		public function init(w:int,h:int,dir:File,movie:ATFSkillEffect):void
		{
			bitmapData = new BitmapData(w,h,false,0xFFFFFF);
			_dir = dir;
			_movie = movie;
			YF2d.Instance.drawBitmapdataCall = drawData;
		}
		
		public function start():void
		{
			_start = true;

		}
		public function stop():void
		{
			_start = false;
			
		}

		
		public function reset():void
		{
			bitmapData.fillRect(bitmapData.rect,0xFFFFFF);
		}
		
		public function drawData(context3d:Context3D):void
		{
				var drawStr :String= _movie.playAction+"-"+_movie.playDirection+"-"+_movie.getPlayTween().getPlayIndex();
			if(drawStr!=_preDraw)
			{
				if (_movie.playAction!=-1&&_movie.playDirection!=-1)
				{

					_preDraw = drawStr;
					reset();
					context3d.drawToBitmapData(bitmapData);
					var file:File = _dir;
					var coder:PNGEncoder = new PNGEncoder();
					var bytes:ByteArray = coder.encode(bitmapData)
					FileUtil.createFileByByteArray(file,drawStr+".png",bytes);
					
				}

			}

		}
		
		

		

		
		
		
		
		
		
		
		
		
	}
}