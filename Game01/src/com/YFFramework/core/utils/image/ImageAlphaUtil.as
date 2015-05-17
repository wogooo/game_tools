package  com.YFFramework.core.utils.image
{  
	
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	
	
	
	
	/**
	 * 合成透明通道的类   将 rbg 和  ra图片合成具有透明通道的工具     
	 * 
	 * 拆分注意  1   是 rbg 必须必  带通道的图片 ra  宽高 小一个 像素 这样 很成的图片才不会产生边线
	 * 			2   才拆分时  在用非透明的 Bitmap保存 图片信息时，他的背景色是会对合成的图片早晨影响的 背景色的颜色值与最终的很成的图片的边线颜色值相近,请注意:
	 * author :夜枫
	 * 时间 ：2011-12-18 下午12:49:44
	 */
	public class ImageAlphaUtil
	{
		private static const pt:Point=new Point();
		public function ImageAlphaUtil()
		{
		}
		
		/**
		 * @param data_rbg   rgb 的BitmapData对象
		 * @param data_ra   透明通道保存在 red 通道 的BitmapData对象 
		 * @return 具有透明通道的像素源
		 */		
		private static  var rect:Rectangle=new Rectangle();
		/** 合成图像   bgColor的值无关紧要  主要是拆分的时候 要主要注意背景色 
		 */
		public static  function  MergeAlphaData(data_rbg:BitmapData,data_ra:BitmapData,bgColor:uint=0xFF00FF00):BitmapData
		{
			
			//	var time:int=getTimer();
			//	var rect:Rectangle=new Rectangle(0,0,data_rbg.width,data_rbg.height);
			rect.width=data_rbg.width;
			rect.height=data_rbg.height;
			var merge:BitmapData=new BitmapData(data_rbg.width,data_rbg.height,true,bgColor);
			//复制 rbg像素 
			merge.lock();
			//复制 rbg像素 
			merge.copyPixels(data_rbg,rect,pt);
			//复制透明通道
			merge.copyChannel(data_ra,rect,pt,BitmapDataChannel.RED,BitmapDataChannel.ALPHA);
			merge.unlock()
			//		trace("耗时为:::::===========::",getTimer()-time);
			return merge;
		}
		
		/** 将 pngBitmapData 转化为    rbg_bitmapData 和 ra_bitmapData 
		 * bgColor的颜色值很重要  设置不同的颜色值产生的效果是不一样的  bgColor与最终的合成图像的边上有关
		 * 返回  [rbg_bitmapData,ra_bitmapData]
		 */		
		public static  function spliteAlphaData(pngBitmapData:BitmapData,bgColor:uint=0xFFFFFF):Vector.<BitmapData>
		{
			var rect:Rectangle=new Rectangle(0,0,pngBitmapData.width,pngBitmapData.height);
			var rbg_data:BitmapData=new BitmapData(pngBitmapData.width,pngBitmapData.height,false,bgColor);
			var ra_data:BitmapData=new BitmapData(pngBitmapData.width,pngBitmapData.height,false,bgColor);
			rbg_data.lock();
			///复制 rbg 
			rbg_data.copyPixels(pngBitmapData,rect,pt);
			
			// rbg缩小一像素
			var expand:BitmapData=new BitmapData(ra_data.width-1,ra_data.height-1,false,bgColor);
			var bmp:Bitmap=new Bitmap(rbg_data);
			bmp.scaleX=(rbg_data.width-1)/rbg_data.width;
			bmp.scaleY=(rbg_data.height-1)/rbg_data.height;
			expand.draw(bmp);
			rbg_data.dispose();
			rbg_data=expand;
			bmp=null;
			
			///将alpha通道保存到  red通道
			ra_data.copyChannel(pngBitmapData,rect,pt,BitmapDataChannel.ALPHA,BitmapDataChannel.RED);
			rbg_data.unlock();
			return Vector.<BitmapData>([rbg_data,ra_data]);
		}
		
		
		
		
		
	}
}