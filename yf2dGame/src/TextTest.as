package
{
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	import com.YFFramework.core.text.HTMLUtil;
	import com.YFFramework.core.text.RichText;
	import com.YFFramework.core.text.TextObject;
	import com.YFFramework.core.ui.yfComponent.controls.YFChatArrow;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	
	/**2012-10-25 上午10:49:51
	 *@author yefeng
	 */
	public class TextTest extends Sprite
	{
		private var _richText:RichText;
		public function TextTest()
		{
			loadSWF();
		}
		
		private function loadSWF():void
		{
			var url:String="http://static.mygame.com/common/loading/face.swf";
			var loader:UILoader=new UILoader();
			loader.loadCompleteCallback=loaded;
			loader.initData(url);
		}
		
		private function loaded(content:DisplayObject,data:Object):void
		{
			RichText.resLoadComplete=true;
			initUI();
			addEvents();
			intTest();
		}
		private function intTest():void
		{
			var str:String="/00//700/81/72/73/69/09";
			var reg:RegExp=/(\/[0-6][0-9])|7[0-1]/g; ///匹配 00--69 和   70- 71 也就是匹配 00-71
			trace(str.match(reg))
			var txt:TextField=new TextField();
			txt.autoSize="left";
		}
		
		
		private function initUI():void
		{
			_richText=new RichText();
			addChild(_richText);
			_richText.width=240;
			_richText.x=200;
			_richText.y=200;
		//	_richText.setSimpleText("大家好啊！",null,onLink);
			var strArr:Array=[["美好的/71是吗啊啊啊啊啊 啊啊啊啊啊 啊啊啊啊啊啊 啊啊啊啊啊啊啊啊啊啊啊啊啊啊 啊啊啊啊啊啊 啊啊啊啊啊啊 啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊"],["20081411",new TextObject("#FF0000","#999999","#666666")],["班级"],[",我永远爱着你们!"],["夜枫敬上!,娃哈哈大家一起来玩吧",new TextObject("#00FF00","#9999FF","#660066"),onLink,{test:"hellow word"}]]
			_richText.setText(strArr);
			var strArr2:Array=[["美好的/68"]]
		//	_richText.setText(strArr2);
				

		}
		
		private function addEvents():void
		{
			
		}
		private function onLink(obj:Object):void
		{
			trace("触发:"+obj.test);
		}

	}
}