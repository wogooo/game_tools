package manager
{
	
	import com.YFFramework.core.utils.image.BitmapDataUtil;
	
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * author :夜枫 * 时间 ：2011-10-2 上午11:35:17
	 * 
	 * 取对象的像素数据
	 */
	public class Cast
	{
		public function Cast()
		{
		}
		
		public static function  Draw(source:IBitmapDrawable):BitmapData
		{
			var bmp:BitmapData=new BitmapData(Object(source).width,Object(source).height,true,0x336699);
			bmp.draw(source);
			return bmp;
		}
		
		public static function Draw2(_class:Class):BitmapData
		{
			var obj:IBitmapDrawable=new _class();
			return Draw(obj);
		}
		
		/**  将影片剪辑转化为最小序列图
		 * pivot为轴店 pivot为第一张图片的的中心点位置  向哪个方向偏移
		 *   将  movieClip转化为 BitmapDataEx的序列帧数据
		 */
		public static function MCToSequence(mc:MovieClip,pivot:Point=null):Vector.<BitmapDataEx>
		{
			var len:int=mc.totalFrames;
			var width:Number=3000;
			var height:Number=3000;
			var data:BitmapData;
			var dataEx:BitmapDataEx;
			var minRect:Rectangle;
			var mat:Matrix;
			var arr:Vector.<BitmapDataEx>=new Vector.<BitmapDataEx>();
			var myPivot:Point;
			var mcMat:Matrix=new Matrix();
			mcMat.tx=-1000;
			mcMat.ty=-1000;
			for(var i:int=1;i<=len;++i)
			{
				data=new BitmapData(width,height,true,0xFFFFFF);
				mc.gotoAndStop(i);
				data.draw(mc,mcMat);
				///得到最小区域
				minRect=BitmapDataUtil.getMinRect(data);
				minRect.width=minRect.width==0?1:minRect.width;
				minRect.height=minRect.height==0?1:minRect.height;
				dataEx=new BitmapDataEx();
				dataEx.bitmapData=new BitmapData(minRect.width,minRect.height,true,0xFFFFFF);
				mat=new Matrix();
				mat.tx=-minRect.x;
				mat.ty=-minRect.y;
				dataEx.bitmapData.draw(data,mat);
				data.dispose();
				if(i==1) 
				{
					myPivot=new Point(minRect.x+minRect.width*0.5,minRect.y+minRect.height*0.5);///取图片中间位置
					if(pivot)
					{
						myPivot.x=myPivot.x+pivot.x;
						myPivot.y=myPivot.y+pivot.y;
					}
				}
				dataEx.x=minRect.x-myPivot.x;
				dataEx.y=minRect.y-myPivot.y;
				arr.push(dataEx);
			}
			return arr;
		}
		
		
		/**
		 *  影片剪辑转化为 ActionData
		 * @param mc	影片剪辑
		 * @param frameRate  每张图片停留的时间 也就是两张图片切换的时间间隔
		 * @param pivot    相对于第一张图片左上角的偏移量
		 */
		public static function MCToActionData(mc:MovieClip,frameRate:int=30,pivot:Point=null):ActionData
		{
			var  arr:Vector.<BitmapDataEx>=MCToSequence(mc,pivot);
			///构建actionData
			var actionData:ActionData=new ActionData();
			var action:int=1;
			var direction:int=1;
			actionData.headerData={};
			//		actionData.headerData["version"]="2.01";
			//		actionData.headerData["blood"]={x:0,y:0}
			actionData.headerData["action"]=[action];  //设动作为1 
			actionData.headerData[action]={};
			actionData.headerData[action]["direction"]=[direction];
			actionData.headerData[action]["frameRate"]=frameRate;
			actionData.headerData[action][direction]={};
			actionData.headerData[action][direction]["len"]=arr.length;
			actionData.dataDict[action]={};
			actionData.dataDict[action][direction]=arr;
			return actionData;			
		}
		
		
	}
}