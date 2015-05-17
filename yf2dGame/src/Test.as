package
{
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.event.ParamEvent;
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.ui.utils.Draw;
	import com.YFFramework.core.utils.net.SourceCache;
	import com.YFFramework.core.utils.math.YFMath;
	import com.YFFramework.core.world.movie.thing.ThingRotateEffectView;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**2012-9-14 上午10:54:00
	 *@author yefeng
	 */
	public class Test extends Sprite
	{
		private var movei:ThingRotateEffectView;
		public function Test()
		{
			
			initUI();
			stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseEvent);
			addEventListener(Event.ENTER_FRAME,update);
		}
		private function update(e:Event):void
		{
			UpdateManager.Instance.update();
		}
		
		private function onMouseEvent(e:MouseEvent):void
		{
			movei.rotation +=10;
			var k:Number=(stage.mouseY-movei.pivotY+0.0001)/(stage.mouseX-movei.pivotX+0.0001)
			var rad:Number=Math.atan(k);
			trace("K:"+k);
			trace("坐标:",stage.mouseX,stage.mouseY,movei.pivotX,movei.pivotY);
			trace("弧度：："+rad);
			if (movei.pivotX<stage.mouseX)
			{
				rad +=  Math.PI;
			}
			var degree:Number=YFMath.radToDegree(rad);
			trace("角度："+degree)
			movei.rotation=degree;
		}
		private function initUI():void
		{
			var url:String="http://static.mygame.com/dyUI/movie/skill/41007.chitu";
			SourceCache.Instance.addEventListener(url,onComplete);
			SourceCache.Instance.loadRes(url);

			movei=new ThingRotateEffectView();
			addChild(movei);
			movei.start();
			movei.setPivotXY(200,200);
			var sp:Sprite=new Sprite();
			addChild(sp);
			Draw.DrawCircle(sp.graphics,5,movei.pivotX,movei.pivotY,0xFF0000);
			
		}
		
		private function onComplete(e:ParamEvent):void
		{
			var url:String=e.type
			movei.initData(SourceCache.Instance.getRes(url) as ActionData);
			movei.playDefault();
		}
	}
}