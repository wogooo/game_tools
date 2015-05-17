package com.YFFramework.core.ui.res
{
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.ui.movie.data.BitmapDataEx;
	import com.YFFramework.core.ui.yfComponent.controls.YFCD;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.core.utils.image.Cast;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;

	/** 资源链接类名
	 * @author yefeng
	 *2012-6-24下午3:29:24
	 */
	public class CommonFla
	{
		public static const Shadow:String="Shadow";
		/**show 数据
		 */		
		public static var  ShadowBitmapDataEx:BitmapDataEx;
		/** 鼠标点击场景产生的效果数据
		 */		
		public static var ClickEffectActionData:ActionData;
		
		public function CommonFla()
		{
		}
		/** 初始化 common fla文件的各个元件 
		 */		
		public static function initUI():void
		{
			////影子
			var shodowData:BitmapData=ClassInstance.getInstance(Shadow) as BitmapData;
			ShadowBitmapDataEx=new BitmapDataEx();
			ShadowBitmapDataEx.bitmapData=shodowData;
			ShadowBitmapDataEx.x=-shodowData.width*0.5;
			ShadowBitmapDataEx.y=-shodowData.height*0.5;
			
			
			var mc:MovieClip=ClassInstance.getInstance("ClickEffectMc") as MovieClip;
			ClickEffectActionData=Cast.MCToActionData(mc,30);
			mc.stop();
			mc=null;
			///初始化CD数据
			YFCD.iniCD();
			
			
			
			
			
		}
	}
}