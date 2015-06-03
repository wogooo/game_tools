package com.dolo.ui.tools
{
	import com.dolo.ui.controls.Button;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.text.TextField;

	/**将 flash的 mc 替换成相应的组件
	 * @author yefeng
	 * 2013 2013-7-24 上午11:17:25 
	 */
	public class SimpleBuild
	{
		public function SimpleBuild()
		{
		}
		/** 替换 按钮
		 * @param parentMC 为父 容器 
		 * @param childMCName 问哦子对象的 名称
		 */		
		public static function replaceButton(parentMC:MovieClip,childMCName:String):Button
		{
			var dis:MovieClip=parentMC.getChildByName(childMCName) as MovieClip;
			var index:int=parentMC.getChildIndex(dis);
			var disWidth:Number=dis.width;
			var disHeight:Number=dis.height;
			var mX:Number=dis.x;
			var mY:Number=dis.y;
			var obj:Object={};
			var btn:Button = new Button();
			btn.label = findLable(dis,obj);
			btn.targetSkin(dis);
			if(obj.format)	btn.setFormat(obj.format);
			btn.name=childMCName;
			btn.x = mX;
			btn.y = mY;
			parentMC.addChildAt(btn,index);
			btn.setSize(disWidth,disHeight);
			return btn;
		}
		/**将  childMCName 替换为  myClass 类型
		 */		
		public static function replaceToClass(parentMC:MovieClip,childMCName:String,myClass:Class):*
		{
			var dis:MovieClip=parentMC.getChildByName(childMCName) as MovieClip;
			var index:int=parentMC.getChildIndex(dis);
			var mX:Number=dis.x;
			var mY:Number=dis.y;
			parentMC.removeChild(dis);
			delete parentMC[childMCName];
			var mc:DisplayObject=new myClass() as DisplayObject;
			mc.name=childMCName;
			mc.x=mX;
			mc.y=mY;
			parentMC.addChildAt(mc,index);
			return mc;
		}
		
		
		
		private static function findLable(labelDisplayObj:DisplayObject,obj:Object):String
		{
			var parent:DisplayObjectContainer = labelDisplayObj.parent;
			var len:uint = parent.numChildren;
			var txt:TextField;
			for(var i:int=0;i!=len;++i)
			{
				txt=parent.getChildAt(i) as TextField;
				if(txt)
				{
					if(txt.x>labelDisplayObj.x && txt.x < labelDisplayObj.x+labelDisplayObj.width/2
						&& txt.y > labelDisplayObj.y && txt.y < labelDisplayObj.y+labelDisplayObj.height/2)
					{
						txt.parent.removeChild(txt);
						if(obj)
						{
							var format:flash.text.TextFormat=txt.getTextFormat();
							obj.format=format;
						}
						return txt.text.split("\r").join("");
					}
				}
			}
			return "";
		}
	}
}