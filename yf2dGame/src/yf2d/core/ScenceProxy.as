package yf2d.core
{
	import flash.geom.Rectangle;
	
	import yf2d.errors.SingletonError;

	/**
	 * author :夜枫
	 * 时间 ：2011-11-25 下午02:17:09
	 * 
	 * 舞台 GPU渲染大小代理
	 */
	public  final class ScenceProxy
	{
		private static var _instance:ScenceProxy;
		private var _rect:Rectangle;
		
		public function ScenceProxy()
		{
			if(_instance) throw new SingletonError();
		}
		public static  function get Instance():ScenceProxy
		{
			if(!_instance) _instance=new ScenceProxy();
			return _instance;
		}
		/** 初始化舞台的 范围大小
		 */
		public function initScence(_x:Number,_y:Number,_stage3dWidth:Number,_stage3dHeight:Number):void
		{
			_rect=new Rectangle(_x,_y,_stage3dWidth,_stage3dHeight);
		}
		
		
		/** 渲染舞台背景
		 */
		public function get scenceRect():Rectangle
		{
			if(!_rect) throw new Error("ScenceProxy没有进行初始化.");
			return _rect;
		}
	}
}