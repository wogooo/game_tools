package com.YFFramework.game.core.global.util
{
	
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.game.ui.layer.LayerManager;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	/**
	 * @author zhoujun
	 * @E-mail: 214501728@qq.com
	 * @version 1.0.0
	 * creation time：2012-9-14 上午10:18:47
	 * 
	 */
	public class ZHitTester
	{
		//======================================================================
		//        property
		//======================================================================
		private static var pixBmd:BitmapData;
		//======================================================================
		//        constructor
		//======================================================================
		
		public function ZHitTester()
		{
		}
		
		//======================================================================
		//        public function
		//======================================================================
		public static function hitTest(obj:DisplayObject, pt:Point) : Boolean
		{
			var hit:Boolean = false;
			var rect:Rectangle = null;
			var matrix:Matrix = null;
			var pix:uint = 0;
			var rec:Rectangle = obj.getBounds((obj as DisplayObject).parent);
			if (rec.containsPoint(pt))
			{
				rect = new Rectangle(-15, -80, 30, 80);
				if (rect.containsPoint(new Point(obj.mouseX, obj.mouseY)))
				{
					hit = true;
				}
				pixBmd = new BitmapData(1, 1, true, 0);
				matrix = new Matrix();
				matrix.tx = -int(obj.mouseX);
				matrix.ty = -int(obj.mouseY);
				pixBmd.draw(obj, matrix, null, null, new Rectangle(0, 0, 1, 1));
				pix = pixBmd.getPixel32(0, 0) >> 24 & 255;
				if (pix > 40)
				{
					hit = true;
				}
			}
			return hit;
		}
		
		public static function checkIMoveGrid(inter:*):*{
		
			var crtChildAry:Array = LayerManager.WindowLayer.getObjectsUnderPoint(new Point(StageProxy.Instance.stage.mouseX, 
				StageProxy.Instance.stage.mouseY));	
			for(var i:int = crtChildAry.length - 1; i>=0; i--){
				var obj:* = crtChildAry[i];
				if((obj is TextField) == false){
					var tmpObj:DisplayObject = null;
					if (obj is inter)
					{
						return obj;
					}
					while (obj.parent != null)
					{
						
						tmpObj = obj.parent;
						if (tmpObj is inter)
						{
							return tmpObj;
						}
						obj = tmpObj;
					}
					return null;
				}
			}
			return null;
		
		}
		

		
		public static function checkClass(obj:DisplayObject, theClass:Class):Boolean{
			var tmpObj:DisplayObject = null;
			if (obj is theClass)
			{
				return true;
			}
			while (obj && obj.parent != null)
			{
				
				tmpObj = obj.parent;
				if (tmpObj is theClass)
				{
					return true;
				}
				obj = tmpObj;
			}
			return false;
		}
		
		public static function getCheckClassObj(obj:DisplayObject,theClass:Class):DisplayObject{
			var tmpObj:DisplayObject = null;
			if (obj is theClass)
			{
				return obj;
			}
			while (obj.parent != null)
			{
				
				tmpObj = obj.parent;
				if (tmpObj is theClass)
				{
					return tmpObj;
				}
				obj = tmpObj;
			}
			return null;
		}
		
		public static function checkIsTypeClass(obj:DisplayObject, classAry:Array) : Boolean
		{
			var tmpObj:DisplayObject = null;
			var count:int = 0;
			while (obj.parent != null)
			{
				
				tmpObj = obj.parent;
				count = 0;
				while (count < classAry.length)
				{
					
					if (tmpObj is classAry[count])
					{
						return true;
					}
					count++;
				}
				obj = tmpObj;
			}
			return false;
		}
		//======================================================================
		//        private function
		//======================================================================
		
		//======================================================================
		//        event handler
		//======================================================================
		
		//======================================================================
		//        getter&setter
		//======================================================================
		
		
	}
} 