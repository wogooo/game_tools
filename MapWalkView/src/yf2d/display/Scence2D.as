package yf2d.display
{
	import flash.display3D.Context3D;
	
	import yf2d.core.ScenceProxy;
	import yf2d.material.BatchMaterial;

	/**
	 * author :夜枫
	 * 时间 ：2011-11-12 上午11:13:54
	 * 
	 * Scence2d只能添加 Sprite2d类型的量    使用 addSprite2d   addSprite2dAt  方法   移除  方法还是使用removeChild
	 */
	public final class Scence2D extends DisplayObjectContainer2D
	{
		public function Scence2D()
		{
			super();
		}
		/*	
		override public function render(context3d:Context3D,shader2d:Shader2d):void
		{
			var len:int=numChildren;
			///先画最上面的   也就是最后添加的 
			var child:Sprite2d;
			for(var i:int=0;i!=len;++i)
			{
				child=getChildAt(i) as Sprite2d;
				if(child) child.render(context3d,shader2d);
			}
	
		
		}
	*/	
		public function get scenceWidth():Number{		return ScenceProxy.Instance.scenceRect.width;			}
		public function get scenceHeight():Number{	return ScenceProxy.Instance.scenceRect.height;				}
		
//		public function addSprite2d(sprite2d:DisplayObjectContainer2d):void
//		{
//			addSprite2dAt(sprite2d,numChildren)
//		}
//		
//		public function  addSprite2dAt(sprite2d:DisplayObjectContainer2d,index:int):void
//		{
//			super.addChildAt(sprite2d,index);
//		}
//		
//		
//		override public function  addChild(child:DisplayObject2D):DisplayObject2D
//		{          
//			return super.addChild(child);
//		}
//		override public function addChildAt(child:DisplayObject2d,index:int):DisplayObject2d
//		{
//			throw new Error("请使用 addSprite2dAt方法");
//			return null;
//		}

	
	}
}