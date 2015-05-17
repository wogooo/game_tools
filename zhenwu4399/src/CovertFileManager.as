package
{
	
	/**   真武封神 技能方向   资源转化
	 */	
	import com.YFFramework.core.ui.movie.data.TypeAction;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.geom.Matrix;

	/**   将4399  远古封神 英雄远征等游戏转化为序列帧   然后再旋转图片方向
	 * 
	 * 2012-7-24 下午12:35:03
	 *@author yefeng
	 */
	public class CovertFileManager
	{
		public function CovertFileManager()
		{
		}
		
		
		
		
		
		
		/**  真武封神4399转化
		 * @param mc
		 * @param isPlayer
		 * @return 
		 */		
		public static function convertSkill(mc:MovieClip):Vector.<BitmapDataName>
		{  
			
			var px:int=-400;
			var py:int=-400;
			var width:int=1600;
			var height:int=1600;
			var len:int=mc.totalFrames;
			var data:BitmapDataName;
			var mat:Matrix=new Matrix();
			mat.tx=-px;
			mat.ty=-py;
			var direction:int;
			var myName:String;
			var myIndex:int=0;
			var arr:Vector.<BitmapDataName>=new Vector.<BitmapDataName>();
			var j:int;
			for(var i:int=1;i<=len;++i)
			{
				mc.gotoAndStop(i);
				myIndex++;
				j=i-1;
				
				direction=int(j/6)+1;;
			//	direction=6-direction;
				myName="3-"+direction+"-"+myIndex
				data=new BitmapDataName(width,height,true,0xFFFFFF);
				data.draw(mc,mat);
				data.name=myName
				arr.push(data);
			}
			return arr;
		}
		
		
		/**  真武封神4399转化 具有方向的技能
		 * @param mc
		 * @param isPlayer
		 * @return 
		 */		
		public static function convertDirectionSkill(mc:MovieClip):Vector.<BitmapDataName>
		{  
			
			var px:int=-400;
			var py:int=-400;
			var width:int=1600;
			var height:int=1600;
			var len:int=mc.totalFrames;
			var data:BitmapDataName;
			var mat:Matrix=new Matrix();
			mat.tx=-px;
			mat.ty=-py;
			var direction:int;
			var myName:String;
			var myIndex:int=0;
			var arr:Vector.<BitmapDataName>=new Vector.<BitmapDataName>();
			var j:int;
			for(var i:int=1;i<=len;++i)
			{
				mc.gotoAndStop(i);
				myIndex++;
				j=i-1;
				
				direction=int(j/8)+1;;
				//	direction=6-direction;
				myName="3-"+direction+"-"+myIndex
				data=new BitmapDataName(width,height,true,0xFFFFFF);
				data.draw(mc,mat);
				data.name=myName
				arr.push(data);
			}
			return arr;
		}
		
		/**  将图片按照Y轴方向翻转
		 */
//		public static function flipYPic(data:BitmapDataName):BitmapDataName
//		{
//			var mat:Matrix=new Matrix();
//			mat.scale(-1,1);
//			mat.tx=data.width;
//			var bitmapDataName:BitmapDataName=new BitmapDataName(data.width,data.height,true,0xFFFFFF);
//			bitmapDataName.draw(data,mat);
//			bitmapDataName.name=data.name;
//			data.dispose();
//			return bitmapDataName;
//		}
		
	}
}